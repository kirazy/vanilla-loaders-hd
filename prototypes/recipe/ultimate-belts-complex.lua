-- Copyright (c) Kirazy
-- Part of Vanilla Loaders
--
-- See LICENSE.md in the project directory for license information.

if settings.startup["vanillaLoaders-recipes-loaderOverhaul"].value ~= true then return end

local is_using_ultimate_belts = mods["UltimateBelts"]
	or mods["UltimateBeltsSpaceAge"]
	or mods["UltimateBelts_Owoshima_And_Pankeko-Mod"]

if not is_using_ultimate_belts then return end

local recipe_utils = require("recipe-utils")

data:extend({
	recipe_utils.create_recipe_from_ingredients("ub-ultra-fast-loader", {
		{ type = "item", amount = 15, name = "iron-gear-wheel" },
		{ type = "item", amount = 10, name = "advanced-circuit" },
		{ type = "item", amount = 2, name = "express-loader" },
	}),
	recipe_utils.create_recipe_from_ingredients("ub-extreme-fast-loader", {
		{ type = "item", amount = 15, name = "iron-gear-wheel" },
		{ type = "item", amount = 5, name = "processing-unit" },
		{ type = "item", amount = 1, name = "express-loader" },
		{ type = "item", amount = 1, name = "ub-ultra-fast-loader" },
	}),
	recipe_utils.create_recipe_from_ingredients("ub-ultra-express-loader", {
		{ type = "item", amount = 15, name = "iron-gear-wheel" },
		{ type = "item", amount = 5, name = "processing-unit" },
		{ type = "item", amount = 1, name = "express-loader" },
		{ type = "item", amount = 1, name = "ub-extreme-fast-loader" },
		{ type = "item", amount = 1, name = "speed-module" },
	}),
	recipe_utils.create_recipe_from_ingredients("ub-extreme-express-loader", {
		{ type = "item", amount = 15, name = "iron-gear-wheel" },
		{ type = "item", amount = 5, name = "processing-unit" },
		{ type = "item", amount = 1, name = "express-loader" },
		{ type = "item", amount = 1, name = "ub-ultra-express-loader" },
		{ type = "item", amount = 1, name = "speed-module-2" },
	}),
	recipe_utils.create_recipe_from_ingredients("ub-ultimate-loader", {
		{ type = "item", amount = 15, name = "iron-gear-wheel" },
		{ type = "item", amount = 5, name = "processing-unit" },
		{ type = "item", amount = 1, name = "express-loader" },
		{ type = "item", amount = 1, name = "ub-extreme-express-loader" },
		{ type = "item", amount = 1, name = "speed-module-3" },
	}),
})
