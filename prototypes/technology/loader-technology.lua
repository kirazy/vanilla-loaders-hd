-- Copyright (c) 2018 Kirazy
-- Part of Vanilla Loaders HD
--     
-- See LICENSE.md in the project directory for license information.

-- Loader Redux is present.
-- Add the basic-loader to the technology tree.
if mods["LoaderRedux"] and data.raw["loader"]["basic-loader"] then
	vanillaHD.patchLoaderTechnology("logistics-0","basic-loader") -- Black
	return
end

-- Loader Redux is not present.
-- Add the vanilla loaders to the technology tree.
vanillaHD.patchLoaderTechnology("logistics","loader") -- Yellow
vanillaHD.patchLoaderTechnology("logistics-2","fast-loader") -- Red
vanillaHD.patchLoaderTechnology("logistics-3","express-loader") -- Blue

-- When Bob's Logistics is present.
if mods["boblogistics"] then
	-- Add Bob's loaders to the technology tree.
	vanillaHD.patchLoaderTechnology("logistics-4","purple-loader") -- Purple
	vanillaHD.patchLoaderTechnology("logistics-5","green-loader") -- Green

	-- Add the Basic Loader to the tech tree
	if data.raw["loader"]["basic-loader"] then
		vanillaHD.patchLoaderTechnology("logistics-0","basic-loader") -- Black
	end
end