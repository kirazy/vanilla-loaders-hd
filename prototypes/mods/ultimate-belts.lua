-- Copyright (c) Kirazy
-- Part of Vanilla Loaders
--
-- See LICENSE.md in the project directory for license information.

---@type VanillaLoadersApi
local api = require("prototypes.api")

local is_using_ultimate_belts = mods["UltimateBelts"]
    or mods["UltimateBeltsSpaceAge"]
    or mods["UltimateBelts_Owoshima_And_Pankeko-Mod"]

if not is_using_ultimate_belts then return end

local is_using_owoshima = mods["UltimateBelts_Owoshima_And_Pankeko-Mod"] and true or false

api.create_loader("ub-ultra-fast-loader", "ultra-fast-belt", {
    technology = "ultra-fast-logistics",
    previous_tier = "express-loader",
    mask_tint = is_using_owoshima and util.color("2bc24bDB") or util.color("00b30cFF"),
    base_tint = util.color("404040"),
})

api.create_loader("ub-extreme-fast-loader", "extreme-fast-belt", {
    technology = "extreme-fast-logistics",
    previous_tier = "ub-ultra-fast-loader",
    mask_tint = is_using_owoshima and util.color("c4632fDB") or util.color("e00000FF"),
    base_tint = util.color("404040"),
})

api.create_loader("ub-ultra-express-loader", "ultra-express-belt", {
    technology = "ultra-express-logistics",
    previous_tier = "ub-extreme-fast-loader",
    mask_tint = is_using_owoshima and util.color("6f2de0D1") or util.color("3604b5E8"),
    base_tint = util.color("404040"),
})

api.create_loader("ub-extreme-express-loader", "extreme-express-belt", {
    technology = "extreme-express-logistics",
    previous_tier = "ub-ultra-express-loader",
    mask_tint = is_using_owoshima and util.color("3d3af0DB") or util.color("002bffFF"),
    base_tint = util.color("404040"),
})

api.create_loader("ub-ultimate-loader", "ultimate-belt", {
    technology = "ultimate-logistics",
    previous_tier = "ub-extreme-express-loader",
    mask_tint = is_using_owoshima and util.color("999999D1") or util.color("00ffddD1"),
    base_tint = util.color("404040"),
})
