-- Copyright (c) 2018 Kirazy
-- Part of Vanilla Loaders HD
--     
-- See LICENSE.md in the project directory for license information.

-- When Bob's Logistics is present.
if mods["boblogistics"] then
	-- Check for presence of LoaderRedux, and check if we are supposed to use LoaderRedux recipes. 
	-- If true, stop here.
	if mods["LoaderRedux"] and settings.startup["vanillaLoaders-recipes-loaderReduxCompliant"].value == true then return end

	-- If both Bob's Logistics Belt Overhaul and Vanilla Loaders Overhaul are enabled
	if settings.startup["bobmods-logistics-beltoverhaul"].value == true and settings.startup["vanillaLoaders-recipes-loaderOverhaul"].value == true then	
		-- Start replacing basic materials with more complex materials depending on what is present in the game.
		
		-- Replace Iron Plate with Tin Plate in loaders
		if data.raw.item["tin-plate"] then
			bobmods.lib.recipe.replace_ingredient("loader","iron-plate","tin-plate")
		end
		
		-- Replace Electronic Circuit with Basic Circuit in loaders
		if data.raw.item["basic-circuit-board"] then
			bobmods.lib.recipe.replace_ingredient("loader","electronic-circuit","basic-circuit-board")
		end
		
		-- Replace Steel with Bronze Plate in fast loaders
		if data.raw.item["bronze-alloy"] then
			bobmods.lib.recipe.replace_ingredient("fast-loader","steel-plate","bronze-alloy")
		end
		
		-- Replace Iron Gears with Steel Gears in fast loaders
		if data.raw.item["steel-gear-wheel"] then
			bobmods.lib.recipe.replace_ingredient("fast-loader","iron-gear-wheel","steel-gear-wheel")
		end
		
		-- Replace Steel with Aluminium Plate in express loaders
		if data.raw.item["aluminium-plate"] then
			bobmods.lib.recipe.replace_ingredient("express-loader","steel-plate","aluminium-plate")
		end
		
		-- Add Cobalt Steel Bearings or Brass Bearings or Steel Bearings to express loaders.
		if data.raw.item["steel-bearing"] then
			if settings.startup["bobmods-logistics-beltrequireprevious"].value == true then
				if data.raw.item["cobalt-steel-bearing"] then
					bobmods.lib.recipe.add_ingredient("express-loader", {"cobalt-steel-bearing", 14})
				elseif data.raw.item["brass-bearing"] then
					bobmods.lib.recipe.add_ingredient("express-loader", {"brass-bearing", 14})
				else
					bobmods.lib.recipe.add_ingredient("express-loader", {"steel-bearing", 14})
				end
			else
				if data.raw.item["cobalt-steel-bearing"] then
					bobmods.lib.recipe.add_ingredient("express-loader", {"cobalt-steel-bearing", 6})
				elseif data.raw.item["brass-bearing"] then
					bobmods.lib.recipe.add_ingredient("express-loader", {"brass-bearing", 6})
				else
					bobmods.lib.recipe.add_ingredient("express-loader", {"steel-bearing", 6})
				end
			end
		end
		
		-- Replace Iron Gears with Cobalt Steel Gears in express loaders.
		if data.raw.item["cobalt-steel-gear-wheel"] then
			bobmods.lib.recipe.replace_ingredient("express-loader","iron-gear-wheel","cobalt-steel-gear-wheel")
		elseif data.raw.item["brass-gear-wheel"] then
			bobmods.lib.recipe.replace_ingredient("express-loader","iron-gear-wheel","brass-gear-wheel")
		end
		
		-- Replace Steel with Titanium Plate in purple loaders.
		if data.raw.item["titanium-plate"] then
			bobmods.lib.recipe.replace_ingredient("purple-loader","steel-plate","titanium-plate")
		end
		
		-- Add Titanium Bearings to purple loaders.
		if data.raw.item["titanium-bearing"] then
			if settings.startup["bobmods-logistics-beltrequireprevious"].value == true then
				bobmods.lib.recipe.add_ingredient("purple-loader", {"titanium-bearing", 14})
			else
				bobmods.lib.recipe.add_ingredient("purple-loader", {"titanium-bearing", 6})
			end
		end
			
		-- Replace Iron Gears with Titanium Gears in purple loaders.
		if data.raw.item["titanium-gear-wheel"] then
			bobmods.lib.recipe.replace_ingredient("purple-loader","iron-gear-wheel","titanium-gear-wheel")
		end
		
		-- Replace Steel with Nitinol Plate in green loaders.
		if data.raw.item["nitinol-alloy"] then
			bobmods.lib.recipe.replace_ingredient("green-loader","steel-plate","nitinol-alloy")
		end
		
		-- Add Nitinol Bearings to green loaders.
		if data.raw.item["nitinol-bearing"] then
			if settings.startup["bobmods-logistics-beltrequireprevious"].value == true then
				bobmods.lib.recipe.add_ingredient("green-loader", {"nitinol-bearing", 14})
			else
				bobmods.lib.recipe.add_ingredient("green-loader", {"nitinol-bearing", 6})
			end
		end
		
		-- Replace Iron Gears with Nitinol Gears in green loaders.
		if data.raw.item["nitinol-gear-wheel"] then
			bobmods.lib.recipe.replace_ingredient("green-loader","iron-gear-wheel","nitinol-gear-wheel")
		end
		
		-- Replace Processing Unit with Advaned Processing Unit in green loaders.
		if data.raw.item["advanced-processing-unit"] then
			bobmods.lib.recipe.replace_ingredient("green-loader","processing-unit","advanced-processing-unit")
		end
	end
end