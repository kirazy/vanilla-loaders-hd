-- Check for Loader Redux, and if we're being compliant. If both are true, then let Loader Redux handle everything
-- and just patch the existing items with our graphics.
if mods["LoaderRedux"] and settings.startup["vanillaLoaders-recipes-loaderReduxCompliant"].value == true then

	-- Just reskin everything
	vanillaHD.patchLoaderEntity(data.raw["loader"]["loader"])
	vanillaHD.patchLoaderEntity(data.raw["loader"]["fast-loader"])
	vanillaHD.patchLoaderEntity(data.raw["loader"]["express-loader"])
	vanillaHD.patchLoaderEntity(data.raw["loader"]["purple-loader"])
	vanillaHD.patchLoaderEntity(data.raw["loader"]["green-loader"])

	-- Since Loader Redux does not have a basic loader, see if we want to make one.
	if settings.startup["vanillaLoaders-recipes-loaderReduxBasicLoader"].value == true and settings.startup["bobmods-logistics-beltoverhaul"].value == true then 
		-- Make the basic loader
		vanillaHD.createLoaderEntity("basic-loader","basic-transport-belt")
		data.raw["loader"]["basic-loader"].next_upgrade = "loader"
	end

else

	-- Vanilla Loader patching
	vanillaHD.patchLoaderEntity(data.raw["loader"]["loader"])
	vanillaHD.patchLoaderEntity(data.raw["loader"]["fast-loader"])
	vanillaHD.patchLoaderEntity(data.raw["loader"]["express-loader"])

	-- Upgrade paths
	data.raw["loader"]["loader"].next_upgrade = "fast-loader"
	data.raw["loader"]["fast-loader"].next_upgrade = "express-loader"
	data.raw["loader"]["express-loader"].next_upgrade = nil

	-- When Bob's Logistics is present.
	if mods["boblogistics"] then
		-- Create turbo/ultimate loaders when Bob's logistics is present.
		vanillaHD.createLoaderEntity("purple-loader","turbo-transport-belt")
		vanillaHD.createLoaderEntity("green-loader","ultimate-transport-belt")

		-- Upgrade paths
		data.raw["loader"]["express-loader"].next_upgrade = "purple-loader"
		data.raw["loader"]["purple-loader"].next_upgrade = "green-loader"
		data.raw["loader"]["green-loader"].next_upgrade = nil

		-- If Bob's Logistics belt overhaul is enabled, add the basic loader.
		if settings.startup["bobmods-logistics-beltoverhaul"].value == true then
			
			-- Make the basic loader
			vanillaHD.createLoaderEntity("basic-loader","basic-transport-belt")
		end
	end
end