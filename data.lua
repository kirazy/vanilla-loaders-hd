-- Copyright (c) 2024 Kirazy
-- Part of Vanilla Loaders
--
-- See LICENSE.md in the project directory for license information.

require("prototypes.mods.base")

if mods["boblogistics"] then
    require("prototypes.mods.bobs-logistics")
end

if mods["UltimateBelts"] then
    require("prototypes.mods.ultimate-belts")
end

-- Process recipe updates
require("prototypes.recipe.recipe-complex-overhaul")
require("prototypes.recipe.recipe-belt-overhaul")
