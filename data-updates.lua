-- Copyright (c) 2018 Kirazy
-- Part of Vanilla Loaders HD
--     
-- See LICENSE.md in the project directory for license information.

-- Reskin base loader entities
vanillaHD.patchLoaderEntity("loader","transport-belt")
vanillaHD.patchLoaderEntity("fast-loader","fast-transport-belt")
vanillaHD.patchLoaderEntity("express-loader","express-transport-belt")

-- Reskin base loader items
vanillaHD.patchLoaderItem("loader","transport-belt")
vanillaHD.patchLoaderItem("fast-loader","fast-transport-belt")
vanillaHD.patchLoaderItem("express-loader","express-transport-belt")

-- Check for LoaderRedux; this step is not necessary otherwise.
if mods["LoaderRedux"] then
    -- Patch loader entities
	vanillaHD.patchLoaderEntity("purple-loader","turbo-transport-belt")
    vanillaHD.patchLoaderEntity("green-loader","ultimate-transport-belt")
    
    -- Patch loader items
    vanillaHD.patchLoaderItem("purple-loader","turbo-transport-belt")
    vanillaHD.patchLoaderItem("green-loader","ultimate-transport-belt")
end