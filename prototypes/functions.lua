-- Copyright (c) 2017 Thaui
-- Copyright (c) 2018 Kirazy
-- Part of Vanilla Loaders HD
--
-- See LICENSE.md in the project directory for license information.

-- Initialize function storage.
if not vanillaHD then vanillaHD = {} end

-- Loader tints
vanillaHD.tint_mask = {
	-- Bob's Logistics
	["basic-loader"] = util.color("7d7d7dd1"),
	["loader"] = util.color("ffc340d1"),
	["fast-loader"] = util.color("e31717d1"),
	["express-loader"] = util.color("43c0fad1"),
	["purple-loader"] = util.color("a510e5d1"),
	["green-loader"] = util.color("16f263d1"),
}

if mods["UltimateBelts_Owoshima_And_Pankeko-Mod"] then
	-- Pankeko Ultimate Belts
	vanillaHD.tint_mask["ub-ultra-fast-loader"] = util.color("2bc24bDB")
	vanillaHD.tint_mask["ub-extreme-fast-loader"] = util.color("c4632fDB")
	vanillaHD.tint_mask["ub-ultra-express-loader"] = util.color("6f2de0D1")
	vanillaHD.tint_mask["ub-extreme-express-loader"] = util.color("3d3af0DB")
	vanillaHD.tint_mask["ub-ultimate-loader"] = util.color("999999D1")
else
	-- Ultimate Belts
	vanillaHD.tint_mask["ub-ultra-fast-loader"] = util.color("00b30cFF")
	vanillaHD.tint_mask["ub-extreme-fast-loader"] = util.color("e00000FF")
	vanillaHD.tint_mask["ub-ultra-express-loader"] = util.color("3604b5E8")
	vanillaHD.tint_mask["ub-extreme-express-loader"] = util.color("002bffFF")
	vanillaHD.tint_mask["ub-ultimate-loader"] = util.color("00ffddD1")
end

-- Match the tint used in Bob's Logistics Belt Reskin / Bob's Logistics Basic Belt Reskin.
if mods["boblogistics-belt-reskin"] or mods["bob-basic-belt-reskin"] then
	vanillaHD.tint_mask["basic-loader"] = util.color("00000000")
end

-- Match the tint used in Bob's Logistics Belt Reskin
if mods["boblogistics-belt-reskin"] then
	vanillaHD.tint_mask["purple-loader"] = util.color("df1ee5d1")
end

-- Debug functions
local debug = false
function vanillaHD.debug_error(string)
	if not debug then return end
	error("Vanilla Loaders HD: "..string)
end

function vanillaHD.debug_log(string)
	if not debug then return end
	log("Vanilla Loaders HD: "..string)
end

-- List of particles to copy and edit from standard splitter
local particle_list = {
    ["metal-particle-medium"] = 1,
    ["metal-particle-big"] = 4,
}

-- Returns `icons` table when called
local function loader_icons(name, base_tint)
    return
    {
        { icon = "__vanilla-loaders-hd__/graphics/icons/loader-icon-base.png", icon_size = 64, icon_mipmaps = 4, tint = base_tint},
        { icon = "__vanilla-loaders-hd__/graphics/icons/loader-icon-mask.png", icon_size = 64, icon_mipmaps = 4, tint = vanillaHD.tint_mask[name] }
    }
end

-- Creates explosions and particles, returns the prototype name of the explosion
local function create_loader_explosions_and_particles(name, base_tint)
    -- Make the explosion, building off of the standard splitter
    local working_explosion = util.copy(data.raw.explosion["splitter-explosion"])
    working_explosion.name = "vanillaHD-"..name.."-explosion"
    working_explosion.icons = loader_icons(name, base_tint)

    -- Make the particles
    for particle, key in pairs(particle_list) do
        -- Build off of the standard splitter
        local working_particle = util.copy(data.raw["optimized-particle"]["splitter-"..particle])

        -- Customize the colors
        working_particle.name = "vanillaHD-"..name.."-"..particle
        working_particle.pictures.sheet.tint = vanillaHD.tint_mask[name]
        working_particle.pictures.sheet.hr_version.tint = vanillaHD.tint_mask[name]

        -- Extend the particle
        data:extend({working_particle})

        -- Assign to the explosion
        working_explosion["created_effect"]["action_delivery"]["target_effects"][key].particle_name = working_particle.name
    end

    -- Extend the explosion
    data:extend({working_explosion})

    return working_explosion.name
end

-- Create remnants, returns the prototype name of the remnant
local function create_loader_remnants(name, base_tint)
    -- Make the remnant, building off the standard underground belt
    local working_remnant = util.copy(data.raw.corpse["underground-belt-remnants"])
    working_remnant.name = "vanillaHD-"..name.."-remnants"
    working_remnant.icons = loader_icons(name, base_tint)
    working_remnant.selection_box = {{-0.5, -1}, {0.5, 1}}
    working_remnant.tile_width = 1
    working_remnant.tile_height = 2

    -- Setup the sprite sheet
    working_remnant.animation = {
        layers = {
            -- Base
            {
                filename = "__vanilla-loaders-hd__/graphics/entity/loader/remnants/loader-remnants-base.png",
                width = 106,
                height = 96,
                direction_count = 8,
                hr_version = {
                    filename = "__vanilla-loaders-hd__/graphics/entity/loader/remnants/hr-loader-remnants-base.png",
                    width = 212,
                    height = 192,
                    direction_count = 8,
                    scale = 0.5,
                },
            },
            -- Mask
            {
                filename = "__vanilla-loaders-hd__/graphics/entity/loader/remnants/loader-remnants-base.png",
                width = 106,
                height = 96,
                direction_count = 8,
                hr_version = {
                    filename = "__vanilla-loaders-hd__/graphics/entity/loader/remnants/hr-loader-remnants-base.png",
                    width = 212,
                    height = 192,
                    direction_count = 8,
                    scale = 0.5,
                },
            },
        }
    }

    -- Extend the remnant
    data:extend({working_remnant})

    return working_remnant.name
end

-- Loader setup helper functions
function vanillaHD.set_item_order(item, belt)
	if type(item) == "string" then
		item = data.raw.item[item]
	end

	if type(belt) == "string" then
		belt = data.raw.item[belt]
	end

	item.subgroup = belt.subgroup
	item.order = string.gsub(string.gsub(belt.order, "^[a-z]", "d"), "transport%-belt", "loader")
end

local function adjust_item_properties(item, belt, base_tint)
	item.icons = loader_icons(item.name, base_tint)

	if mods["LoaderRedux"] and settings.startup["vanillaLoaders-reskinLoaderReduxOnly"].value == true then
		-- Do nothing
	else
		item.flags = nil
		vanillaHD.set_item_order(item, belt)
	end
end

local function adjust_entity_properties(entity, belt, base_tint)
    entity.icons = loader_icons(entity.name, base_tint)
    -- entity.corpse = create_loader_remnants(entity.name)
	entity.dying_explosion = create_loader_explosions_and_particles(entity.name)

	if mods["LoaderRedux"] and settings.startup["vanillaLoaders-reskinLoaderReduxOnly"].value == true then
		-- Do nothing
    else
        entity.structure_render_layer = "object"
		entity.belt_animation_set = belt.belt_animation_set
		entity.speed = belt.speed
	end

    entity.structure = {
        back_patch = {
            sheet = {
                filename = "__vanilla-loaders-hd__/graphics/entity/loader/loader-structure-back-patch.png",
                priority = "extra-high",
                width = 106,
                height = 96,
                tint = base_tint,
                hr_version = {
                    filename = "__vanilla-loaders-hd__/graphics/entity/loader/hr-loader-structure-back-patch.png",
                    priority = "extra-high",
                    width = 212,
                    height = 192,
                    tint = base_tint,
                    scale = 0.5
                }
            }
        },
        direction_in = {
            sheets = {
                -- Base
                {
                    filename = "__vanilla-loaders-hd__/graphics/entity/loader/loader-structure-base.png",
                    priority = "extra-high",
                    width = 106,
                    height = 96,
                    tint = base_tint,
                    hr_version = {
                        filename = "__vanilla-loaders-hd__/graphics/entity/loader/hr-loader-structure-base.png",
                        priority = "extra-high",
                        width = 212,
                        height = 192,
                        tint = base_tint,
                        scale = 0.5,
                    }
                },
                -- Mask
                {
                    filename = "__vanilla-loaders-hd__/graphics/entity/loader/loader-structure-mask.png",
                    priority = "extra-high",
                    width = 106,
                    height = 96,
                    tint = vanillaHD.tint_mask[entity.name],
                    hr_version = {
                        filename = "__vanilla-loaders-hd__/graphics/entity/loader/hr-loader-structure-mask.png",
                        priority = "extra-high",
                        width = 212,
                        height = 192,
                        tint = vanillaHD.tint_mask[entity.name],
                        scale = 0.5,
                    }
                },
                -- Shadow
                {
                    filename = "__vanilla-loaders-hd__/graphics/entity/loader/loader-structure-shadow.png",
                    priority = "extra-high",
                    width = 106,
                    height = 96,
                    draw_as_shadow = true,
                    hr_version = {
                        filename = "__vanilla-loaders-hd__/graphics/entity/loader/hr-loader-structure-shadow.png",
                        priority = "extra-high",
                        width = 212,
                        height = 192,
                        draw_as_shadow = true,
                        scale = 0.5,
                    }
                }
            }
        },
        direction_out = {
            sheets = {
                -- Base
                {
                    filename = "__vanilla-loaders-hd__/graphics/entity/loader/loader-structure-base.png",
                    priority = "extra-high",
                    width = 106,
                    height = 96,
                    y = 96,
                    tint = base_tint,
                    hr_version = {
                        filename = "__vanilla-loaders-hd__/graphics/entity/loader/hr-loader-structure-base.png",
                        priority = "extra-high",
                        width = 212,
                        height = 192,
                        y = 192,
                        tint = base_tint,
                        scale = 0.5,
                    }
                },
                -- Mask
                {
                    filename = "__vanilla-loaders-hd__/graphics/entity/loader/loader-structure-mask.png",
                    priority = "extra-high",
                    width = 106,
                    height = 96,
                    y = 96,
                    tint = vanillaHD.tint_mask[entity.name],
                    hr_version = {
                        filename = "__vanilla-loaders-hd__/graphics/entity/loader/hr-loader-structure-mask.png",
                        priority = "extra-high",
                        width = 212,
                        height = 192,
                        y = 192,
                        tint = vanillaHD.tint_mask[entity.name],
                        scale = 0.5,
                    }
                },
                -- Shadow
                {
                    filename = "__vanilla-loaders-hd__/graphics/entity/loader/loader-structure-shadow.png",
                    priority = "extra-high",
                    width = 106,
                    height = 96,
                    y = 96,
                    draw_as_shadow = true,
                    hr_version = {
                        filename = "__vanilla-loaders-hd__/graphics/entity/loader/hr-loader-structure-shadow.png",
                        priority = "extra-high",
                        width = 212,
                        height = 192,
                        y = 192,
                        draw_as_shadow = true,
                        scale = 0.5,
                    }
                }
            }
        },
        front_patch = {
            sheet = {
                filename = "__vanilla-loaders-hd__/graphics/entity/loader/loader-structure-front-patch.png",
                priority = "extra-high",
                width = 106,
                height = 96,
                tint = base_tint,
                hr_version = {
                    filename = "__vanilla-loaders-hd__/graphics/entity/loader/hr-loader-structure-front-patch.png",
                    priority = "extra-high",
                    width = 212,
                    height = 192,
                    tint = base_tint,
                    scale = 0.5
                }
            }
        }
    }
end

-- Setup the loader
-- name                 prototype name for the loader
-- source_belt_name     prototype name for the belt the loader will use
-- parameters
-- > previous_tier      string; the prototype name of the previous tier of loader, used to set upgrade path of the previous_tier and default recipe (required if no recipe already exists, optional otherwise)
-- > ingredients        table of Types/IngredientPrototype; used preferrentially in place of previous_tier in recipes (optional)
-- > technology         string; the prototype name of the technology that unlocks the loader (optional)
-- > next_tier          string; for upgrade planner, the prototype name of the next tier of loader (optional)
-- > tint               table of Types/Color; an alpha value of 0.82 is suggested for optimal results (optional)
function vanillaHD.setup_loader(name, source_belt_name, parameters)
    if not parameters then parameters = {} end

    -- Fetch the source belt
    local belt_item = data.raw.item[source_belt_name]
    local belt_entity = data.raw["transport-belt"][source_belt_name]

    -- Validate the source belt
    if not belt_item or not belt_entity then
        vanillaHD.debug_error("the belt "..source_belt_name.." does not exist, loader "..name.." was not created.")
        return
    end

    -- Check if a tint was specified, and if so, add it to the tint_mask table
    if parameters and parameters.tint then vanillaHD.tint_mask[name] = parameters.tint end
    if not vanillaHD.tint_mask[name] then
        vanillaHD.debug_log("no tint is defined for loader "..name..", the default tint (black) will be used instead.")
    end

    -- SETUP LOADER ITEM
    -- ----------------------------------------------------------------------------------------------------
    -- Check if the item exists, if so, link to it, otherwise create it
    local loader_item
    if data.raw.item[name] then
        -- Link to the item
        loader_item = data.raw.item[name]

        -- Adjust properties
        adjust_item_properties(loader_item, belt_item, parameters.base_tint)
    else
        -- Build off the standard loader item
        loader_item = util.copy(data.raw.item.loader)
        loader_item.name = name
        loader_item.place_result = name

        -- Adjust properties
        adjust_item_properties(loader_item, belt_item, parameters.base_tint)

        -- Extend the item
        data:extend({loader_item})
	end

	-- Handle Loader Redux exception
	if mods["LoaderRedux"] and settings.startup["vanillaLoaders-reskinLoaderReduxOnly"].value == true then
		-- Do nothing
	else
		-- SETUP LOADER RECIPE
		-- ----------------------------------------------------------------------------------------------------
		-- Check if the recipe exists, if so, set energy_required, otherwise create it
		local loader_recipe = data.raw.recipe[name]
		if loader_recipe and not mods["LoaderRedux"] then
            loader_recipe.energy_required = 5
            loader_recipe.hidden = nil
		else
			-- Validate parameters
			if parameters and not (parameters.ingredients or parameters.previous_tier) then
				vanillaHD.debug_error("the recipe for loader "..name.." does not exist, but no ingredient parameters were specified.")
				return
			end

			-- Create the loader recipe
			data:extend({
				{
					type = "recipe",
					name = name,
					enabled = false,
					energy_required = 5,
					ingredients = parameters.ingredients or ({{parameters.previous_tier, 1}, {source_belt_name, 5}}),
					result = name,
				}
			})
		end

		-- SETUP LOADER TECHNOLOGY UNLOCK
		-- ----------------------------------------------------------------------------------------------------
		if parameters and parameters.technology and data.raw.technology[parameters.technology] then
			table.insert(data.raw.technology[parameters.technology].effects, {
				type = "unlock-recipe",
				recipe = name,
			})
		else
			vanillaHD.debug_log("technology parameter was not specified for loader "..name..".")
		end
	end

    -- SETUP LOADER ENTITY
    -- ----------------------------------------------------------------------------------------------------
    -- Check if the entity exists, if so, link to it, otherwise create it
    local loader_entity
    if data.raw.loader[name] then
        -- Link to the entity
        loader_entity = data.raw.loader[name]

        -- Adjust properties
        adjust_entity_properties(loader_entity, belt_entity, parameters.base_tint)
    else
        -- Build off the standard loader entity
        loader_entity = util.copy(data.raw.loader.loader)
        loader_entity.name = name
        loader_entity.minable.result = name

        -- Adjust properties
        adjust_entity_properties(loader_entity, belt_entity, parameters.base_tint)

        -- Extend the entity
        data:extend({loader_entity})
	end

	if mods["LoaderRedux"] and settings.startup["vanillaLoaders-reskinLoaderReduxOnly"].value == true then
		return
	end

    -- Handle upgrade paths
    if parameters.previous_tier then
        data.raw.loader[parameters.previous_tier].next_upgrade = name
    else
        vanillaHD.debug_log("previous_tier parameter was not specified for loader "..name..".")
    end

    if parameters.next_tier then
        data.raw.loader[name].next_upgrade = parameters.next_tier
    else
        vanillaHD.debug_log("next_tier parameter was not specified for loader "..name..".")
    end

    -- SETUP LOADER TECHNOLOGIES
    -- ----------------------------------------------------------------------------------------------------
    local loader_technology = data.raw.technology["parameters.technology"]
    if loader_technology then
        table.insert(loader_technology.effects, {
            type = "unlock-recipe",
            recipe = name,
        })
    end
end

-- This function is deprecated; use vanillaHD.setup_loader instead
function vanillaHD.addLoader(name, color, belt_name, technology, previous_tier, next_tier)
	vanillaHD.setup_loader(name, belt_name, {
		previous_tier = previous_tier,
		next_tier = next_tier,
		technology = technology,
		tint = color,
	})
end