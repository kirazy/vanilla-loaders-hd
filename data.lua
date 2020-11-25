-- Copyright (c) 2018 Kirazy
-- Part of Vanilla Loaders HD
--
-- See LICENSE.md in the project directory for license information.

require("prototypes.functions")
-- require("prototypes.item.loader-item")
-- require("prototypes.recipe.loader-recipe")
-- require("prototypes.recipe.loader-recipe-belt-overhaul")
-- require("prototypes.recipe.loader-recipe-update")
-- require("prototypes.entity.loader-particles")
-- require("prototypes.entity.loader-explosions")
-- require("prototypes.entity.loader-remnants")
-- require("prototypes.entity.loader-entity")
-- require("prototypes.technology.loader-technology")

-- Setup the standard set of loaders
local loaders = {
    ["loader"] = {source_belt = "transport-belt", parameters = {technology = "logistics"}},
    ["fast-loader"] = {source_belt = "fast-transport-belt", parameters = {previous_tier = "loader", technology = "logistics-2"}},
    ["express-loader"] = {source_belt = "express-transport-belt", parameters = {previous_tier = "fast-loader", technology = "logistics-3"}},
}

-- Handle Bob's Logistics
if mods["boblogistics"] then
    -- Check that the belt overhaul has been enabled, but only prepare the basic loader if we're not just a reskin mod for Loader Redux
    if data.raw["transport-belt"]["basic-transport-belt"] then
        local basic_loader_ingredients = {
            {"wood", 6},
            {"stone", 4},
            {"basic-transport-belt", 5},
            {"iron-gear-wheel", 4},
            {"copper-cable", 8}
        }

        loaders["basic-loader"] = {source_belt = "basic-transport-belt", parameters = {ingredients = basic_loader_ingredients, technology = "logistics-0"}}
        loaders["loader"].parameters.previous_tier = "basic-loader"
    end

    -- Setup the turbo and ultimate loaders
    loaders["purple-loader"] = {source_belt = "turbo-transport-belt", parameters = {previous_tier = "express-loader", technology = "logistics-4"}}
    loaders["green-loader"] = {source_belt = "ultimate-transport-belt", parameters = {previous_tier = "purple-loader", technology = "logistics-5"}}
end

-- Check to see if we're just reskinning Loader Redux
if mods["LoaderRedux"] then
    if settings.startup["vanillaLoaders-reskinLoaderReduxOnly"].value == true then
        -- Prepare loaders for reskinning only
        if loaders["basic-loader"] then loaders["basic-loader"] = nil end -- LR doesn't support the basic loader
        loaders["loader"].parameters = nil
        loaders["fast-loader"].parameters = nil
        loaders["express-loader"].parameters = nil
        if loaders["purple-loader"] then loaders["purple-loader"].parameters = nil end
        if loaders["green-loader"] then loaders["green-loader"].parameters = nil end
    else
        -- Restore the loader recipes to their basic state
        if not loaders["basic-loader"] then
            loaders["loader"].parameters = {ingredients = {
                {"electronic-circuit", 5},
                {"transport-belt", 5},
                {"inserter", 5},
                {"iron-gear-wheel", 5},
                {"iron-plate", 5}
            }}
        end
    end
end

-- Required execution order
local sorted_loaders = {
    "basic-loader",
    "loader",
    "fast-loader",
    "express-loader",
    "purple-loader",
    "green-loader",
}

for _, name in pairs(sorted_loaders) do
    if loaders[name] then
        vanillaHD.setup_loader(name, loaders[name].source_belt, loaders[name].parameters)
    end
end

-- Process recipe updates
require("prototypes.recipe.recipe-complex-overhaul")
require("prototypes.recipe.recipe-belt-overhaul")