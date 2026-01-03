-- Copyright (c) Kirazy
-- Part of Vanilla Loaders
--
-- See LICENSE.md in the project directory for license information.

local api = require("prototypes.api")

if not mods["more-belts"] then return end

api.create_loader("ddi-loader-mk4", "ddi-transport-belt-mk4", {
    technology = "logistics-4",
    previous_tier = "express-loader",
    mask_tint = util.color("#66ffba"),
})

api.create_loader("ddi-loader-mk5", "ddi-transport-belt-mk5", {
    technology = "logistics-5",
    previous_tier = "ddi-loader-mk4",
    mask_tint = util.color("#669cff"),
})

api.create_loader("ddi-loader-mk6", "ddi-transport-belt-mk6", {
	technology = "logistics-6",
	previous_tier = "ddi-loader-mk5",
	mask_tint = util.color("#ff9166"),
})

api.create_loader("ddi-loader-mk7", "ddi-transport-belt-mk7", {
	technology = "logistics-7",
	previous_tier = "ddi-loader-mk6",
	mask_tint = util.color("#c566ff"),
})

api.create_loader("ddi-loader-mk8", "ddi-transport-belt-mk8", {
	technology = "logistics-8",
	previous_tier = "ddi-loader-mk7",
	mask_tint = util.color("#ff66a6"),
})
