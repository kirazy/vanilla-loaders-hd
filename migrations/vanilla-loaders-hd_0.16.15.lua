-- Copyright (c) 2024 Kira
-- Part of Vanilla Loaders
--
-- See LICENSE.md in the project directory for license information.

---Ensures that a given `recipe` is unlocked if the `technology` that unlocks it has been researched.
---@param technology string The prototype name of the technology.
---@param recipe string The prototype name of the recipe.
local function unlock_recipe_if_technology_is_researched(technology, recipe)
    for _, force in pairs(game.forces) do
        if force.technologies[technology] then
            force.recipes[recipe].enabled = force.technologies[technology].researched
        end
    end
end

unlock_recipe_if_technology_is_researched("logistics", "loader")
unlock_recipe_if_technology_is_researched("logistics-2", "fast-loader")
unlock_recipe_if_technology_is_researched("logistics-3", "express-loader")
unlock_recipe_if_technology_is_researched("bob-logistics-4", "purple-loader")
unlock_recipe_if_technology_is_researched("bob-logistics-5", "green-loader")
