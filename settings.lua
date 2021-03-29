-- Copyright (c) 2021 Kirazy
-- Part of Vanilla Loaders
--
-- See LICENSE.md in the project directory for license information.

data:extend({
    {
        type = "string-setting",
        name = "vanillaLoaders-loader-carriage-interactivity",
        setting_type = "runtime-global",
        default_value = "disabled",
        allowed_values = {"disabled", "auto-only", "all-carriages"},
        order = "a[vanillaLoaders-loader-carriage-interactivity]",
    },
    {
        type = "bool-setting",
        name = "vanillaLoaders-enable-snapping",
        setting_type = "runtime-global",
        default_value = true,
        order = "a[vanillaLoaders-enable-snapping]",
    },
	{
		type = "bool-setting",
		name = "vanillaLoaders-recipes-loaderOverhaul",
		setting_type = "startup",
		default_value = true,
        order = "b[vanillaLoaders-recipes-loaderOverhaul]",
	}
})

if mods["boblogistics"] then
    data:extend({
        {
            -- Toggle inclusion of inserters when using Bob's overhaul recipes
            type = "bool-setting",
            name = "vanillaLoaders-recipes-includeInserters",
            setting_type = "startup",
            default_value = true,
            order = "b[vanillaLoaders-recipes-includeInserters]",
        }
    })
end