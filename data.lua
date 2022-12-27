-- Copyright (c) 2022 Kirazy
-- Part of Vanilla Loaders HD
--
-- See LICENSE.md in the project directory for license information.

require("prototypes.functions")

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
        -- Restore the loader recipe to their basic state
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

-- Ultimate belts
if mods["UltimateBelts"] then
    loaders["ub-ultra-fast-loader"] = {source_belt = "ultra-fast-belt", parameters = {technology = "ultra-fast-logistics", previous_tier = "express-loader", base_tint = util.color("404040")}}
    loaders["ub-extreme-fast-loader"] = {source_belt = "extreme-fast-belt", parameters = {technology = "extreme-fast-logistics", previous_tier = "ub-ultra-fast-loader", base_tint = util.color("404040")}}
    loaders["ub-ultra-express-loader"] = {source_belt = "ultra-express-belt", parameters = {technology = "ultra-express-logistics", previous_tier = "ub-extreme-fast-loader", base_tint = util.color("404040")}}
    loaders["ub-extreme-express-loader"] = {source_belt = "extreme-express-belt", parameters = {technology = "extreme-express-logistics", previous_tier = "ub-ultra-express-loader", base_tint = util.color("404040")}}
    loaders["ub-ultimate-loader"] = {source_belt = "ultimate-belt", parameters = {technology = "ultimate-logistics", previous_tier = "ub-extreme-express-loader", base_tint = util.color("404040")}}
end

-- Required execution order
local sorted_loaders = {
    "basic-loader",
    "loader",
    "fast-loader",
    "express-loader",
    "purple-loader",
    "green-loader",
    "ub-ultra-fast-loader",
    "ub-extreme-fast-loader",
    "ub-ultra-express-loader",
    "ub-extreme-express-loader",
    "ub-ultimate-loader",
}

for _, name in pairs(sorted_loaders) do
    if loaders[name] then
        vanillaHD.setup_loader(name, loaders[name].source_belt, loaders[name].parameters)
    end
end

-- Process recipe updates
require("prototypes.recipe.recipe-complex-overhaul")
require("prototypes.recipe.recipe-belt-overhaul")