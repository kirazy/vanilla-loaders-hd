-- Copyright (c) 2018 Kirazy
-- Part of Vanilla Loaders HD
--     
-- See LICENSE.md in the project directory for license information.

-- Crafting time fix
data.raw["recipe"]["loader"].energy_required = 5
data.raw["recipe"]["fast-loader"].energy_required = 5
data.raw["recipe"]["express-loader"].energy_required = 5

-- Check if we're only reskinning Loader Redux.
if mods["LoaderRedux"] and settings.startup["vanillaLoaders-reskinLoaderReduxOnly"].value == true then 
	return

-- Loader Redux is installed, but we don't want Loader Redux to handle anything, put recipes back the way they were.
elseif mods["LoaderRedux"] and settings.startup["vanillaLoaders-reskinLoaderReduxOnly"].value == false then 		
		data:extend({
			{
				-- The base Factorio loader recipe
				type = "recipe",
				name = "loader",
				enabled = false,
				energy_required = 5,
				ingredients = 
				{
					{"electronic-circuit", 5},
					{"transport-belt", 	   5},
					{"inserter",		   5},
					{"iron-gear-wheel",	   5},
					{"iron-plate",		   5}
				},
				result_count = 1,
				result = "loader",
			}
		})

		-- And put back the rest of the recipes.
		vanillaHD.createLoaderRecipe("fast-loader",    "fast-transport-belt",     "loader")
		vanillaHD.createLoaderRecipe("express-loader", "express-transport-belt",  "fast-loader")
end

-- Check for Bob's Logistics
if mods["boblogistics"] then

	-- Create default-compliant recipes for turbo/ultimate tier belts.
	vanillaHD.createLoaderRecipe("purple-loader", "turbo-transport-belt",    "express-loader")
	vanillaHD.createLoaderRecipe("green-loader",  "ultimate-transport-belt", "purple-loader"  )

	-- When Bob's belt overhaul is enabled, create a basic loader with the default recipe.
	if settings.startup["bobmods-logistics-beltoverhaul"].value == true then
		data:extend({
			{
				type = "recipe",
				name = "basic-loader",
				enabled = false,
				energy_required = 5,
				ingredients = 
				{
					{"wood", 				 6},
					{"stone", 				 4},
					{"basic-transport-belt", 5},					
					{"iron-gear-wheel", 	 4},
					{"copper-cable", 		 8}
				},
				result_count = 1,
				result = "basic-loader",
			}
		})
		
		-- Overwrite loader recipe with default-style recipe
		vanillaHD.createLoaderRecipe("loader","transport-belt","basic-loader")
	end
end