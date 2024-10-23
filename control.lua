-- Copyright (c) 2024 Kirazy
-- Part of Vanilla Loaders
--
-- See LICENSE.md in the project directory for license information.

-- This was adapted from another mod's snapping code, but whose is lost to time.
--
-- If you recognize the code this was adapted from, please reach out, as I would like to properly
-- attribute it.

local snap_targets = {
    "ammo-turret",
    "artillery-turret",
    "assembling-machine",
    "boiler",
    "container",
    "furnace",
    "infinity-container",
    "lab",
    "linked-container",
    "logistic-container",
    "mining-drill",
    "reactor",
    "rocket-silo",
    "straight-rail",
}

---@type EventFilter
local event_filter = {
    {
        filter = "type",
        type = "loader",
    },
}

local do_loader_snapping = settings.global["vanillaLoaders-do-loader-snapping"].value

---Updates `do_loader_snapper` to the current value of the setting if the setting has changed.
---Handles the on_runtime_mod_setting_changed event.
---@param event EventData.on_runtime_mod_setting_changed
local function on_setting_changed_handler(event)
    if event.setting == "vanillaLoaders-do-loader-snapping" then
        do_loader_snapping = settings.global["vanillaLoaders-do-loader-snapping"].value
    end
end

script.on_event(defines.events.on_runtime_mod_setting_changed, on_setting_changed_handler)

---Snaps the given `loader` entity to its neighbor, as appropriate.
---@param loader LuaEntity
local function snap_to_neighbor(loader)
    if not do_loader_snapping then return end

    local surface = loader.surface
    local force_name = loader.force.name
    local original_direction = loader.direction
    local original_type = loader.loader_type
    local x, y = loader.position.x, loader.position.y
    local from_x, from_y, to_x, to_y
    local is_entity_connected

    if original_direction == defines.direction.north then
        from_x, from_y = x, y + 1
        to_x, to_y = x, y - 1
    elseif original_direction == defines.direction.east then
        from_x, from_y = x - 1, y
        to_x, to_y = x + 1, y
    elseif original_direction == defines.direction.south then
        from_x, from_y = x, y - 1
        to_x, to_y = x, y + 1
    elseif original_direction == defines.direction.west then
        from_x, from_y = x + 1, y
        to_x, to_y = x - 1, y
    end

    if original_type == "output" then
        -- If loader outputs onto a belt-connectible entity, then exit
        if next(loader.belt_neighbours.outputs) then return end

        -- Note whether loader would output from an entity in original configuration
        loader.update_connections()
        if loader.loader_container then is_entity_connected = true end

        -- Switch loader type and see if it connects to a belt-connectible entity
        loader.loader_type = "input"
        if next(loader.belt_neighbours.inputs) then return end

        -- Flip loader and see if it connects to a belt connectible entity or container
        loader.direction = original_direction
        if next(loader.belt_neighbours.inputs) then return end

        loader.update_connections()

        -- Determine if original configuration should be restored
        if is_entity_connected or
            surface.count_entities_filtered { ghost_type = snap_targets, position = { from_x, from_y }, force = force_name, limit = 1 } > 0 or
            surface.count_entities_filtered { type = "straight-rail", position = { from_x, from_y }, force = force_name, limit = 1 } > 0 or
            (not loader.loader_container and
                surface.count_entities_filtered { ghost_type = snap_targets, position = { to_x, to_y }, force = force_name, limit = 1 } == 0 and
                surface.count_entities_filtered { type = "straight-rail", position = { to_x, to_y }, force = force_name, limit = 1 } == 0) then
            loader.loader_type = original_type
            loader.direction = original_direction
        end
    else
        -- If loader takes input from a belt-connectible entity, then exit
        if next(loader.belt_neighbours.inputs) then return end

        -- Note whether loader would input to an entity in original configuration
        loader.update_connections()
        if loader.loader_container then is_entity_connected = true end

        -- Switch loader type and see if it connects to a belt-connectible entity
        loader.loader_type = "output"
        if next(loader.belt_neighbours.outputs) then return end

        -- Flip loader and see if it connects to a belt connectible entity or container
        loader.direction = original_direction
        if next(loader.belt_neighbours.outputs) then return end

        loader.update_connections()

        -- Determine if original configuration should be restored
        if is_entity_connected or
            surface.count_entities_filtered { ghost_type = snap_targets, position = { to_x, to_y }, force = force_name, limit = 1 } > 0 or
            surface.count_entities_filtered { type = "straight-rail", position = { to_x, to_y }, force = force_name, limit = 1 } > 0 or
            (not loader.loader_container and
                surface.count_entities_filtered { ghost_type = snap_targets, position = { from_x, from_y }, force = force_name, limit = 1 } == 0 and
                surface.count_entities_filtered { type = "straight-rail", position = { from_x, from_y }, force = force_name, limit = 1 } == 0) then
            loader.loader_type = original_type
            loader.direction = original_direction
        end
    end
end

---Handles the creation event for a loader entity.
---@param event EventData.on_built_entity|EventData.on_robot_built_entity|EventData.on_entity_cloned|EventData.script_raised_built|EventData.script_raised_revive
local function on_entity_created_handler(event)
    local entity = event.created_entity or event.entity or event.destination
    if not storage.subscribed_loaders[entity.name] then return end

    snap_to_neighbor(entity)
end

script.on_event(defines.events.on_built_entity, on_entity_created_handler, event_filter)
script.on_event(defines.events.on_robot_built_entity, on_entity_created_handler, event_filter)
script.on_event(defines.events.on_entity_cloned, on_entity_created_handler, event_filter)
script.on_event(defines.events.script_raised_built, on_entity_created_handler, event_filter)
script.on_event(defines.events.script_raised_revive, on_entity_created_handler, event_filter)

---Subscribes the loader entity with the given `name` to the snapping logic.
---@param loader_name string # The name of the loader entity to subscribe.
local function subscribe(loader_name)
    if not loader_name then return end

    storage.subscribed_loaders = storage.subscribed_loaders or {}
    storage.subscribed_loaders[loader_name] = true
end

---Unsubscribes the loader entity with the given `name` from the snapping logic.
---@param loader_name string # The name of the loader entity to unsubscribe.
local function unsubscribe(loader_name)
    if not loader_name then return end

    storage.subscribed_loaders = storage.subscribed_loaders or {}
    storage.subscribed_loaders[loader_name] = nil
end

remote.add_interface("vanilla-loaders", { subscribe = subscribe, unsubscribe = unsubscribe })

local native_loaders = {
    "loader",
    "fast-loader",
    "express-loader",
    "basic-loader",
    "purple-loader",
    "green-loader",
    "ub-ultra-fast-loader",
    "ub-extreme-fast-loader",
    "ub-ultra-express-loader",
    "ub-extreme-express-loader",
    "ub-ultimate-loader",
}

---Subscribes all loaders natively managed by this mod to the snapping logic.
local function register_loaders()
    for _, loader_name in pairs(native_loaders) do
        remote.call("vanilla-loaders", "subscribe", loader_name)
    end
end

script.on_init(register_loaders)
script.on_configuration_changed(register_loaders)
