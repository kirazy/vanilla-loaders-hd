-- Copyright (c) 2024 Kirazy
-- Part of Vanilla Loaders
--
-- See LICENSE.md in the project directory for license information.

-- Check for recipe overhaul, and if true, create base overhaul recipes.
if settings.startup["vanillaLoaders-recipes-loaderOverhaul"].value ~= true then return end

---Checks if the given set of `ingredients` involves a fluid.
---@param ingredients data.IngredientPrototype[]
---@return boolean `true` if any of the ingredients in `ingredients` are `type = "fluid"`; otherwise, `false`.
local function is_crafted_with_fluid(ingredients)
    for _, ingredient in pairs(ingredients) do
        if ingredient.type == "fluid" then return true end
    end

    return false
end

---Gets the standard crafting category for a loader with the given `ingredients`.
---@param ingredients data.IngredientPrototype[] The incredients to include in the recipe.
---@return data.RecipeCategoryID|nil
local function get_crafting_category(ingredients)
    local is_using_fluids = is_crafted_with_fluid(ingredients)
    local is_using_space_age = mods["space-age"]

    local category
    if is_using_space_age and is_using_fluids then
        category = "crafting-with-fluid-or-metallurgy"
    elseif is_using_space_age then
        category = "pressing"
    elseif is_using_fluids then
        category = "crafting-with-fluid"
    end

    return category
end

--- Creates the recipe for a loader with the given `name` from the given `ingredients` in a
--- common format, resulting in 1 unit produced over 5 seconds.
---@param name string The name of the loader.
---@param ingredients data.IngredientPrototype[] The ingredients to include in the recipe.
---@param category? data.RecipeCategoryID The category of the recipe.
---@return data.RecipePrototype The loader recipe.
local function create_recipe_from_ingredients(name, ingredients, category)
    ---@type data.RecipePrototype
    local recipe = {
        name = name,
        type = "recipe",
        category = category or get_crafting_category(ingredients),
        enabled = false,
        energy_required = 5,
        ingredients = ingredients,
        results = { { type = "item", amount = 1, name = name } },
    }

    return recipe
end

-- Create the Vanilla Complex base loader recipes
---@type data.RecipePrototype[]
local base_complex_recipes = {
    create_recipe_from_ingredients("loader", {
        { type = "item", amount = 5,  name = "electronic-circuit" },
        { type = "item", amount = 5,  name = "transport-belt" },
        { type = "item", amount = 8,  name = "iron-gear-wheel" },
        { type = "item", amount = 16, name = "iron-plate" },
        { type = "item", amount = 4,  name = "inserter" },
    }),
    create_recipe_from_ingredients("fast-loader", {
        { type = "item", amount = 10, name = "electronic-circuit" },
        { type = "item", amount = 1,  name = "loader" },
        { type = "item", amount = 24, name = "iron-gear-wheel" },
        { type = "item", amount = 5,  name = "fast-transport-belt" },
    }),
    create_recipe_from_ingredients("express-loader", {
        { type = "item",  amount = 10, name = "advanced-circuit" },
        { type = "item",  amount = 1,  name = "fast-loader" },
        { type = "item",  amount = 32, name = "iron-gear-wheel" },
        { type = "item",  amount = 5,  name = "express-transport-belt" },
        { type = "fluid", amount = 40, name = "lubricant" },
    }),
}

if mods["space-age"] then
    local recipe = create_recipe_from_ingredients("turbo-loader", {
        { type = "item",  amount = 2,  name = "processing-unit" },
        { type = "item",  amount = 1,  name = "express-loader" },
        { type = "item",  amount = 24, name = "tungsten-plate" },
        { type = "item",  amount = 5,  name = "turbo-transport-belt" },
        { type = "fluid", amount = 40, name = "lubricant" },
    }, "metallurgy")

    recipe.surface_conditions = {
        {
            property = "pressure",
            min = 4000,
            max = 4000,
        },
    }

    table.insert(base_complex_recipes, recipe)
end

data:extend(base_complex_recipes)

--- Creates the Vanilla Complex recipes for the tier 4 and 5 loaders added for Bob's mods.
---
--- Use when preference is given to Vanilla Loader's complex recipe mode.
local function create_vanilla_complex_recipes_for_bobs_loaders()
    ---@type data.RecipePrototype[]
    local bob_complex_recipes = {
        create_recipe_from_ingredients("bob-turbo-loader", {
            { type = "item",  amount = 10, name = "processing-unit" },
            { type = "item",  amount = 1,  name = "express-loader" },
            { type = "item",  amount = 48, name = "iron-gear-wheel" },
            { type = "item",  amount = 5,  name = "bob-turbo-transport-belt" },
            { type = "fluid", amount = 80, name = "lubricant" },
        }),
        create_recipe_from_ingredients("bob-ultimate-loader", {
            { type = "item",  amount = 10,  name = "processing-unit" },
            { type = "item",  amount = 1,   name = "bob-turbo-loader" },
            { type = "item",  amount = 60,  name = "iron-gear-wheel" },
            { type = "item",  amount = 5,   name = "bob-ultimate-transport-belt" },
            { type = "fluid", amount = 120, name = "lubricant" },
        }),
    }
    data:extend(bob_complex_recipes)
end

if mods["boblogistics"] then
    --- Creates recipes in the style of Bob's Belt Overhaul for the loaders added by this mod.
    ---
    --- Use when preference is given to Bob's Mods overhaul mode.
    local function create_bobs_overhaul_recipes_for_loaders()
        ---@type data.RecipePrototype[]
        local bob_overhaul_recipes = {
            create_recipe_from_ingredients("loader", {
                { type = "item", amount = 5, name = "electronic-circuit" },
                { type = "item", amount = 5, name = "transport-belt" },
                { type = "item", amount = 6, name = "iron-gear-wheel" },
                { type = "item", amount = 6, name = "iron-plate" },
            }),
            create_recipe_from_ingredients("fast-loader", {
                { type = "item", amount = 5, name = "electronic-circuit" },
                { type = "item", amount = 5, name = "fast-transport-belt" },
                { type = "item", amount = 6, name = "iron-gear-wheel" },
                { type = "item", amount = 6, name = "steel-plate" },
            }),
            create_recipe_from_ingredients("express-loader", {
                { type = "item", amount = 5, name = "advanced-circuit" },
                { type = "item", amount = 5, name = "express-transport-belt" },
                { type = "item", amount = 6, name = "iron-gear-wheel" },
                { type = "item", amount = 6, name = "steel-plate" },
            }),
            create_recipe_from_ingredients("bob-turbo-loader", {
                { type = "item", amount = 5, name = "processing-unit" },
                { type = "item", amount = 5, name = "bob-turbo-transport-belt" },
                { type = "item", amount = 6, name = "iron-gear-wheel" },
                { type = "item", amount = 6, name = "steel-plate" },
            }),
            create_recipe_from_ingredients("bob-ultimate-loader", {
                { type = "item", amount = 5, name = "processing-unit" },
                { type = "item", amount = 5, name = "bob-ultimate-transport-belt" },
                { type = "item", amount = 6, name = "iron-gear-wheel" },
                { type = "item", amount = 6, name = "steel-plate" },
            }),
        }
        data:extend(bob_overhaul_recipes)
    end

    --- Adds standard inserters as ingredients to loaders.
    local function add_standard_inserter_ingredients_to_loader_recipes()
        local loader_ingredients_map = {
            ["bob-basic-loader"]   = { type = "item", amount = 5, name = "burner-inserter" },
            ["loader"]         = { type = "item", amount = 5, name = "inserter" },
            ["fast-loader"]    = { type = "item", amount = 5, name = "long-handed-inserter" },
            ["express-loader"] = { type = "item", amount = 5, name = "fast-inserter" },
            ["bob-turbo-loader"]  = { type = "item", amount = 5, name = "bulk-inserter" },
            ["bob-ultimate-loader"]   = { type = "item", amount = 5, name = "bob-express-bulk-inserter" },
        }

        for loader, ingredient in pairs(loader_ingredients_map) do
            bobmods.lib.recipe.add_ingredient(loader, ingredient)
        end
    end

    --- Adds Bob's overhaul inserters as ingredients to loaders.
    local function add_bobs_overhaul_inserter_ingredients_to_loader_recipes()
        local loader_ingredients_map = {
            ["bob-basic-loader"]   = { type = "item", amount = 5, name = "burner-inserter" },
            ["loader"]         = { type = "item", amount = 5, name = "inserter" },
            ["fast-loader"]    = { type = "item", amount = 5, name = "bob-red-bulk-inserter" },
            ["express-loader"] = { type = "item", amount = 5, name = "bulk-inserter" },
            ["bob-turbo-loader"]  = { type = "item", amount = 5, name = "bob-turbo-bulk-inserter" },
            ["bob-ultimate-loader"]   = { type = "item", amount = 5, name = "bob-express-bulk-inserter" },
        }

        for loader, ingredient in pairs(loader_ingredients_map) do
            bobmods.lib.recipe.add_ingredient(loader, ingredient)
        end
    end

    --- Adds the previous tier loader as ingredients to loaders.
    local function add_previous_tier_ingredients_to_loader_recipes()
        local loader_ingredients_map = {
            ["loader"] = {
                { type = "item", amount = 1,  name = "bob-basic-loader" },
                { type = "item", amount = 10, name = "iron-gear-wheel" },
                { type = "item", amount = 4,  name = "iron-plate" },
            },
            ["fast-loader"] = {
                { type = "item", amount = 1,  name = "loader" },
                { type = "item", amount = 10, name = "iron-gear-wheel" },
                { type = "item", amount = 4,  name = "steel-plate" },
            },
            ["express-loader"] = {
                { type = "item", amount = 1,  name = "fast-loader" },
                { type = "item", amount = 10, name = "iron-gear-wheel" },
                { type = "item", amount = 4,  name = "steel-plate" },
            },
            ["bob-turbo-loader"] = {
                { type = "item", amount = 1,  name = "express-loader" },
                { type = "item", amount = 10, name = "iron-gear-wheel" },
                { type = "item", amount = 4,  name = "steel-plate" },
            },
            ["bob-ultimate-loader"] = {
                { type = "item", amount = 1,  name = "bob-turbo-loader" },
                { type = "item", amount = 10, name = "iron-gear-wheel" },
                { type = "item", amount = 4,  name = "steel-plate" },
            },
        }

        for loader, ingredients in pairs(loader_ingredients_map) do
            for _, ingredient in pairs(ingredients) do
                bobmods.lib.recipe.add_ingredient(loader, ingredient)
            end
        end
    end

    if settings.startup["bobmods-logistics-beltoverhaul"].value == true then
        create_bobs_overhaul_recipes_for_loaders()

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
        create_vanilla_complex_recipes_for_bobs_loaders()
    end
end

-- Setup the complex recipes for the loaders for Ultimate Belts
if mods["UltimateBelts"] then
    ---@type data.RecipePrototype[]
    local ultimate_belts_complex_recipes = {
        create_recipe_from_ingredients("ub-ultra-fast-loader", {
            { type = "item", amount = 15, name = "iron-gear-wheel" },
            { type = "item", amount = 10, name = "advanced-circuit" },
            { type = "item", amount = 2,  name = "express-loader" },
        }),
        create_recipe_from_ingredients("ub-extreme-fast-loader", {
            { type = "item", amount = 15, name = "iron-gear-wheel" },
            { type = "item", amount = 5,  name = "processing-unit" },
            { type = "item", amount = 1,  name = "express-loader" },
            { type = "item", amount = 1,  name = "ub-ultra-fast-loader" },
        }),
        create_recipe_from_ingredients("ub-ultra-express-loader", {
            { type = "item", amount = 15, name = "iron-gear-wheel" },
            { type = "item", amount = 5,  name = "processing-unit" },
            { type = "item", amount = 1,  name = "express-loader" },
            { type = "item", amount = 1,  name = "ub-extreme-fast-loader" },
            { type = "item", amount = 1,  name = "speed-module" },
        }),
        create_recipe_from_ingredients("ub-extreme-express-loader", {
            { type = "item", amount = 15, name = "iron-gear-wheel" },
            { type = "item", amount = 5,  name = "processing-unit" },
            { type = "item", amount = 1,  name = "express-loader" },
            { type = "item", amount = 1,  name = "ub-ultra-express-loader" },
            { type = "item", amount = 1,  name = "speed-module-2" },
        }),
        create_recipe_from_ingredients("ub-ultimate-loader", {
            { type = "item", amount = 15, name = "iron-gear-wheel" },
            { type = "item", amount = 5,  name = "processing-unit" },
            { type = "item", amount = 1,  name = "express-loader" },
            { type = "item", amount = 1,  name = "ub-extreme-express-loader" },
            { type = "item", amount = 1,  name = "speed-module-3" },
        }),
    }

    data:extend(ultimate_belts_complex_recipes)
end
