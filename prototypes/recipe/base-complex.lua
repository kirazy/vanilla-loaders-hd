-- Copyright (c) Kirazy
-- Part of Vanilla Loaders
--
-- See LICENSE.md in the project directory for license information.

if settings.startup["vanillaLoaders-recipes-loaderOverhaul"].value ~= true then return end

local recipe_utils = require("recipe-utils")

data:extend({
	recipe_utils.create_recipe_from_ingredients("loader", {
		{ type = "item", amount = 5, name = "electronic-circuit" },
		{ type = "item", amount = 5, name = "transport-belt" },
		{ type = "item", amount = 8, name = "iron-gear-wheel" },
		{ type = "item", amount = 16, name = "iron-plate" },
		{ type = "item", amount = 4, name = "inserter" },
	}),
	recipe_utils.create_recipe_from_ingredients("fast-loader", {
		{ type = "item", amount = 10, name = "electronic-circuit" },
		{ type = "item", amount = 1, name = "loader" },
		{ type = "item", amount = 24, name = "iron-gear-wheel" },
		{ type = "item", amount = 5, name = "fast-transport-belt" },
	}),
	recipe_utils.create_recipe_from_ingredients("express-loader", {
		{ type = "item", amount = 10, name = "advanced-circuit" },
		{ type = "item", amount = 1, name = "fast-loader" },
		{ type = "item", amount = 32, name = "iron-gear-wheel" },
		{ type = "item", amount = 5, name = "express-transport-belt" },
		{ type = "fluid", amount = 40, name = "lubricant" },
	}),
})