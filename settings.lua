-- Copyright (c) 2022 Kirazy
-- Part of Vanilla Loaders HD
--
-- See LICENSE.md in the project directory for license information.

data:extend(
{
	{
		-- Toggle recipe complexity; provides vanilla-style complexity absent Bob's Logistics belt overhaul
		type = "bool-setting",
		name = "vanillaLoaders-recipes-loaderOverhaul",
		setting_type = "startup",
		default_value = true
	}
})

if mods["boblogistics"] then
data:extend(
{
	{
		-- Toggle inclusion of inserters when using Bob's overhaul recipes
		type = "bool-setting",
		name = "vanillaLoaders-recipes-includeInserters",
		setting_type = "startup",
		default_value = true
	}
})
end

if mods["LoaderRedux"] then
data:extend(
{
	{
		-- Use LoaderRedux recipes
		type = "bool-setting",
		name = "vanillaLoaders-reskinLoaderReduxOnly",
		setting_type = "startup",
		default_value = false
	}
})
end