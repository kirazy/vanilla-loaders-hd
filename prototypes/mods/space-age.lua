-- Copyright (c) 2018-2026 Kirazy
-- Part of Vanilla Loaders
--
-- See LICENSE.md in the project directory for license information.

---@type VanillaLoadersApi
local api = require("prototypes.api")

if not mods["space-age"] then return end

api.create_loader("turbo-loader", "turbo-transport-belt", {
    previous_tier = "express-loader",
    technology = "turbo-transport-belt",
    mask_tint = util.color("94cc33d1"),
})
