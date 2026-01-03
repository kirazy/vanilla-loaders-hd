-- Copyright (c) Kirazy
-- Part of Vanilla Loaders
--
-- See LICENSE.md in the project directory for license information.

if settings.startup["vanillaLoaders-recipes-loaderOverhaul"].value ~= true then return end
if not mods["more-belts"] then return end

local recipe_utils = require("recipe-utils")

data:extend({
	recipe_utils.create_recipe_from_ingredients("ddi-loader-mk4", {
		{ type = "item", amount = 1, name = "express-loader" },
		{ type = "item", amount = 5, name = "ddi-transport-belt-mk4" },
		{ type = "item", amount = 48, name = "iron-gear-wheel" },
		{ type = "item", amount = 10, name = "advanced-circuit" },
		{ type = "fluid", amount = 40, name = "lubricant" },
	}),
	recipe_utils.create_recipe_from_ingredients("ddi-loader-mk5", {
		{ type = "item", amount = 1, name = "ddi-loader-mk4" },
		{ type = "item", amount = 5, name = "ddi-transport-belt-mk5" },
		{ type = "item", amount = 60, name = "iron-gear-wheel" },
		{ type = "item", amount = 10, name = "processing-unit" },
		{ type = "item", amount = 3, name = "electric-engine-unit" },
		{ type = "item", amount = 5, name = "low-density-structure" },
		{ type = "fluid", amount = 40, name = "lubricant" },
	}),
	recipe_utils.create_recipe_from_ingredients("ddi-loader-mk6", {
		{ type = "item", amount = 1, name = "ddi-loader-mk5" },
		{ type = "item", amount = 5, name = "ddi-transport-belt-mk6" },
		{ type = "item", amount = 72, name = "iron-gear-wheel" },
		{ type = "item", amount = 1, name = "speed-module" },
		{ type = "item", amount = 1, name = "productivity-module" },
		{ type = "fluid", amount = 40, name = "lubricant" },
	}),
	recipe_utils.create_recipe_from_ingredients("ddi-loader-mk7", {
		{ type = "item", amount = 1, name = "ddi-loader-mk6" },
		{ type = "item", amount = 5, name = "ddi-transport-belt-mk7" },
		{ type = "item", amount = 84, name = "iron-gear-wheel" },
		{ type = "item", amount = 1, name = "speed-module-2" },
		{ type = "item", amount = 1, name = "productivity-module-2" },
		{ type = "fluid", amount = 40, name = "lubricant" },
	}),
	recipe_utils.create_recipe_from_ingredients("ddi-loader-mk8", {
		{ type = "item", amount = 1, name = "ddi-loader-mk7" },
		{ type = "item", amount = 5, name = "ddi-transport-belt-mk8" },
		{ type = "item", amount = 96, name = "iron-gear-wheel" },
		{ type = "item", amount = 1, name = "speed-module-3" },
		{ type = "item", amount = 1, name = "productivity-module-3" },
		{ type = "fluid", amount = 40, name = "lubricant" },
	}),
})
