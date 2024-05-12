-- Copyright (c) 2024 Kirazy
-- Part of Vanilla Loaders
--
-- See LICENSE.md in the project directory for license information.

vanilla_loaders.create_loader("loader", "transport-belt", {
    technology = "logistics",
    mask_tint = util.color("ffc340d1"),
})

vanilla_loaders.create_loader("fast-loader", "fast-transport-belt", {
    previous_tier = "loader",
    technology = "logistics-2",
    mask_tint = util.color("e31717d1"),
})

vanilla_loaders.create_loader("express-loader", "express-transport-belt", {
    previous_tier = "fast-loader",
    technology = "logistics-3",
    mask_tint = util.color("43c0fad1"),
})
