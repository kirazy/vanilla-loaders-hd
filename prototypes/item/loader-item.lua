-- Check for Loader Redux, and if we're being compliant. If both are true, then let Loader Redux handle everything
-- and just patch the existing items with our graphics.
if mods["LoaderRedux"] and settings.startup["vanillaLoaders-recipes-loaderReduxCompliant"].value == true then

	if mods["boblogistics"] then
		-- Just reskin everything
		vanillaHD.patchLoaderItem(data.raw["item"]["loader"],"transport-belt","bob-logistic-tier-1")
		vanillaHD.patchLoaderItem(data.raw["item"]["fast-loader"],"fast-transport-belt","bob-logistic-tier-2")
		vanillaHD.patchLoaderItem(data.raw["item"]["express-loader"],"express-transport-belt","bob-logistic-tier-3")
		vanillaHD.patchLoaderItem(data.raw["item"]["purple-loader"],"turbo-transport-belt","bob-logistic-tier-4")
		vanillaHD.patchLoaderItem(data.raw["item"]["green-loader"],"ultimate-transport-belt","bob-logistic-tier-5")

		-- Since Loader Redux does not have a basic loader, see if we want to make one.
		if settings.startup["vanillaLoaders-recipes-loaderReduxBasicLoader"].value == true and settings.startup["bobmods-logistics-beltoverhaul"].value == true then 
			-- Make the basic loader
			vanillaHD.createLoaderItem("basic-loader","basic-transport-belt")
		end
	else
		-- Just reskin everything
		vanillaHD.patchLoaderItem(data.raw["item"]["loader"],"transport-belt")
		vanillaHD.patchLoaderItem(data.raw["item"]["fast-loader"],"fast-transport-belt")
		vanillaHD.patchLoaderItem(data.raw["item"]["express-loader"],"express-transport-belt")
		vanillaHD.patchLoaderItem(data.raw["item"]["purple-loader"],"turbo-transport-belt")
		vanillaHD.patchLoaderItem(data.raw["item"]["green-loader"],"ultimate-transport-belt")
	end

else

	-- When Bob's Logistics is present.
	if mods["boblogistics"] then

		-- Patch the vanilla loaders, sort with Bob's transport subgroups
		vanillaHD.patchLoaderItem(data.raw["item"]["loader"],"transport-belt","bob-logistic-tier-1")
		vanillaHD.patchLoaderItem(data.raw["item"]["fast-loader"],"fast-transport-belt","bob-logistic-tier-2")
		vanillaHD.patchLoaderItem(data.raw["item"]["express-loader"],"express-transport-belt","bob-logistic-tier-3")
		
		-- Create the Bob's style loaders
		vanillaHD.createLoaderItem("purple-loader","turbo-transport-belt")
		vanillaHD.createLoaderItem("green-loader","ultimate-transport-belt")

		-- If Bob's Logistics belt overhaul is enabled, create the basic loader.
		if settings.startup["bobmods-logistics-beltoverhaul"].value == true then
			vanillaHD.createLoaderItem("basic-loader","basic-transport-belt")
		end
		
	-- When Bob's Logistics is not present.
	else
		-- Patch the vanilla loaders
		vanillaHD.patchLoaderItem(data.raw["item"]["loader"],"transport-belt")
		vanillaHD.patchLoaderItem(data.raw["item"]["fast-loader"],"fast-transport-belt")
		vanillaHD.patchLoaderItem(data.raw["item"]["express-loader"],"express-transport-belt")
	end
end