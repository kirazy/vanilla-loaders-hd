-- Copyright (c) 2021 Kirazy
-- Part of Vanilla Loaders
--
-- See LICENSE.md in the project directory for license information.

-- Bob's Logistics sets belt ordering in data-updates; fix the loaders
if mods["boblogistics"] then
    vanillaHD.set_item_order("loader","transport-belt")
    vanillaHD.set_item_order("fast-loader","fast-transport-belt")
    vanillaHD.set_item_order("express-loader","express-transport-belt")
end