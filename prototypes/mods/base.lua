-- Copyright (c) 2018-2026 Kirazy
-- Part of Vanilla Loaders
--
-- See LICENSE.md in the project directory for license information.

---@type VanillaLoadersApi
local api = require("prototypes.api")

api.create_loader("loader", "transport-belt", {
    technology = "logistics",
    mask_tint = util.color("ffc340d1"),
})

api.create_loader("fast-loader", "fast-transport-belt", {
    previous_tier = "loader",
    technology = "logistics-2",
    mask_tint = util.color("e31717d1"),
})

api.create_loader("express-loader", "express-transport-belt", {
    previous_tier = "fast-loader",
    technology = "logistics-3",
    mask_tint = util.color("43c0fad1"),
})
