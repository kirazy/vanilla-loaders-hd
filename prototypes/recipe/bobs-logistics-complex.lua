-- Copyright (c) Kirazy
-- Part of Vanilla Loaders
--
-- See LICENSE.md in the project directory for license information.

-- cspell: words beltoverhaul beltrequireprevious inserteroverhaul

if settings.startup["vanillaLoaders-recipes-loaderOverhaul"].value ~= true then return end
if not mods["boblogistics"] then return end

local recipe_utils = require("recipe-utils")

--- Creates the Vanilla Complex recipes for the tier 4 and 5 loaders added for Bob's mods.
---
--- Use when preference is given to Vanilla Loader's complex recipe mode.
local function extend_vanilla_complex_recipes_for_bobs_loaders()
	data:extend({
		recipe_utils.create_recipe_from_ingredients("bob-turbo-loader", {
			{ type = "item", amount = 10, name = "processing-unit" },
			{ type = "item", amount = 1, name = "express-loader" },
			{ type = "item", amount = 48, name = "iron-gear-wheel" },
			{ type = "item", amount = 5, name = "bob-turbo-transport-belt" },
			{ type = "fluid", amount = 80, name = "lubricant" },
		}),
		recipe_utils.create_recipe_from_ingredients("bob-ultimate-loader", {
			{ type = "item", amount = 10, name = "processing-unit" },
			{ type = "item", amount = 1, name = "bob-turbo-loader" },
			{ type = "item", amount = 60, name = "iron-gear-wheel" },
			{ type = "item", amount = 5, name = "bob-ultimate-transport-belt" },
			{ type = "fluid", amount = 120, name = "lubricant" },
		}),
	})
end

--- Creates recipes in the style of Bob's Belt Overhaul for the loaders added by this mod.
---
--- Use when preference is given to Bob's Mods overhaul mode.
local function extend_bobs_overhaul_recipes_for_loaders()
	data:extend({
		recipe_utils.create_recipe_from_ingredients("loader", {
			{ type = "item", amount = 5, name = "electronic-circuit" },
			{ type = "item", amount = 5, name = "transport-belt" },
			{ type = "item", amount = 6, name = "iron-gear-wheel" },
			{ type = "item", amount = 6, name = "iron-plate" },
		}),
		recipe_utils.create_recipe_from_ingredients("fast-loader", {
			{ type = "item", amount = 5, name = "electronic-circuit" },
			{ type = "item", amount = 5, name = "fast-transport-belt" },
			{ type = "item", amount = 6, name = "iron-gear-wheel" },
			{ type = "item", amount = 6, name = "steel-plate" },
		}),
		recipe_utils.create_recipe_from_ingredients("express-loader", {
			{ type = "item", amount = 5, name = "advanced-circuit" },
			{ type = "item", amount = 5, name = "express-transport-belt" },
			{ type = "item", amount = 6, name = "iron-gear-wheel" },
			{ type = "item", amount = 6, name = "steel-plate" },
		}),
		recipe_utils.create_recipe_from_ingredients("bob-turbo-loader", {
			{ type = "item", amount = 5, name = "processing-unit" },
			{ type = "item", amount = 5, name = "bob-turbo-transport-belt" },
			{ type = "item", amount = 6, name = "iron-gear-wheel" },
			{ type = "item", amount = 6, name = "steel-plate" },
		}),
		recipe_utils.create_recipe_from_ingredients("bob-ultimate-loader", {
			{ type = "item", amount = 5, name = "processing-unit" },
			{ type = "item", amount = 5, name = "bob-ultimate-transport-belt" },
			{ type = "item", amount = 6, name = "iron-gear-wheel" },
			{ type = "item", amount = 6, name = "steel-plate" },
		}),
	})
end

--- Adds standard inserters as ingredients to loaders.
local function add_standard_inserter_ingredients_to_loader_recipes()
	local loader_ingredients_map = {
		["bob-basic-loader"] = { type = "item", amount = 5, name = "burner-inserter" },
		["loader"] = { type = "item", amount = 5, name = "inserter" },
		["fast-loader"] = { type = "item", amount = 5, name = "long-handed-inserter" },
		["express-loader"] = { type = "item", amount = 5, name = "fast-inserter" },
		["bob-turbo-loader"] = { type = "item", amount = 5, name = "bulk-inserter" },
		["bob-ultimate-loader"] = { type = "item", amount = 5, name = "bob-express-bulk-inserter" },
	}

	for loader, ingredient in pairs(loader_ingredients_map) do
		bobmods.lib.recipe.add_ingredient(loader, ingredient)
	end
end

--- Adds Bob's overhaul inserters as ingredients to loaders.
local function add_bobs_overhaul_inserter_ingredients_to_loader_recipes()
	local loader_ingredients_map = {
		["bob-basic-loader"] = { type = "item", amount = 5, name = "burner-inserter" },
		["loader"] = { type = "item", amount = 5, name = "inserter" },
		["fast-loader"] = { type = "item", amount = 5, name = "bob-red-bulk-inserter" },
		["express-loader"] = { type = "item", amount = 5, name = "bulk-inserter" },
		["bob-turbo-loader"] = { type = "item", amount = 5, name = "bob-turbo-bulk-inserter" },
		["bob-ultimate-loader"] = { type = "item", amount = 5, name = "bob-express-bulk-inserter" },
	}

	for loader, ingredient in pairs(loader_ingredients_map) do
		bobmods.lib.recipe.add_ingredient(loader, ingredient)
	end
end

--- Adds the previous tier loader as ingredients to loaders.
local function add_previous_tier_ingredients_to_loader_recipes()
	local loader_ingredients_map = {
		["loader"] = {
			{ type = "item", amount = 1, name = "bob-basic-loader" },
			{ type = "item", amount = 10, name = "iron-gear-wheel" },
			{ type = "item", amount = 4, name = "iron-plate" },
		},
		["fast-loader"] = {
			{ type = "item", amount = 1, name = "loader" },
			{ type = "item", amount = 10, name = "iron-gear-wheel" },
			{ type = "item", amount = 4, name = "steel-plate" },
		},
		["express-loader"] = {
			{ type = "item", amount = 1, name = "fast-loader" },
			{ type = "item", amount = 10, name = "iron-gear-wheel" },
			{ type = "item", amount = 4, name = "steel-plate" },
		},
		["bob-turbo-loader"] = {
			{ type = "item", amount = 1, name = "express-loader" },
			{ type = "item", amount = 10, name = "iron-gear-wheel" },
			{ type = "item", amount = 4, name = "steel-plate" },
		},
		["bob-ultimate-loader"] = {
			{ type = "item", amount = 1, name = "bob-turbo-loader" },
			{ type = "item", amount = 10, name = "iron-gear-wheel" },
			{ type = "item", amount = 4, name = "steel-plate" },
		},
	}

	for loader, ingredients in pairs(loader_ingredients_map) do
		for _, ingredient in pairs(ingredients) do
			bobmods.lib.recipe.add_ingredient(loader, ingredient)
		end
	end
end

if settings.startup["bobmods-logistics-beltoverhaul"].value == true then
	extend_bobs_overhaul_recipes_for_loaders()

	if settings.startup["vanillaLoaders-recipes-includeInserters"].value == true then
		if settings.startup["bobmods-logistics-inserteroverhaul"].value == true then
			add_bobs_overhaul_inserter_ingredients_to_loader_recipes()
		else
			add_standard_inserter_ingredients_to_loader_recipes()
		end
	end

	if settings.startup["bobmods-logistics-beltrequireprevious"].value == true then
		add_previous_tier_ingredients_to_loader_recipes()
	end
else
	extend_vanilla_complex_recipes_for_bobs_loaders()
end
