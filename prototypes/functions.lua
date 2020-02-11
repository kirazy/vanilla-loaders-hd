-- Copyright (c) 2017 Thaui
-- Copyright (c) 2018 Kirazy
-- Part of Vanilla Loaders HD
--     
-- See LICENSE.md in the project directory for license information.

-- Initialize function storage
if not vanillaHD then vanillaHD = {} end
local modDir = "__vanilla-loaders-hd__"

-- Create color masks
vanillaHD.tint_mask = {
	["basic-loader"]   = {r = 227, g = 227, b = 227}, -- Corrected 6-1-2019
	["loader"] 		   = {r = 240, g = 199, b =  86}, -- Corrected 6-1-2019
	["fast-loader"]    = {r = 227, g =  68, b =  68}, -- Corrected 6-1-2019
	["express-loader"] = {r =  92, g = 200, b = 250}, -- Corrected 6-1-2019
	["purple-loader"]  = {r = 199, g =  69, b = 255}, -- Corrected 6-1-2019
	["green-loader"]   = {r =  74, g = 255, b = 137}, -- Corrected 6-1-2019
}

-- Used to patch loader entities, or create new ones, with vanilla-style graphics.
-- Called by createLoaderEntity.
function vanillaHD.patchLoaderEntity(name, beltname)
	local loader = data.raw["loader"][name]
	local basebelt = data.raw["transport-belt"][beltname]

	-- Allow loaders to render at the same level as splitters, underground belts. And now chests in 0.18...
	loader.structure_render_layer = "object"

	-- Inherit graphics from tier-appropriate belts
	loader.belt_animation_set = basebelt.belt_animation_set

	-- Inherit speed from tier-appropriate belts
	loader.speed = basebelt.speed

	-- Set flags
	loader.flags = {"placeable-neutral", "placeable-player", "player-creation", "fast-replaceable-no-build-while-moving"}

	-- Set remnant and explosions
	loader.corpse = name.."-remnants"
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
	
	loader.structure.direction_in.sheets = 
	{
		{
			filename = modDir.."/graphics/entity/loader/loader-structure-base.png",				
			width    = 96,
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
		{
			filename = modDir.."/graphics/entity/loader/loader-structure-mask.png",			
			width    = 96,
			height   = 96,
			y        = 0,
			tint	 = vanillaHD.tint_mask[name],
			hr_version = 
			{
				filename = modDir.."/graphics/entity/loader/hr-loader-structure-mask.png",
				height   = 192,
				priority = "extra-high",
				scale    = 0.5,
				width    = 192,
				y        = 0,
				tint     = vanillaHD.tint_mask[name]
			}
		}
	}
	loader.structure.direction_out.sheets = 
	{
		{
			filename = modDir.."/graphics/entity/loader/loader-structure-base.png",			
			width    = 96,
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
		{
			filename = modDir.."/graphics/entity/loader/loader-structure-mask.png",			
			width    = 96,
			height   = 96,
			y        = 96,
			tint	 = vanillaHD.tint_mask[name],
			hr_version = 
			{
				filename = modDir.."/graphics/entity/loader/hr-loader-structure-mask.png",
				height   = 192,
				priority = "extra-high",
				scale    = 0.5,
				width    = 192,
				y        = 192,
				tint     = vanillaHD.tint_mask[name]
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
		width = 96,
		height = 96,
		hr_version =
		{
			filename = modDir.."/graphics/entity/loader/hr-loader-structure-back-patch.png",
			priority = "extra-high",
			width = 192,
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
		width = 96,
		height = 96,
		hr_version =
		{
			filename = modDir.."/graphics/entity/loader/hr-loader-structure-front-patch.png",
			priority = "extra-high",
			width = 192,
			height = 192,
			scale = 0.5
		}
		}
	}
end

-- Used to create new loader entities
function vanillaHD.createLoaderEntity(name, beltname)
	if data.raw["transport-belt"][beltname] then
		local loader = table.deepcopy(data.raw["loader"]["loader"])

		loader.name = name
		loader.minable.result = name
		
		-- Add loader entity to main data table
		data:extend({loader})

		-- Generate entity graphics
		vanillaHD.patchLoaderEntity(name, beltname)
	end
end

-- Patch existing loader items, or create new ones, with vanilla-style graphics
function vanillaHD.patchLoaderItem(name, beltname)
	local item = data.raw["item"][name]
	local basebelt = data.raw["item"][beltname]

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

	-- Configure UI grouping and sorting
	item.subgroup = basebelt.subgroup
	item.order = string.gsub(string.gsub(item.order,"^[a-z]","d"),"transport%-belt","loader")
end

-- Used to create new loader items
function vanillaHD.createLoaderItem(name, beltname)
	if data.raw["item"][beltname] then
		local item = table.deepcopy(data.raw["item"]["loader"])
		item.name = name
		item.place_result = name
		
		-- Add loader item to main data table
		data:extend({item})
		
		-- Generate item graphics
		vanillaHD.patchLoaderItem(name, beltname)
	end
end

-- Function to create the default recipes for each of the loaders.
function vanillaHD.createLoaderRecipe(name, beltname, lastloader)
	if data.raw["item"][beltname] then
		local recipe = table.deepcopy(data.raw["recipe"]["express-loader"])
		recipe.name = name
		recipe.ingredients = 
		{
			{beltname, 5},
			{lastloader, 1}
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