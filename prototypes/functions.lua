-- Copyright (c) 2017 Thaui
-- Copyright (c) 2018 Kirazy
-- Part of Vanilla Loaders HD
--     
-- See LICENSE.md in the project directory for license information.

-- Initialize function storage.
if not vanillaHD then vanillaHD = {} end
local modDir = "__vanilla-loaders-hd__"

-- ##################################################################################
-- This function is designed to be used by other mods to create vanilla-esque loaders
-- 
-- Parameters:
-- name			 - string; the name of your loader 
--				   (e.g. name = "basic-loader")
-- color		 - table;  table of rgb values, determines your loader's color 
--				   (e.g. color = {r = 255, g = 255, b = 255} for white)
-- belt_name	 - string; the belt tier your loader connects to 
-- 				   (e.g. belt_name = "transport-belt" for yellow belts)
-- technology	 - string; the name of the technology that unlocks your loader 
-- 				   (e.g. technology = "logistics" for yellow belt tier)
-- previous_tier - string; the name of the loader that will upgrade into your loader;
--				   also the loader that will be an ingredient in the base recipe.
--				   (e.g. previous_tier = "express-loader" to build from blue loaders)
-- next_tier     - string; the name of the loader that your loader will upgrade into
-- 
-- This will create item, entity, recipe entries which you can edit further. 
-- It will also create particles, explosions, and remnants.
-- 
-- The initial recipe for a loader added using this function are 5x the belt you
-- specified, and 1x the previous_tier loader you specified.
--
-- To support snapping behavior if this mod is installed side-by-side with Loader
-- Redux, you will need to call Loader Redux's remote interface. See control.lua for
-- an example.

function vanillaHD.addLoader(name, color, belt_name, technology, previous_tier, next_tier)
	-- Specify loader color
	vanillaHD.tint_mask[name] = color

	-- Create the loader
	vanillaHD.createLoaderItem(name, belt_name)
	vanillaHD.createLoaderRecipe(name, belt_name, previous_tier)
	vanillaHD.createParticles(name)
	vanillaHD.createExplosions(name)
	-- vanillaHD.createRemnants(name)
	vanillaHD.createLoaderEntity(name, belt_name, true)	
	vanillaHD.patchLoaderTechnology(technology, name)

	-- Handle upgrade paths
	data.raw["loader"][previous_tier].next_upgrade = name
	if next_tier then
		data.raw["loader"][name].next_upgrade = next_tier
	else
		data.raw["loader"][name].next_upgrade = nil
	end

end
-- ##################################################################################

-- Create color masks.
vanillaHD.tint_mask = {
	["basic-loader"]   = {r = 125, g = 125, b = 125, a = 0.82*255}, -- Corrected 2020-02-21
	["loader"] 		   = {r = 255, g = 195, b =  64, a = 0.82*255}, -- Corrected 2020-02-21
	["fast-loader"]    = {r = 227, g =  23, b =  23, a = 0.82*255}, -- Corrected 2020-02-21
	["express-loader"] = {r =  67, g = 192, b = 250, a = 0.82*255}, -- Corrected 2020-02-21
	["purple-loader"]  = {r = 165, g =  16, b = 229, a = 0.82*255}, -- Corrected 2020-02-21
	["green-loader"]   = {r =  22, g = 242, b =  99, a = 0.82*255}, -- Corrected 2020-02-21
}

-- Match the tint used in Bob's Logistics Belt Reskin / Bob's Logistics Basic Belt Reskin.
if mods["boblogistics-belt-reskin"] or mods["bob-basic-belt-reskin"] then
	vanillaHD.tint_mask["basic-loader"] = {r = 0, g = 0, b = 0, a = 0} -- Corrected 2020-02-21
end

-- Match the tint used in Bob's Logistics Belt Reskin
if mods["boblogistics-belt-reskin"] then
	vanillaHD.tint_mask["purple-loader"] = {r = 223, g =  30, b = 229, a = 0.82*255} -- Corrected 2020-02-21
end

-- Used to patch loader entities, or create new ones, with vanilla-style graphics.
-- Called by createLoaderEntity
function vanillaHD.patchLoaderEntity(name, belt_name, is_external)
	local loader = data.raw["loader"][name]
	local base_belt = data.raw["transport-belt"][belt_name]

	-- Allow loaders to render at the same level as splitters, underground belts. And now chests in 0.18...
	loader.structure_render_layer = "object"

	-- Inherit graphics from tier-appropriate belts
	loader.belt_animation_set = base_belt.belt_animation_set

	-- Inherit speed from tier-appropriate belts
	loader.speed = base_belt.speed

	-- Set flags
	loader.flags = {"placeable-neutral", "placeable-player", "player-creation", "fast-replaceable-no-build-while-moving"}

	-- Set remnant and explosions
	-- loader.corpse = name.."-remnants"
	loader.dying_explosion = name.."-explosion"
	
	-- Specifies the entity icons used by the game to generate alert messages
	loader.icon_size = 64
	loader.icons  = 
	{
		{
			icon = modDir.."/graphics/icons/loader-icon-base.png"
		},
		{
			icon = modDir.."/graphics/icons/loader-icon-mask.png",
			tint = vanillaHD.tint_mask[name]
		}
	}
	
	-- Clear existing sheet
	loader.structure.direction_in.sheet = nil
	loader.structure.direction_out.sheet = nil

	-- Reskin loader
	loader.structure.direction_in.sheets = 
	{
		-- Base
		{
			filename = modDir.."/graphics/entity/loader/loader-structure-base.png",				
			width    = 106,
			height   = 96,
			y        = 0,
			hr_version = 
			{
				filename = modDir.."/graphics/entity/loader/hr-loader-structure-base.png",
				height   = 192,
				priority = "extra-high",
				scale    = 0.5,
				width    = 212,
				y        = 0
			}
		},
		-- Mask
		{
			filename = modDir.."/graphics/entity/loader/loader-structure-mask.png",			
			width    = 106,
			height   = 96,
			y        = 0,
			tint	 = vanillaHD.tint_mask[name],
			hr_version = 
			{
				filename = modDir.."/graphics/entity/loader/hr-loader-structure-mask.png",
				height   = 192,
				priority = "extra-high",
				scale    = 0.5,
				width    = 212,
				y        = 0,
				tint     = vanillaHD.tint_mask[name],
			}
		},
		-- Shadow
		{
			filename = modDir.."/graphics/entity/loader/loader-structure-shadow.png",			
			draw_as_shadow = true,
			width    = 106,
			height   = 96,
			y        = 0,
			hr_version = 
			{
				filename = modDir.."/graphics/entity/loader/hr-loader-structure-shadow.png",
				draw_as_shadow = true,
				height   = 192,
				priority = "extra-high",
				scale    = 0.5,
				width    = 212,
				y        = 0,
			}
		}
	}

	loader.structure.direction_out.sheets = 
	{
		-- Base
		{
			filename = modDir.."/graphics/entity/loader/loader-structure-base.png",			
			width    = 106,
			height   = 96,
			y        = 96,
			hr_version = 
			{
				filename = modDir.."/graphics/entity/loader/hr-loader-structure-base.png",
				height   = 192,
				priority = "extra-high",
				scale    = 0.5,
				width    = 212,
				y        = 192
			}
		},
		-- Mask
		{
			filename = modDir.."/graphics/entity/loader/loader-structure-mask.png",			
			width    = 106,
			height   = 96,
			y        = 96,
			tint	 = vanillaHD.tint_mask[name],
			hr_version = 
			{
				filename = modDir.."/graphics/entity/loader/hr-loader-structure-mask.png",
				height   = 192,
				priority = "extra-high",
				scale    = 0.5,
				width    = 212,
				y        = 192,
				tint     = vanillaHD.tint_mask[name]
			}
		},
		-- Shadow
		{
			filename = modDir.."/graphics/entity/loader/loader-structure-shadow.png",			
			width    = 106,
			height   = 96,
			y        = 96,
			draw_as_shadow = true,
			hr_version = 
			{
				filename = modDir.."/graphics/entity/loader/hr-loader-structure-shadow.png",
				height   = 192,
				priority = "extra-high",
				scale    = 0.5,
				width    = 212,
				y        = 192,
				draw_as_shadow = true,
			}
		}
	}

	-- Add back flange beneath items on the belt
	loader.structure.back_patch =
	{
		sheet =
		{
		filename = modDir.."/graphics/entity/loader/loader-structure-back-patch.png",
		priority = "extra-high",
		width = 106,
		height = 96,
		hr_version =
		{
			filename = modDir.."/graphics/entity/loader/hr-loader-structure-back-patch.png",
			priority = "extra-high",
			width = 212,
			height = 192,
			scale = 0.5
		}
		}
	}

	-- Little piece of texture that extends into territory occupied by items while on belt, but rendered beneath them.
	loader.structure.front_patch =
	{
		sheet =
		{
		filename = modDir.."/graphics/entity/loader/loader-structure-front-patch.png",
		priority = "extra-high",
		width = 106,
		height = 96,
		hr_version =
		{
			filename = modDir.."/graphics/entity/loader/hr-loader-structure-front-patch.png",
			priority = "extra-high",
			width = 212,
			height = 192,
			scale = 0.5
		}
		}
	}
end

-- Used to create new loader entities
function vanillaHD.createLoaderEntity(name, belt_name, is_external)
	if data.raw["transport-belt"][belt_name] then
		local loader = table.deepcopy(data.raw["loader"]["loader"])

		loader.name = name
		loader.minable.result = name
		
		-- Add loader entity to main data table
		data:extend({loader})

		-- Generate entity graphics
		vanillaHD.patchLoaderEntity(name, belt_name, is_external)
	end
end

-- Patch existing loader items, or create new ones, with vanilla-style graphics
-- Called by createLoaderItem
function vanillaHD.patchLoaderItem(name, belt_name)
	local item = data.raw["item"][name]
	local base_belt = data.raw["item"][belt_name]

	-- Clear existing presets
	item.flags = nil
	item.icon = nil

	-- Main function
	item.icon_size = 64
	item.icons  = 
	{
		{
			icon = modDir.."/graphics/icons/loader-icon-base.png"
		},
		{
			icon = modDir.."/graphics/icons/loader-icon-mask.png",
			tint = vanillaHD.tint_mask[name]
		}
	}

	-- Inherit UI grouping and sorting from base_belt item
	item.subgroup = base_belt.subgroup
	item.order = string.gsub(string.gsub(item.order,"^[a-z]","d"),"transport%-belt","loader")
end

-- Used to create new loader items
function vanillaHD.createLoaderItem(name, belt_name)
	if data.raw["item"][belt_name] then
		local item = table.deepcopy(data.raw["item"]["loader"])
		
		item.name = name
		item.place_result = name
		
		-- Add loader item to main data table
		data:extend({item})
		
		-- Generate item graphics
		vanillaHD.patchLoaderItem(name, belt_name)
	end
end

-- Function to create the default recipes for each of the loaders.
function vanillaHD.createLoaderRecipe(name, belt_name, previous_tier)
	if data.raw["item"][belt_name] then
		local recipe = table.deepcopy(data.raw["recipe"]["express-loader"])
		recipe.name = name
		recipe.ingredients = 
		{
			{belt_name, 5},
			{previous_tier, 1}
		}
		recipe.result = name
		data:extend({recipe})
	end
end

-- Function to add the loaders to the technology tree.
function vanillaHD.patchLoaderTechnology(technology, recipe)
	if data.raw["technology"][technology] then
		table.insert(data.raw["technology"][technology].effects, 
		{
			type = "unlock-recipe",
			recipe = recipe
		})
	end
end

-- This function creates particle entities.
function vanillaHD.createParticles(name)
	    -- loader-metal-particle-medium
		local mediumLoaderParticle = table.deepcopy(data.raw["optimized-particle"]["splitter-metal-particle-medium"])
		mediumLoaderParticle.name = name.."-metal-particle-medium"
		mediumLoaderParticle.pictures.sheet.tint = vanillaHD.tint_mask[name]
		mediumLoaderParticle.pictures.sheet.hr_version.tint = vanillaHD.tint_mask[name]
		data:extend({mediumLoaderParticle})
	
		-- loader-metal-particle-big
		local bigLoaderParticle = table.deepcopy(data.raw["optimized-particle"]["splitter-metal-particle-big"])
		bigLoaderParticle.name = name.."-metal-particle-big"
		bigLoaderParticle.pictures.sheet.tint = vanillaHD.tint_mask[name]
		bigLoaderParticle.pictures.sheet.hr_version.tint = vanillaHD.tint_mask[name]
		data:extend({bigLoaderParticle})
end

-- This function creates explosion entities.
function vanillaHD.createExplosions(name, prefix)
	local explosion = table.deepcopy(data.raw["explosion"]["splitter-explosion"])
	explosion.name = name.."-explosion"
	explosion.icon_size = 64
	explosion.icons  = 
	{
		{
			icon = modDir.."/graphics/icons/loader-icon-base.png"
		},
		{
			icon = modDir.."/graphics/icons/loader-icon-mask.png",
			tint = vanillaHD.tint_mask[name]
		}
	}

	-- Prefix is an optional parameter
	prefix = prefix or false

	if prefix then
		-- We want to reuse particles created elsewhere.
		explosion.created_effect.action_delivery.target_effects[1].particle_name = prefix.."-metal-particle-medium"
		explosion.created_effect.action_delivery.target_effects[4].particle_name = prefix.."-metal-particle-big"
	else
		-- We made our own, use those.
		explosion.created_effect.action_delivery.target_effects[1].particle_name = name.."-metal-particle-medium"
		explosion.created_effect.action_delivery.target_effects[4].particle_name = name.."-metal-particle-big"
	end
	
	data:extend({explosion})
end