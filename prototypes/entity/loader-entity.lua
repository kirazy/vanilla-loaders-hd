-- Copyright (c) 2018 Kirazy
-- Part of Vanilla Loaders HD
--     
-- See LICENSE.md in the project directory for license information.

-- Check if we're only reskinning Loader Redux.
if mods["LoaderRedux"] and settings.startup["vanillaLoaders-reskinLoaderReduxOnly"].value == true then return end

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