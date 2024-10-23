-- Copyright (c) 2024 Kirazy
-- Part of Vanilla Loaders
--
-- See LICENSE.md in the project directory for license information.

---@class VanillaLoadersApi
local api = {}

---Toggles debug mode. When `true`, debugging errors and logging are enabled.
local is_debug_mode = true

---Raises an error with the given `message` when `is_debug_mode` is `true`.
---@param message string
local function debug_error(message)
    if is_debug_mode then error("Vanilla Loaders: " .. message) end
end

---Prints the given `message` to the log when `is_debug_mode` is `true`.
---@param message string
local function debug_log(message)
    if is_debug_mode then log("Vanilla Loaders: " .. message) end
end

---Create an icons definition with the given `mask_tint` and `base_tint` colors.
---@param mask_tint? data.Color The color of the loader's directional arrows.
---@param base_tint? data.Color The color of the loader's metal frame and housing.
---@return data.IconData[]
local function get_loader_icons_data(mask_tint, base_tint)
    ---@type data.IconData[]
    local icon_data = {
        {
            icon = "__vanilla-loaders-hd__/graphics/icons/loader-icon-base.png",
            icon_size = 64,
            icon_mipmaps = 4,
            scale = 0.5,
            tint = base_tint,
        },
        {
            icon = "__vanilla-loaders-hd__/graphics/icons/loader-icon-mask.png",
            icon_size = 64,
            icon_mipmaps = 4,
            scale = 0.5,
            tint = mask_tint,
        },
    }

    return icon_data
end

---Creates an explosion with attendant particles for the given `loader_name` with the given tints.
---@param loader_name string The name of the loader, will be used to create an explosion with a name in the following format: "vanilla-loaders-{loader_name}-explosion", and particles: "vanilla-loaders-{loader_name}-{particle}"
---@param mask_tint? data.Color The color of the loader's directional arrows.
---@param base_tint? data.Color The color of the loader's metal frame and housing.
---@return string -- The name of the new explosion.
local function create_explosion_prototype_with_particles(loader_name, mask_tint, base_tint)
    -- The loader explosion, with particles, based on the splitter explosion prototype.
    ---@type data.ExplosionPrototype
    local explosion = util.copy(data.raw.explosion["splitter-explosion"])
    explosion.name = "vanilla-loaders-" .. loader_name .. "-explosion"
    explosion.icons = get_loader_icons_data(mask_tint, base_tint)

    -- A map of particle materials to its index in the default splitter particle prototypes.
    local particle_mapping = {
        ["metal-particle-medium"] = 1,
        ["metal-particle-big"] = 4,
    }

    for particle_name, index in pairs(particle_mapping) do
        ---@type data.ParticlePrototype
        local particle = util.copy(data.raw["optimized-particle"]["splitter-" .. particle_name])
        particle.name = "vanilla-loaders-" .. loader_name .. "-" .. particle_name
        particle.pictures.sheet.tint = mask_tint

        data:extend({ particle })

        explosion["created_effect"]["action_delivery"]["target_effects"][index].particle_name =
            particle.name
    end

    data:extend({ explosion })

    return explosion.name
end

---Creates a remnant for the given `loader_name` with the given tints.
---@param loader_name string The name of the loader; will create a new corpse with the name "vanilla-loaders-`loader_name`-remnants"
---@param mask_tint? data.Color The color of the loader's directional arrows.
---@param base_tint? data.Color The color of the loader's metal frame and housing.
---@return string The name of the remnant.
local function create_loader_remnants(loader_name, mask_tint, base_tint)
    -- Make the remnant, building off the standard underground belt.

    ---@type data.CorpsePrototype
    local remnants = util.copy(data.raw.corpse["underground-belt-remnants"])
    remnants.name = "vanilla-loaders-" .. loader_name .. "-remnants"
    remnants.icons = get_loader_icons_data(mask_tint, base_tint)
    remnants.selection_box = { { -0.5, -1 }, { 0.5, 1 } }
    remnants.tile_width = 1
    remnants.tile_height = 2

    remnants.animation = {
        layers = {
            -- Base.
            {
                filename = "__vanilla-loaders-hd__/graphics/entity/loader/remnants/loader-remnants-base.png",
                    width = 212,
                    height = 192,
                    direction_count = 8,
                    scale = 0.5,
            },
            -- Mask.
            {
                filename = "__vanilla-loaders-hd__/graphics/entity/loader/remnants/loader-remnants-base.png",
                    width = 212,
                    height = 192,
                    direction_count = 8,
                    scale = 0.5,
            },
        },
    }

    data:extend({ remnants })

    return remnants.name
end

---Reskins the given `loader_item` prototype with the Vanilla Loader icon in the given `color`,
---and adjusts the sort order in the crafting grid to match that of the given `transport_belt`.
---@param loader_item data.ItemPrototype # The item prototype definition to be reskinned.
---@param belt_item data.ItemPrototype # The transport belt prototype (or its name) used to determine loader order in the crafting grid.
---@param mask_tint data.Color # The color of the loader's directional arrows.
---@param base_tint? data.Color # The color of the loader's metal frame and housing.
local function set_item_icon_and_order(loader_item, belt_item, mask_tint, base_tint)
    loader_item.icons = get_loader_icons_data(mask_tint, base_tint)
    loader_item.flags = nil

    api.set_loader_item_order_from_belt(loader_item, belt_item)
end

---Gets the tinted loader structure for the given `mask_tint`. Optionally, colors the loader
---housing with the given `base_tint`.
---@param mask_tint data.Color # The color of the loader's directional arrows.
---@param base_tint? data.Color # The color of the loader's metal frame and housing.
---@return data.LoaderStructure # The tinted loader structure.
local function get_loader_structure(mask_tint, base_tint)
    ---@type data.LoaderStructure
    local structure = {
        back_patch = {
            sheet = {
                filename = "__vanilla-loaders-hd__/graphics/entity/loader/loader-structure-back-patch.png",
                    priority = "extra-high",
                    width = 212,
                    height = 192,
                    tint = base_tint,
                    scale = 0.5,
            },
        },
        direction_in = {
            sheets = {
                -- Base
                {
                    filename = "__vanilla-loaders-hd__/graphics/entity/loader/loader-structure-base.png",
                        priority = "extra-high",
                        width = 212,
                        height = 192,
                        tint = base_tint,
                        scale = 0.5,
                },
                -- Mask
                {
                    filename = "__vanilla-loaders-hd__/graphics/entity/loader/loader-structure-mask.png",
                        priority = "extra-high",
                        width = 212,
                        height = 192,
                        tint = mask_tint,
                        scale = 0.5,
                },
                -- Shadow
                {
                    filename = "__vanilla-loaders-hd__/graphics/entity/loader/loader-structure-shadow.png",
                        priority = "extra-high",
                        width = 212,
                        height = 192,
                        draw_as_shadow = true,
                        scale = 0.5,
                },
            },
        },
        direction_out = {
            sheets = {
                -- Base
                {
                    filename = "__vanilla-loaders-hd__/graphics/entity/loader/loader-structure-base.png",
                        priority = "extra-high",
                        width = 212,
                        height = 192,
                        y = 192,
                        tint = base_tint,
                        scale = 0.5,
                },
                -- Mask
                {
                    filename = "__vanilla-loaders-hd__/graphics/entity/loader/loader-structure-mask.png",
                        priority = "extra-high",
                        width = 212,
                        height = 192,
                        y = 192,
                        tint = mask_tint,
                        scale = 0.5,
                },
                -- Shadow
                {
                    filename = "__vanilla-loaders-hd__/graphics/entity/loader/loader-structure-shadow.png",
                        priority = "extra-high",
                        width = 212,
                        height = 192,
                        y = 192,
                        draw_as_shadow = true,
                        scale = 0.5,
                },
            },
        },
        front_patch = {
            sheet = {
                filename = "__vanilla-loaders-hd__/graphics/entity/loader/loader-structure-front-patch.png",
                    priority = "extra-high",
                    width = 212,
                    height = 192,
                    tint = base_tint,
                    scale = 0.5,
            },
        },
    }

    return structure
end

---Reskins the given `loader_entity` prototype with the Vanilla Loader sprites and particle
---effects in the given `color`, and sets the loader properties to conform to the given
---`transport_belt` prototype.
---@param loader data.Loader1x2Prototype The loader prototype definition to be reskinned.
---@param transport_belt data.TransportBeltPrototype The transport belt providing the animation set and speed.
---@param mask_tint data.Color The color of the loader's directional arrows.
---@param base_tint? data.Color The color of the loader's metal frame and housing.
local function set_entity_sprites_and_properties(loader, transport_belt, mask_tint, base_tint)
    loader.icons = get_loader_icons_data(mask_tint, base_tint)

    -- loader_entity.corpse = create_loader_remnants(entity.name)
    loader.dying_explosion = create_explosion_prototype_with_particles(loader.name, mask_tint)
    loader.structure_render_layer = "object"
    loader.belt_animation_set = transport_belt.belt_animation_set
    loader.speed = transport_belt.speed

    loader.structure = get_loader_structure(mask_tint, base_tint)
end

---Sets the sort order in the crafting grid of the given `loader` item to inherit that of the given
---`transport_belt`, assuming that the transport belt order property follows standard form.
---@param loader string|data.ItemPrototype # Either the name of a loader item, or a loader item prototype.
---@param transport_belt string|data.ItemPrototype # Either the name of a transport belt item, or a transport belt item prototype.
function api.set_loader_item_order_from_belt(loader, transport_belt)
    local sort_prefix = "d"

    --- Get the loader item.
    local loader_item = loader
    if type(loader) == "string" then
        loader_item = data.raw.item[loader]
        if not loader_item then
            debug_error("(set_loader_item_order_from_belt) the loader item with the name " .. loader .. " does not exist.")
        end
    end

    --- Get the transport belt item.
    local transport_belt_item = transport_belt
    if type(transport_belt) == "string" then
        transport_belt_item = data.raw.item[transport_belt]
        if not transport_belt_item then
            debug_error("(set_loader_item_order_from_belt) the transport belt item with the name " .. transport_belt .. " does not exist.")
        end
    end

    loader_item.subgroup = transport_belt_item.subgroup
    loader_item.order = string.gsub(string.gsub(transport_belt_item.order, "^[a-z]", sort_prefix), "transport%-belt", "loader")
end

---@class LoaderCreationParameters
---@field mask_tint data.Color The color of the loader arrows and explosion particles. An alpha value of 0.82 is suggested for optimal results.
---@field base_tint? data.Color The color of the metal housing of the loader icon and entity sprites.
---@field ingredients? data.FluidIngredientPrototype[]|data.ItemIngredientPrototype[] A custom loader recipe. If omitted, the default recipe will be used.
---@field previous_tier? string The name of the previous tier of loader. Sets the `next_tier` property on the given loader, and to provide an additional ingredient to the default recipe.
---@field next_tier? string The name of the loader that this loader will be upgraded to when used with the Upgrade Planner.
---@field technology? string The name of the technology that unlocks the loader.

---Creates, or if a loader already exists, reskins, the loader with the given `loader` name and
---associates it with the transport belt prototype with the given `transport_belt` name, for the
---given `parameters`.
---@param name string The name of the loader to be created.
---@param belt_name string The name of the transport belt to be associated with the loader.
---@param parameters LoaderCreationParameters Setup parameters governing the creation of the loader.
function api.create_loader(name, belt_name, parameters)
    if not name then debug_error("(create_loader) loader_name is nil.") end
    if not belt_name then debug_error("(create_loader) transport_belt_name is nil.") end
    if not parameters then debug_error("(create_loader) parameters is nil.") end

    if not parameters.mask_tint then
        debug_error("(create_loader) parameters.mask_tint is nil for loader '" .. name .. "'.")
    end

    if not parameters.base_tint then
        debug_log("(create_loader) parameters.base_tint is nil for loader '" ..
            name .. "', using default (black).")
    end

    if not parameters.ingredients then
        debug_log("(create_loader) parameters.ingredients is nil for loader '" ..
            name .. "', using default recipe.")
    end

    if not parameters.previous_tier then
        debug_log("(create_loader) parameters.previous_tier is nil for loader '" .. name .. "'.")
    end

    if not parameters.next_tier then
        debug_log("(create_loader) parameters.next_tier is nil for loader '" .. name .. "'.")
    end

    if not parameters.technology then
        debug_log("(create_loader) parameters.technology is nil for loader '" .. name .. "'.")
    end

    local belt_item = data.raw.item[belt_name]
    local belt_entity = data.raw["transport-belt"][belt_name]

    if not belt_item or not belt_entity then
        debug_error("(create_loader) the belt '" .. belt_name ..
            "' does not exist, loader '" .. name .. "' cannot be created.")
        return
    end

    local loader_item = data.raw.item[name]
    if loader_item then
        set_item_icon_and_order(loader_item, belt_item, parameters.mask_tint, parameters.base_tint)
    else
        loader_item = util.copy(data.raw.item.loader)
        loader_item.name = name
        loader_item.place_result = name

        set_item_icon_and_order(loader_item, belt_item, parameters.mask_tint, parameters.base_tint)
        data:extend({ loader_item })
    end

    local loader_recipe = data.raw.recipe[name]
    if loader_recipe then
        loader_recipe.energy_required = 5
        loader_recipe.hidden = nil
    else
        ---@type data.RecipePrototype
        local recipe = {
            type = "recipe",
            name = name,
            enabled = false,
            energy_required = 5,
            ingredients = parameters.ingredients or
                parameters.previous_tier and ({
                    { parameters.previous_tier, 1 },
                    { belt_name,                5 },
                }) or ({
                    { belt_name, 5 },
                }),
            result = name,
        }

        data:extend({ recipe })
    end

    local loader_entity = data.raw.loader[name]
    if loader_entity then
        set_entity_sprites_and_properties(loader_entity, belt_entity, parameters.mask_tint, parameters.base_tint)
    else
        loader_entity = util.copy(data.raw.loader["loader"])
        loader_entity.name = name
        loader_entity.minable.result = name

        set_entity_sprites_and_properties(loader_entity, belt_entity, parameters.mask_tint, parameters.base_tint)
        data:extend({ loader_entity })
    end

    if parameters.previous_tier then data.raw.loader[parameters.previous_tier].next_upgrade = name end
    if parameters.next_tier then loader_entity.next_upgrade = parameters.next_tier end

    local loader_technology = data.raw.technology[parameters.technology]
    if loader_technology then
        table.insert(loader_technology.effects, {
            type = "unlock-recipe",
            recipe = name,
        })
    end
end

return api
