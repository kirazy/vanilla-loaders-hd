---@namespace VanillaLoaders

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
		if ingredient.type == "fluid" then
			return true
		end
	end

	return false
end

---Gets the standard crafting category for a loader with the given `ingredients`.
---@param ingredients data.IngredientPrototype[] The ingredients to include in the recipe.
---@return data.RecipeCategoryID[]|nil
function recipe_utils.get_crafting_categories(ingredients)
	local is_using_fluids = recipe_utils.is_crafted_with_fluid(ingredients)
	local is_using_space_age = mods["space-age"]

	---@type data.RecipeCategoryID[]
	local categories = {}
	if is_using_fluids then
		categories[#categories + 1] = "crafting-with-fluid"
		if is_using_space_age then
			categories[#categories + 1] = "metallurgy"
		end
	end

	return #categories >= 1 and categories or nil
end

--- Creates the recipe for a loader with the given `name` from the given `ingredients` in a
--- common format, resulting in 1 unit produced over 5 seconds.
---@param name string The name of the loader.
---@param ingredients data.IngredientPrototype[] The ingredients to include in the recipe.
---@param categories? data.RecipeCategoryID[] The category of the recipe.
---@return data.RecipePrototype The loader recipe.
function recipe_utils.create_recipe_from_ingredients(name, ingredients, categories)
	if categories then
		assert(
			type(categories) == "table",
			"categories must be table, but was " .. type(categories) .. ": " .. serpent.block(categories) .. "."
		)
		assert(#categories >= 1, "categories must contain at least one element")
	end

	---@type data.RecipePrototype
	local recipe = {
		name = name,
		type = "recipe",
		categories = categories or recipe_utils.get_crafting_categories(ingredients),
		enabled = false,
		energy_required = 5,
		ingredients = ingredients,
		results = { { type = "item", amount = 1, name = name } },
	}

	return recipe
end

return recipe_utils
