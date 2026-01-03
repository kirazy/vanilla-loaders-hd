-- Copyright (c) Kirazy
-- Part of Vanilla Loaders
--
-- See LICENSE.md in the project directory for license information.

if settings.startup["vanillaLoaders-recipes-loaderOverhaul"].value ~= true then return end

local recipe_utils = require("recipe-utils")

if not mods["space-age"] then return end

local recipe = recipe_utils.create_recipe_from_ingredients("turbo-loader", {
    { type = "item", amount = 2, name = "processing-unit" },
    { type = "item", amount = 1, name = "express-loader" },
    { type = "item", amount = 24, name = "tungsten-plate" },
    { type = "item", amount = 5, name = "turbo-transport-belt" },
    { type = "fluid", amount = 40, name = "lubricant" },
}, "metallurgy")

recipe.surface_conditions = {
    {
        property = "pressure",
        min = 4000,
        max = 4000,
    },
}

data.extend({recipe})
