-- Copyright (c) 2017 Thaui
-- Copyright (c) 2021 Kirazy
-- Part of Vanilla Loaders
--
-- See LICENSE.md in the project directory for license information.

-- Train interactivity, copyright (c) 2021 Optera
local is_carriage_valid
local carriage_validation_parameters = {
    ["disabled"] = function ()
        return false
    end,
    ["auto-only"] = function (carriage)
        local train = carriage and carriage.valid and carriage.train
        return train and train.state == defines.train_state.wait_station
    end,
    ["all-carriages"] = function (carriage)
        local train = carriage and carriage.valid and carriage.train
        local train_state = train and train.state
        return train_state == defines.train_state.wait_station or train_state == defines.train_state.manual_control and train.speed == 0
    end
}

local interact_with_carriages = settings.global["vanillaLoaders-loader-carriage-interactivity"].value

local function create_carriage_validation_functions(interact_with_carriages)
    is_carriage_valid = carriage_validation_parameters[interact_with_carriages]
end

-- Snapping interactivity, copyright (c) 2021 Optera
local snapping = require("snapping")
local is_snapping_enabled = settings.global["vanillaLoaders-enable-snapping"].value
local supported_loaders = {} -- dictionary indexed by supported entity name
local supported_loader_names = {}  -- list of loader names for find_entities_filtered

-- Expose API to register loaders with the snapping script
remote.add_interface("vanilla-loaders", {
    -- add loader name if it doesn't already exist
    add_loader = function(name)
        if name then
            supported_loaders[name] = true

            -- Rebuild list of supported loaders
            supported_loader_names = {}
            for loader, _ in pairs(supported_loaders) do
                table.insert(supported_loader_names, loader)
            end
        end
    end,

    -- remove loader name
    remove_loader = function(name)
        if name then
            supported_loaders[name] = nil

            -- Rebuild list of supported loaders
            supported_loader_names = {}
            for loader, _ in pairs(supported_loaders) do
                table.insert(supported_loader_names, loader)
            end
        end
    end
})

-- Check for loaders that need to be snapped around rotated entities
local function on_rotated_events(event)
    snapping.check_for_loaders(event, supported_loader_names)
end

-- CARRIAGE / LOADER INTERACTIVITY WORKER FUNCTIONS
-- Remove loaders that do not need to be worked
local function clean_loaders_table()
	for i, mapping in pairs(global.loaders) do
		if mapping[1].valid == false or not is_carriage_valid(mapping[2]) then
			global.loaders[i] = nil
		end
	end
end

-- Locates loaders adjacent to the given carriage, and inserts the mapping into global.loaders for valid carriages
local function find_adjacent_loader(carriage, entity)
    if is_carriage_valid(carriage) then
        if carriage.orientation == 0 or carriage.orientation == 0.5 then
            for _, loader in pairs(carriage.surface.find_entities_filtered{type = "loader", area = {{carriage.position.x-1.5, carriage.position.y-2.2}, {carriage.position.x-0.5, carriage.position.y+2.2}}}) do
                if entity and loader == entity then
                    table.insert(global.loaders, {loader, carriage, 6})
                elseif entity == nil then
                    table.insert(global.loaders, {loader, carriage, 6})
                end
            end
            for _, loader in pairs(carriage.surface.find_entities_filtered{type = "loader", area = {{carriage.position.x+0.5, carriage.position.y-2.2}, {carriage.position.x+1.5, carriage.position.y+2.2}}}) do
                if entity and loader == entity then
                    table.insert(global.loaders, {loader, carriage, 2})
                elseif entity == nil then
                    table.insert(global.loaders, {loader, carriage, 2})
                end
            end
        elseif carriage.orientation == 0.25 or carriage.orientation == 0.75 then
            for _, loader in pairs(carriage.surface.find_entities_filtered{type = "loader", area = {{carriage.position.x-2.2, carriage.position.y-1.5}, {carriage.position.x+2.2, carriage.position.y-0.5}}}) do
                if entity and loader == entity then
                    table.insert(global.loaders, {loader, carriage, 0})
                elseif entity == nil then
                    table.insert(global.loaders, {loader, carriage, 0})
                end
            end
            for _, loader in pairs(carriage.surface.find_entities_filtered{type = "loader", area = {{carriage.position.x-2.2, carriage.position.y+0.5}, {carriage.position.x+2.2, carriage.position.y+1.5}}}) do
                if entity and loader == entity then
                    table.insert(global.loaders, {loader, carriage, 4})
                elseif entity == nil then
                    table.insert(global.loaders, {loader, carriage, 4})
                end
            end
        end
    end
end

-- When train states change, check for adjacent loaders
local function on_train_updates(event)
	for _, carriages in pairs(event.train.carriages) do
		find_adjacent_loader(carriages)
	end
end

-- When carriages or loaders are constructed, check for adjacent carriages/loaders
local function on_built_events(event)
	local entity = event.created_entity
	if entity.type == "loader" and supported_loaders[entity.name] then
        -- Snap the loader
        if is_snapping_enabled then snapping.snap_loader(entity, event) end

        -- Map loaders to carriages for cargo wagons
		local cargo_wagons = entity.surface.find_entities_filtered{type = "cargo-wagon", area = {{entity.position.x-2,entity.position.y-2}, {entity.position.x+2,entity.position.y+2}}}
		for _, carriage in pairs(cargo_wagons) do
			find_adjacent_loader(carriage, entity)
		end

        -- Map loaders to carriages for locomotives
		local locomotives = entity.surface.find_entities_filtered{type = "locomotive", area = {{entity.position.x-2,entity.position.y-2}, {entity.position.x+2,entity.position.y+2}}}
		for _, carriage in pairs(locomotives) do
			find_adjacent_loader(carriage, entity)
		end

    -- Find loaders adjacent to cargo wagons
	elseif entity.type == "cargo-wagon" then
		find_adjacent_loader(entity)
        if is_snapping_enabled then snapping.check_for_loaders(event, supported_loader_names) end

    -- Find loaders adjacent to locomotives
	elseif entity.type == "locomotive" then
		find_adjacent_loader(entity)
        if is_snapping_enabled then snapping.check_for_loaders(event, supported_loader_names) end
	end
end

-- Checks that the loader is facing the correct direction for the work to be performed
local function is_loader_active(loader, direction)
	if loader.loader_type == "output" and loader.direction == direction then
		return true
	elseif loader.loader_type == "input" and loader.direction == (direction+4)%8 then
		return true
	else
        return false
	end
end

-- Constructs a table of items that are set in a loader's filter slots
local function get_loader_filters(loader)
	local filter = {}
	for n = 1, loader.filter_slot_count do
		if loader.get_filter(n) then
			table.insert(filter, n, loader.get_filter(n))
		end
	end
	if #filter == 0 then filter = false end
	return filter
end

-- Handles transfer of items into/out of train inventories
local function do_loader_carriage_transfers(entity, carriage, direction)
	if carriage and is_carriage_valid(carriage.entity_owner) then
        -- Get the loaders throughput
        local available_items_per_lane = math.ceil((8 * entity.prototype.belt_speed)/2)
        local carriage_contents = carriage.get_contents()

        if entity.loader_type == "output" and is_loader_active(entity, direction) then
            local loader_filters = get_loader_filters(entity)

			for n = 1, 2 do
                local max_items_to_insert = available_items_per_lane
                local loader_transport_line = entity.get_transport_line(n)

                if not entity.belt_neighbours.outputs[1] then goto loader end

                -- Insert items from carriage into the connected transport lines
                if carriage.is_empty() == false then
                    -- Go through each of the connected transport lines and check if its the one we want, and remove items if it is
                    for i = 1, entity.belt_neighbours.outputs[1].get_max_transport_line_index() do
                        local connected_transport_line = entity.belt_neighbours.outputs[1].get_transport_line(i)
                        if connected_transport_line.line_equals(loader_transport_line) and connected_transport_line.can_insert_at_back() then
                            if loader_filters then
                                for name, count in pairs(carriage_contents) do
                                    for _, filtered_item_name in pairs(loader_filters) do
                                        if name == filtered_item_name then
                                            while count > 0 do
                                                carriage.remove({name = name, count = 1})
                                                connected_transport_line.insert_at_back({name = name, count = 1})
                                                count = count - 1
                                                max_items_to_insert = max_items_to_insert - 1
                                                if max_items_to_insert == 0 then goto continue end
                                            end
                                        end
                                    end
                                end
                            else
                                for name, count in pairs(carriage_contents) do
                                    while count > 0 do
                                        carriage.remove({name = name, count = 1})
                                        connected_transport_line.insert_at_back({name = name, count = 1})
                                        count = count - 1
                                        max_items_to_insert = max_items_to_insert - 1
                                        if max_items_to_insert == 0 then goto continue end
                                    end
                                end
                            end
                        end
                    end
                end

                ::loader::

                -- Insert items from carriage into the loader's transport lines
                if carriage.is_empty() == false and loader_transport_line.can_insert_at_back() then
                    if loader_filters then
                        for name, count in pairs(carriage_contents) do
                            for _, filtered_item_name in pairs(loader_filters) do
                                if name == filtered_item_name then
                                    while count > 0 do
                                        carriage.remove({name = name, count = 1})
                                        loader_transport_line.insert_at_back({name = name, count = 1})
                                        count = count - 1
                                        max_items_to_insert = max_items_to_insert - 1
                                        if max_items_to_insert == 0 then goto continue end
                                    end
                                end
                            end
                        end
                    else
                        for name, count in pairs(carriage_contents) do
                            while count > 0 do
                                carriage.remove({name = name, count = 1})
                                loader_transport_line.insert_at_back({name = name, count = 1})
                                count = count - 1
                                max_items_to_insert = max_items_to_insert - 1
                                if max_items_to_insert == 0 then goto continue end
                            end
                        end
                    end
                end

                ::continue::
            end

		elseif entity.loader_type == "input" and is_loader_active(entity, direction) then
            -- Iterate through the loader's transport lines
            for n = 1, 2 do
                local max_items_to_pull = available_items_per_lane
                local loader_transport_line = entity.get_transport_line(n)

                -- While the loader has items on its input lines
                if loader_transport_line.get_item_count() > 0 then
                    -- Pull items out of the loader's transport line
                    for name, count in pairs(loader_transport_line.get_contents()) do
                        -- For every item on the line, check it can be inserted into the cargo wagon and remove it from the line
                        while count > 0 do
                            if carriage.can_insert({name = name, count = 1}) then
                                loader_transport_line.remove_item({name = name, count = 1})
                                carriage.insert({name = name, count = 1})
                                count = count - 1
                                max_items_to_pull = max_items_to_pull - 1
                                if max_items_to_pull == 0 then goto continue end
                            end
                        end
                    end

                    if not entity.belt_neighbours.inputs[1] then break end

                    -- Go through each of the connected transport lines and check if its the one we want, and remove items if it is
                    for i = 1, entity.belt_neighbours.inputs[1].get_max_transport_line_index() do
                        local connected_transport_line = entity.belt_neighbours.inputs[1].get_transport_line(i)
                        if connected_transport_line.line_equals(loader_transport_line) then
                            for name, count in pairs(connected_transport_line.get_contents()) do
                                while count > 0 do
                                    if carriage.can_insert({name = name, count = 1}) then
                                        connected_transport_line.remove_item({name = name, count = 1})
                                        carriage.insert({name = name, count = 1})
                                        count = count - 1
                                        max_items_to_pull = max_items_to_pull - 1
                                        if max_items_to_pull == 0 then goto continue end
                                    end
                                end
                            end
                        end
                    end

                    ::continue::
                end
            end
		end
	end
end

local function create_loader_carriage_mapping()
    for _, entities in pairs(game.surfaces) do
        local cargo_wagons = entities.find_entities_filtered{type = "cargo-wagon"}
        if #cargo_wagons > 0 then
            for _, carriage in pairs(cargo_wagons) do
                find_adjacent_loader(carriage)
            end
        end

        local locomotives = entities.find_entities_filtered{type = "locomotives"}
        if #locomotives > 0 then
            for _, carriage in pairs(locomotives) do
                find_adjacent_loader(carriage)
            end
        end
    end
end

-- On tick
local function on_tick(event)
    -- Create the loaders table if it doesn't already exist
	if global.loaders == nil then
        -- Setup loaders table
		global.loaders = {}
        create_loader_carriage_mapping()

	elseif #global.loaders > 0 then
		clean_loaders_table()

        -- Transfer items between loaders and carriages
		for _, mapping in pairs(global.loaders) do
			do_loader_carriage_transfers(mapping[1], mapping[2].get_inventory(defines.inventory.cargo_wagon), mapping[3])
		end
	end
end

-- INITIALIZATION
-- Register loaders for snapping logic
local function register_loaders()
	if remote.interfaces["vanilla-loaders"] then
        -- Vanilla loaders
            remote.call("vanilla-loaders", "add_loader", "loader")
            remote.call("vanilla-loaders", "add_loader", "fast-loader")
            remote.call("vanilla-loaders", "add_loader", "express-loader")

        -- Bob's mods loaders
            remote.call("vanilla-loaders", "add_loader", "basic-loader")
            remote.call("vanilla-loaders", "add_loader", "purple-loader")
            remote.call("vanilla-loaders", "add_loader", "green-loader")

        -- Ultimate Belts loaders
            remote.call("vanilla-loaders", "add_loader", "ub-ultra-fast-loader")
            remote.call("vanilla-loaders", "add_loader", "ub-extreme-fast-loader")
            remote.call("vanilla-loaders", "add_loader", "ub-ultra-express-loader")
            remote.call("vanilla-loaders", "add_loader", "ub-extreme-express-loader")
            remote.call("vanilla-loaders", "add_loader", "ub-ultimate-loader")
    end
end

local function set_event_registrations()
    -- Stop listening to events, scripting work is disabled
    if interact_with_carriages == "disabled" then
        script.on_event({defines.events.on_train_changed_state, defines.events.on_train_created}, nil)
        script.on_event({defines.events.on_built_entity, defines.events.on_robot_built_entity}, nil)
        script.on_event(defines.events.on_tick, nil)
    -- Re-register for events with updated validation functions
    else
        script.on_event({defines.events.on_train_changed_state, defines.events.on_train_created}, on_train_updates)
        script.on_event({defines.events.on_built_entity, defines.events.on_robot_built_entity}, on_built_events)
        script.on_event(defines.events.on_tick, on_tick)
    end

    -- Handle snapping registrations
    if is_snapping_enabled then
        script.on_event(defines.events.on_player_rotated_entity, on_rotated_events)
    else
        script.on_event(defines.events.on_player_rotated_entity, nil)
    end
end

-- Script executions
script.on_load(function()
	register_loaders()
    create_carriage_validation_functions(interact_with_carriages)
    set_event_registrations()
end)

script.on_init(function()
	register_loaders()
    create_carriage_validation_functions(interact_with_carriages)
    set_event_registrations()
end)

script.on_configuration_changed(function()
	register_loaders()
    create_carriage_validation_functions(interact_with_carriages)
    set_event_registrations()

    -- Update the loader/carriage mapping
    if not global.loaders then
        global.loaders = {}
        create_loader_carriage_mapping()

    elseif #global.loaders > 0 then
        -- Configuration changed, formerly valid entities may be invalid
		clean_loaders_table()

        -- Iterate through the cargo wagons and locomotives, add them to the table
        create_loader_carriage_mapping()
    end
end)

-- Settings updates
script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
    if event.setting == "vanillaLoaders-enable-snapping" then
        is_snapping_enabled = settings.global["vanillaLoaders-enable-snapping"].value
        set_event_registrations()
    end

    if event.setting == "vanillaLoaders-loader-carriage-interactivity" then
        -- Update the carriage validation functions to the new value
        interact_with_carriages = settings.global["vanillaLoaders-loader-carriage-interactivity"].value
        create_carriage_validation_functions(interact_with_carriages)
        set_event_registrations()

        if interact_with_carriages ~= "disabled" then
            create_loader_carriage_mapping()
        else
            clean_loaders_table()
        end
    end
end)