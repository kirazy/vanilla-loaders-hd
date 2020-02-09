--Because Angel's Industries for some god forsaken reason edits loader graphics in this file, we too must do so here to put it back.
if mods["angelsindustries"] then
	vanillaHD.patchLoaderEntity(data.raw["loader"]["loader"])
	vanillaHD.patchLoaderEntity(data.raw["loader"]["fast-loader"])
	vanillaHD.patchLoaderEntity(data.raw["loader"]["express-loader"])
end