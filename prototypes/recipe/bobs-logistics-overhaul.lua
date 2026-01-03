-- Copyright (c) Kirazy
-- Part of Vanilla Loaders
--
-- See LICENSE.md in the project directory for license information.

-- cspell: words aluminium nitinol beltoverhaul beltrequireprevious

if not mods["boblogistics"] then return end
if settings.startup["vanillaLoaders-recipes-loaderOverhaul"].value ~= true then return end
if settings.startup["bobmods-logistics-beltoverhaul"].value ~= true then return end

--- This module replaces more conventional ingredients with more advanced and varied materials
--- available in Bob's mods, consistent with the changes made by Bob Mod's belt overhaul.

local recipe = bobmods.lib.recipe
local items = data.raw.item

local num_bearings = settings.startup["bobmods-logistics-beltrequireprevious"].value and 14 or 6

---Gets the name of the first item found in `data.raw.items` from among the given list of names.
---@param ... string # An ordered list of item names to check.
---@return string|nil # The name of the first item found, or `nil`.
local function get_first_item_that_exists(...)
    for _, name in pairs({ ... }) do
        if items[name] then return name end
    end
end

--- Adjustments for Tier 1 loaders.
if items["bob-tin-plate"] then
    recipe.replace_ingredient("loader", "iron-plate", "bob-tin-plate")
end

if items["bob-basic-circuit-board"] then
    recipe.replace_ingredient("loader", "electronic-circuit", "bob-basic-circuit-board")
end

--- Adjustments for Tier 2 loaders.
if items["bob-bronze-alloy"] then
    recipe.replace_ingredient("fast-loader", "steel-plate", "bob-bronze-alloy")
end

if items["bob-steel-gear-wheel"] then
    recipe.replace_ingredient("fast-loader", "iron-gear-wheel", "bob-steel-gear-wheel")
end

--- Adjustments for Tier 3 loaders.
if items["bob-aluminium-plate"] then
    recipe.replace_ingredient("express-loader", "steel-plate", "bob-aluminium-plate")
end

if items["bob-steel-bearing"] then
    local item_to_use = get_first_item_that_exists("bob-cobalt-steel-bearing", "bob-brass-bearing", "bob-steel-bearing")
    recipe.add_ingredient("express-loader", { item_to_use, num_bearings })
end

if items["bob-cobalt-steel-gear-wheel"] then
    recipe.replace_ingredient("express-loader", "iron-gear-wheel", "bob-cobalt-steel-gear-wheel")
elseif items["bob-brass-gear-wheel"] then
    recipe.replace_ingredient("express-loader", "iron-gear-wheel", "bob-brass-gear-wheel")
end

--- Adjustments for Tier 4 loaders.
if items["bob-titanium-plate"] then
    recipe.replace_ingredient("bob-turbo-loader", "steel-plate", "bob-titanium-plate")
end

if items["bob-titanium-bearing"] then
    recipe.add_ingredient("bob-turbo-loader", { "bob-titanium-bearing", num_bearings })
end

if items["bob-titanium-gear-wheel"] then
    recipe.replace_ingredient("bob-turbo-loader", "iron-gear-wheel", "bob-titanium-gear-wheel")
end

--- Adjustments for Tier 5 loaders.
if items["bob-nitinol-alloy"] then
    recipe.replace_ingredient("bob-ultimate-loader", "steel-plate", "bob-nitinol-alloy")
end

if items["bob-nitinol-bearing"] then
    recipe.add_ingredient("bob-ultimate-loader", { "bob-nitinol-bearing", num_bearings })
end

if items["bob-nitinol-gear-wheel"] then
    recipe.replace_ingredient("bob-ultimate-loader", "iron-gear-wheel", "bob-nitinol-gear-wheel")
end

if items["bob-advanced-processing-unit"] then
    recipe.replace_ingredient("bob-ultimate-loader", "processing-unit", "bob-advanced-processing-unit")
end
