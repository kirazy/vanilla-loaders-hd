-- Copyright (c) 2018 Kirazy
-- Part of Vanilla Loaders HD
--     
-- See LICENSE.md in the project directory for license information.

if mods["LoaderRedux"] then
	-- When Bob's Logistics is present, create the basic loader research.
	if mods["boblogistics"] and data.raw["loader"]["basic-loader"] then
		vanillaHD.patchLoaderTechnology("logistics-0","basic-loader") -- Black
	end
	-- Loader Redux will handle technology creation, except for a basic loader which Loader Redux does not support.
	return
end

-- Loader Redux is not present, and so the following will execute and create the appropriate technologies.
-- Add the vanilla loaders to the technology tree.
vanillaHD.patchLoaderTechnology("logistics"      ,"loader"        		) -- Yellow
vanillaHD.patchLoaderTechnology("logistics-2"    ,"fast-loader"   		) -- Red
vanillaHD.patchLoaderTechnology("logistics-3"    ,"express-loader"		) -- Blue

-- When Bob's Logistics is present.
if mods["boblogistics"] then
	-- Add Bob's loaders to the technology tree.
	vanillaHD.patchLoaderTechnology("logistics-4","purple-loader"	) -- Purple
	vanillaHD.patchLoaderTechnology("logistics-5","green-loader" 	) -- Green

	-- Add the Basic Loader to the tech tree
	if data.raw["loader"]["basic-loader"] then
		vanillaHD.patchLoaderTechnology("logistics-0","basic-loader") -- Black
	end
end