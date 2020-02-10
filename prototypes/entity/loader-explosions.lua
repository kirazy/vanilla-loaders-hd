-- Copyright (c) 2018 Kirazy
-- Part of Vanilla Loaders HD
--     
-- See LICENSE.md in the project directory for license information.

-- Create explosions for each of the base loaders.
vanillaHD.createExplosions("loader","splitter")
vanillaHD.createExplosions("fast-loader","fast-splitter")
vanillaHD.createExplosions("express-loader","express-splitter")

if mods["boblogistics-belt-reskin"] then 
    -- If Bob's Logistics Belt Reskin is present, utilize the particles created there.
    if data.raw["transport-belt"]["basic-transport-belt"] then
        vanillaHD.createExplosions("basic-loader","basic-splitter")
    end

    if data.raw["transport-belt"]["turbo-transport-belt"] then
        vanillaHD.createExplosions("purple-loader","turbo-splitter")
    end

    if data.raw["transport-belt"]["ultimate-transport-belt"] then
        vanillaHD.createExplosions("green-loader","ultimate-splitter")
    end
else
    -- Check if the modded loaders will exist, and if so create explosions.
    if data.raw["transport-belt"]["basic-transport-belt"] then
        vanillaHD.createExplosions("basic-loader")
    end

    if data.raw["transport-belt"]["turbo-transport-belt"] then
        vanillaHD.createExplosions("purple-loader")
    end

    if data.raw["transport-belt"]["ultimate-transport-belt"] then
        vanillaHD.createExplosions("green-loader")
    end
end