--[[ DEPRECATED PENDING REINTRODUCTION OF DEADLOCK BELT GRAPHICS
-- If Deadlock's Compact Loader mod is present, and we're using Deadlock styles, we need to patch the loaders with the updated belt graphics
if settings.startup["deadlock-loaders-belt-style"] then
    if settings.startup["deadlock-loaders-belt-style"].value == true then

        -- Patch the vanilla loaders
        vanillaHD.patchBeltGraphics("loader","transport-belt")
        vanillaHD.patchBeltGraphics("fast-loader","fast-transport-belt")
        vanillaHD.patchBeltGraphics("express-loader","express-transport-belt")

        -- Patch the loaders for Bob's mods
        if data.raw["loader"]["basic-loader"] then
            vanillaHD.patchBeltGraphics("basic-loader","basic-transport-belt")
        end

        if data.raw["loader"]["purple-loader"] then
            vanillaHD.patchBeltGraphics("purple-loader","turbo-transport-belt")
        end
        
        if data.raw["loader"]["green-loader"] then
            vanillaHD.patchBeltGraphics("green-loader","ultimate-transport-belt")
        end
    end
end]]