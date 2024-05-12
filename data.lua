-- Copyright (c) 2024 Kirazy
-- Part of Vanilla Loaders
--
-- See LICENSE.md in the project directory for license information.

-- Vanilla Loaders global function host.
---@type VanillaLoadersApi
vanilla_loaders = require("prototypes.api")

require("prototypes.api-deprecated")

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
