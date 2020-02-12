-- Copyright (c) 2018 Kirazy
-- Part of Vanilla Loaders HD
--     
-- See LICENSE.md in the project directory for license information.

-- Check if we're only reskinning Loader Redux.
if mods["LoaderRedux"] and settings.startup["vanillaLoaders-reskinLoaderReduxOnly"].value == true then return end

if mods["boblogistics"] then
	-- Create Bob's style loaders
	vanillaHD.createLoaderItem("purple-loader","turbo-transport-belt")
	vanillaHD.createLoaderItem("green-loader","ultimate-transport-belt")

	-- If Bob's Logistics belt overhaul is enabled, create the basic loader.
	if data.raw["transport-belt"]["basic-transport-belt"] then
		vanillaHD.createLoaderItem("basic-loader","basic-transport-belt")
	end
end