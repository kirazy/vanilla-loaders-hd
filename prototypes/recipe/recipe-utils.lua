-- Copyright (c) Kirazy
-- Part of Vanilla Loaders
--
-- See LICENSE.md in the project directory for license information.

---@class RecipeUtils
local recipe_utils = {}


---Checks if the given set of `ingredients` involves a fluid.
---@param ingredients data.IngredientPrototype[]
---@return boolean `true` if any of the ingredients in `ingredients` are `type = "fluid"`; otherwise, `false`.
function recipe_utils.is_crafted_with_fluid(ingredients)
    for _, ingredient in pairs(ingredients) do
        if ingredient.type == "fluid" then return true end
    end

    return false
end

---Gets the standard crafting category for a loader with the given `ingredients`.
---@param ingredients data.IngredientPrototype[] The ingredients to include in the recipe.
---@return data.RecipeCategoryID|nil
function recipe_utils.get_crafting_category(ingredients)
    local is_using_fluids = recipe_utils.is_crafted_with_fluid(ingredients)
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
function recipe_utils.create_recipe_from_ingredients(name, ingredients, category)
    ---@type data.RecipePrototype
    local recipe = {
        name = name,
        type = "recipe",
        category = category or recipe_utils.get_crafting_category(ingredients),
        enabled = false,
        energy_required = 5,
        ingredients = ingredients,
        results = { { type = "item", amount = 1, name = name } },
    }

    return recipe
end

return recipe_utils