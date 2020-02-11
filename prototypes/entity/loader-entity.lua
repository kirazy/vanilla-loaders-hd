-- Copyright (c) 2018 Kirazy
-- Part of Vanilla Loaders HD
--     
-- See LICENSE.md in the project directory for license information.

-- Check for Loader Redux, and if we're being compliant. If both are true, then check if we need a basic-loader.
if mods["LoaderRedux"] and settings.startup["vanillaLoaders-recipes-loaderReduxCompliant"].value == true then
	-- Since Loader Redux does not have a basic loader, see if we want to make one.
	if settings.startup["vanillaLoaders-recipes-loaderReduxBasicLoader"].value == true and settings.startup["bobmods-logistics-beltoverhaul"].value == true then 
		-- Make the basic loader
		vanillaHD.createLoaderEntity("basic-loader","basic-transport-belt")

		-- Set upgrade path
		data.raw["loader"]["basic-loader"].next_upgrade = "loader"
	end
else
	-- Set upgrade paths
	data.raw["loader"]["loader"].next_upgrade = "fast-loader"
	data.raw["loader"]["fast-loader"].next_upgrade = "express-loader"
	data.raw["loader"]["express-loader"].next_upgrade = nil

	-- When Bob's Logistics is present.
	if mods["boblogistics"] then
		-- Create turbo/ultimate loaders when Bob's logistics is present.
		vanillaHD.createLoaderEntity("purple-loader","turbo-transport-belt")
		vanillaHD.createLoaderEntity("green-loader","ultimate-transport-belt")

		-- Set upgrade paths
		data.raw["loader"]["express-loader"].next_upgrade = "purple-loader"
		data.raw["loader"]["purple-loader"].next_upgrade = "green-loader"
		data.raw["loader"]["green-loader"].next_upgrade = nil

		-- If Bob's Logistics belt overhaul is enabled, add the basic loader.
		if settings.startup["bobmods-logistics-beltoverhaul"].value == true then
			
			-- Make the basic loader
			vanillaHD.createLoaderEntity("basic-loader","basic-transport-belt")
			
			-- Set upgrade path
			data.raw["loader"]["basic-loader"].next_upgrade = "loader"
		end
	end
end