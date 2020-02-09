local modDir = "__vanilla-loaders-hd__"

-- This function creates corpses
-- THIS FUNCTION IS CURRENTLY DEEPLY WIP.
function vanillaHD.createRemnants(name)
    local remnant = table.deepcopy(data.raw["corpse"]["underground-belt-remnants"])
    remnant.name = name.."-remnants"
    remnant.icons  = 
	{
		{
			icon = modDir.."/graphics/icons/loader-icon-base.png"
		},
		{
			icon = modDir.."/graphics/icons/loader-icon-mask.png",
			tint = vanillaHD.tint_mask[name]
		}
	}
	remnant.animation.filename = modDir.."/graphics/entity/loader/remnants/underground-belt-remnants.png"
	remnant.animation.hr_version = 
	{
		filename        = modDir.."/graphics/entity/loader/remnants/hr-loader-remnants-base.png",
		width           = 212,
        height          = 192,
        frame_count     = 1,
        variation_count = 1,
        axially_symmetrical = false,
        direction_count = 8,
        shift           = util.by_pixel(0,0),
        scale           = 0.5
	}

    data:extend({remnant})
end

-- Create remnants for each of the base loaders.
vanillaHD.createRemnants("loader")
vanillaHD.createRemnants("fast-loader")
vanillaHD.createRemnants("express-loader")

-- Check if the modded loaders will exist, and if so create remnants.
if data.raw["transport-belt"]["basic-transport-belt"] then
    vanillaHD.createRemnants("basic-loader")
end

if data.raw["transport-belt"]["turbo-transport-belt"] then
    vanillaHD.createRemnants("purple-loader")
end

if data.raw["transport-belt"]["ultimate-transport-belt"] then
    vanillaHD.createRemnants("green-loader")
end