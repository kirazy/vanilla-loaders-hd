-- Copyright (c) 2024 Kirazy
-- Part of Vanilla Loaders
--
-- See LICENSE.md in the project directory for license information.

---@type VanillaLoadersApi
local api = require("prototypes.api")

if not mods["boblogistics"] then return end

if data.raw["transport-belt"]["basic-transport-belt"] then
    api.create_loader("basic-loader", "basic-transport-belt", {
        next_tier = "loader",
        ingredients = {
            { type = "item", amount = 6, name = "wood" },
            { type = "item", amount = 4, name = "stone" },
            { type = "item", amount = 5, name = "basic-transport-belt" },
            { type = "item", amount = 4, name = "iron-gear-wheel" },
            { type = "item", amount = 8, name = "copper-cable" },
        },
        technology = "logistics-0",
        mask_tint = (mods["boblogistics-belt-reskin"] or mods["bob-basic-belt-reskin"]) and
            util.color("00000000") or
            util.color("7d7d7dd1"),
    })
end

api.create_loader("purple-loader", "turbo-transport-belt", {
    previous_tier = "express-loader",
    technology = "logistics-4",
    mask_tint = mods["boblogistics-belt-reskin"] and util.color("df1ee5d1") or util.color("a510e5d1"),
})

api.create_loader("green-loader", "ultimate-transport-belt", {
    previous_tier = "purple-loader",
    technology = "logistics-5",
    mask_tint = util.color("16f263d1"),
})
