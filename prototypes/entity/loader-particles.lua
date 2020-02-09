if mods["boblogistics-belt-reskin"] then 
    -- If Bob's Logistics Belt Reskin is present, utilize the particles created there.
    return

else
    -- Check if the modded loaders will exist, and if so create particles.
    if data.raw["transport-belt"]["basic-transport-belt"] then
        vanillaHD.createParticles("basic-loader")
    end

    if data.raw["transport-belt"]["turbo-transport-belt"] then
        vanillaHD.createParticles("purple-loader")
    end

    if data.raw["transport-belt"]["ultimate-transport-belt"] then
        vanillaHD.createParticles("green-loader")
    end
end