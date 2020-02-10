-- Copyright (c) 2017 Thaui
-- Part of Vanilla Loaders HD
--     
-- See LICENSE.md in the project directory for license information.

local function reloadTechnology(technology, recipe)
	for k,force in pairs(game.forces) do
		if force.technologies[technology] then
			force.recipes[recipe].enabled = force.technologies[technology].researched
		end
	end
end
reloadTechnology("logistics","loader")
reloadTechnology("logistics-2","fast-loader")
reloadTechnology("logistics-3","express-loader")
reloadTechnology("bob-logistics-4","purple-loader")
reloadTechnology("bob-logistics-5","green-loader")