-- Copyright (c) 2024 Kirazy
-- Part of Vanilla Loaders
--
-- See LICENSE.md in the project directory for license information.

---@type VanillaLoadersApi
local api = require("prototypes.api")

-- Bob's Logistics sets belt ordering in data-updates; fix the loaders
if mods["boblogistics"] then
    api.set_loader_item_order_from_belt("loader", "transport-belt")
    api.set_loader_item_order_from_belt("fast-loader", "fast-transport-belt")
    api.set_loader_item_order_from_belt("express-loader", "express-transport-belt")
end
