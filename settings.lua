-- Copyright (c) 2018-2026 Kirazy
-- Part of Vanilla Loaders
--
-- See LICENSE.md in the project directory for license information.

data:extend({
    {
        -- Toggle recipe complexity; provides vanilla-style complexity absent Bob's Logistics belt overhaul
        type = "bool-setting",
        name = "vanillaLoaders-recipes-loaderOverhaul",
        setting_type = "startup",
        default_value = true,
    },
    {
        type = "bool-setting",
        name = "vanillaLoaders-do-loader-snapping",
        setting_type = "runtime-global",
        default_value = true,
    },
})

if mods["boblogistics"] then
    data:extend({
        {
            -- Toggle inclusion of inserters when using Bob's overhaul recipes
            type = "bool-setting",
            name = "vanillaLoaders-recipes-includeInserters",
            setting_type = "startup",
            default_value = true,
        },
    })
end
