-- Copyright (c) 2018 Kirazy
-- Part of Vanilla Loaders HD
--     
-- See LICENSE.md in the project directory for license information.

-- Crafting Time Fix
data.raw["recipe"]["loader"].energy_required = 5
data.raw["recipe"]["fast-loader"].energy_required = 5
data.raw["recipe"]["express-loader"].energy_required = 5

-- Check for presence of LoaderRedux, and check if we are supposed to use LoaderRedux recipes. 
-- If true, stop here, and allow LoaderRedux to configure recipes and apply loader-belt-speed fixes.
if mods["LoaderRedux"] and settings.startup["vanillaLoaders-recipes-loaderReduxCompliant"].value == true then 
	
	-- Check for Bob's Logistics
	if mods["boblogistics"] then

		-- Create basic loader for LoaderRedux and modify the loader recipe to fit the pattern.
		if settings.startup["bobmods-logistics-beltoverhaul"].value == true and settings.startup["vanillaLoaders-recipes-loaderReduxBasicLoader"].value == true then
			data:extend({
				-- Basic Loader
				{
					type = "recipe",
					name = "basic-loader",
					enabled = false,
					energy_required = 5,
					ingredients = 
					{
						{"wood", 				 4},
						{"basic-transport-belt", 5},					
						{"inserter", 	 		 5},
						{"iron-plate", 		    10}
					},
					result_count = 1,
					result = "basic-loader",
				},
				-- Loader
				{	name = "loader",		 
						type = "recipe",
						enabled = false,
						energy_required = 5,
						ingredients = 
						{
							{"electronic-circuit", 10},
							{"basic-loader", 	    1},
							{"iron-gear-wheel",	   14},
							{"iron-plate", 		   10}
						},
						result_count = 1,
						result = "loader",
					},
				})
		
			-- Replace Iron Plate with Tin Plate in loaders
			if data.raw.item["tin-plate"] then
				bobmods.lib.recipe.replace_ingredient("loader","iron-plate","tin-plate")
			end
			
			-- Replace Electronic Circuit with Basic Circuit in loaders
			if data.raw.item["basic-circuit-board"] then
				bobmods.lib.recipe.replace_ingredient("loader","electronic-circuit","basic-circuit-board")
			end
		end
	end

	return -- Loader Redux is handling research and recipes beyond this, so stop and let it handle things.

-- Loader Redux is installed, but we don't want Loader Redux to handle anything, so put recipes back the way they were.
elseif mods["LoaderRedux"] and settings.startup["vanillaLoaders-recipes-loaderReduxCompliant"].value == false then 		
		data:extend({
			{
				type = "recipe",
				name = "loader",
				enabled = false,
				energy_required = 5,
				ingredients = 
				{
					{"electronic-circuit", 5},
					{"transport-belt", 	   5},
					{"inserter",		   4},
					{"iron-gear-wheel",	  16}
				},
				result_count = 1,
				result = "loader",
			}
		})

		-- And put back the rest of the recipes.
		vanillaHD.createLoaderRecipe("fast-loader",    "fast-transport-belt",     "loader")
		vanillaHD.createLoaderRecipe("express-loader", "express-transport-belt",  "fast-loader")
		--vanillaHD.createLoaderRecipe("purple-loader",  "turbo-transport-belt",    "express-loader")
		--vanillaHD.createLoaderRecipe("green-loader",   "ultimate-transport-belt", "purple-loader"  )
end

-- Check for Bob's Logistics
if mods["boblogistics"] then

	-- Create default-compliant recipes for turbo/ultimate tier belts.
	vanillaHD.createLoaderRecipe("purple-loader", "turbo-transport-belt",    "express-loader")
	vanillaHD.createLoaderRecipe("green-loader",  "ultimate-transport-belt", "purple-loader"  )

	-- When Bob's belt overhaul is enabled, create a basic loader with the default-compliant recipe.
	-- Also replace the recipe for the loader with default-compliant recipe.
	if settings.startup["bobmods-logistics-beltoverhaul"].value == true then
		
		data:extend({
			-- Basic Loader
			{
				type = "recipe",
				name = "basic-loader",
				enabled = false,
				energy_required = 5,
				ingredients = 
				{
					{"wood", 				 4},
					{"basic-transport-belt", 5},					
					{"iron-gear-wheel", 	 6},
					{"copper-cable", 		 8}
				},
				result_count = 1,
				result = "basic-loader",
			}
		})
		
		-- Tweak the Basic Loader to include the material cost of inserters, if we're requiring
		-- inserters in loader recipes.
		if settings.startup["vanillaLoaders-recipes-includeInserters"].value == true then
			bobmods.lib.recipe.add_ingredient("basic-loader", {"iron-gear-wheel", 10})
			bobmods.lib.recipe.add_ingredient("basic-loader", {"copper-cable",    6})
		end
			
		-- Overwrite Loader with default-compliant recipe
		vanillaHD.createLoaderRecipe("loader","transport-belt","basic-loader")
		
		-- If Bob's belt speed overhaul is enabled, tweak the loader speeds to match. 
		-- Independent of Vanilla complex setting to maintain belt-speed compatibility. 
		-- Major issues if not matched.
		if settings.startup["bobmods-logistics-beltoverhaulspeed"].value == true then
			bobmods.logistics.set_belt_speed("loader","basic-loader",	1)
			bobmods.logistics.set_belt_speed("loader","loader",			2)
			bobmods.logistics.set_belt_speed("loader","fast-loader",	3)
			bobmods.logistics.set_belt_speed("loader","express-loader", 4)
			bobmods.logistics.set_belt_speed("loader","purple-loader",  5)
			bobmods.logistics.set_belt_speed("loader","green-loader",   6)
		end
	end
end

-- When all is said and done, the default loader recipe needs to be tweaked so that it
-- doesn't required a Tier 3 assembler to manufacture.
data:extend({
	{
		type = "recipe",
		name = "loader",
		enabled = false,
		energy_required = 5,
		ingredients = 
		{
			{"electronic-circuit", 5},
			{"transport-belt", 	   5},
			{"inserter",		   4},
			{"iron-gear-wheel",	  16}
		},
		result_count = 1,
		result = "loader",
	}
})