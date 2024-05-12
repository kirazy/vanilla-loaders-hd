-- Copyright (c) 2024 Kirazy
-- Part of Vanilla Loaders
--
-- See LICENSE.md in the project directory for license information.

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
if items["tin-plate"] then
    recipe.replace_ingredient("loader", "iron-plate", "tin-plate")
end

if items["basic-circuit-board"] then
    recipe.replace_ingredient("loader", "electronic-circuit", "basic-circuit-board")
end

--- Adjustments for Tier 2 loaders.
if items["bronze-alloy"] then
    recipe.replace_ingredient("fast-loader", "steel-plate", "bronze-alloy")
end

if items["steel-gear-wheel"] then
    recipe.replace_ingredient("fast-loader", "iron-gear-wheel", "steel-gear-wheel")
end

--- Adjustments for Tier 3 loaders.
if items["aluminium-plate"] then
    recipe.replace_ingredient("express-loader", "steel-plate", "aluminium-plate")
end

if items["steel-bearing"] then
    local item_to_use = get_first_item_that_exists("cobalt-steel-bearing", "brass-bearing", "steel-bearing")
    recipe.add_ingredient("express-loader", { item_to_use, num_bearings })
end

if items["cobalt-steel-gear-wheel"] then
    recipe.replace_ingredient("express-loader", "iron-gear-wheel", "cobalt-steel-gear-wheel")
elseif items["brass-gear-wheel"] then
    recipe.replace_ingredient("express-loader", "iron-gear-wheel", "brass-gear-wheel")
end

--- Adjustments for Tier 4 loaders.
if items["titanium-plate"] then
    recipe.replace_ingredient("purple-loader", "steel-plate", "titanium-plate")
end

if items["titanium-bearing"] then
    recipe.add_ingredient("purple-loader", { "titanium-bearing", num_bearings })
end

if items["titanium-gear-wheel"] then
    recipe.replace_ingredient("purple-loader", "iron-gear-wheel", "titanium-gear-wheel")
end

--- Adjustments for Tier 5 loaders.
if items["nitinol-alloy"] then
    recipe.replace_ingredient("green-loader", "steel-plate", "nitinol-alloy")
end

if items["nitinol-bearing"] then
    recipe.add_ingredient("green-loader", { "nitinol-bearing", num_bearings })
end

if items["nitinol-gear-wheel"] then
    recipe.replace_ingredient("green-loader", "iron-gear-wheel", "nitinol-gear-wheel")
end

if items["advanced-processing-unit"] then
    recipe.replace_ingredient("green-loader", "processing-unit", "advanced-processing-unit")
end
