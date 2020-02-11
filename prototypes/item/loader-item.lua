-- Copyright (c) 2018 Kirazy
-- Part of Vanilla Loaders HD
--     
-- See LICENSE.md in the project directory for license information.

-- Check for Loader Redux, and if we're being compliant. If both are true, then let Loader Redux handle everything
-- and check if we need to make a basic loader.
if mods["LoaderRedux"] and settings.startup["vanillaLoaders-recipes-loaderReduxCompliant"].value == true then
	-- Since Loader Redux does not have a basic loader, see if we want to make one.
	if data.raw["transport-belt"]["basic-transport-belt"] and settings.startup["vanillaLoaders-recipes-loaderReduxBasicLoader"].value == true then
		-- Make the basic loader
		vanillaHD.createLoaderItem("basic-loader","basic-transport-belt")
	end
else
	-- When Bob's Logistics is present.
	if mods["boblogistics"] then

		-- Create Bob's style loaders
		vanillaHD.createLoaderItem("purple-loader","turbo-transport-belt")
		vanillaHD.createLoaderItem("green-loader","ultimate-transport-belt")

		-- If Bob's Logistics belt overhaul is enabled, create the basic loader.
		if data.raw["transport-belt"]["basic-transport-belt"] then
			vanillaHD.createLoaderItem("basic-loader","basic-transport-belt")
		end
	end
end