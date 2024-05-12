---@diagnostic disable: deprecated
-- Copyright (c) 2024 Kirazy
-- Part of Vanilla Loaders
--
-- See LICENSE.md in the project directory for license information.

---@class SetupLoaderParameters
---@field previous_tier? string # The prototype name of the previous tier of loader, used to set upgrade path of the previous_tier and default recipe. Required if no recipe already exists, optional otherwise.
---@field ingredients? data.IngredientPrototype[] # table of Types/IngredientPrototype; used preferrentially in place of previous_tier in recipes.
---@field technology? string # The prototype name of the technology that unlocks the loader.
---@field next_tier? string # For use with the upgrade planner; the prototype name of the next tier of loader.
---@field tint? data.Color # The color to use with the loader.

---Setup the loader.
---@param name string # The prototype name of the loader to be created.
---@param source_belt_name string # The prototype name of the transport belt to use.
---@param parameters? SetupLoaderParameters # An optional `SetupLoaderParameters` object defining the attributes of the loader.
local function setup_loader(name, source_belt_name, parameters)
    log("Vanilla Loaders: vanillaHD.setup_loader has been deprecated and will be removed in a future version. Use vanilla-loaders.create_loader.")
    if not parameters then parameters = {} end

    ---@type LoaderCreationParameters
    local transcribed_parameters = {
        base_tint = parameters.tint,
        mask_tint = parameters.tint or util.color("#ffffff"),
        ingredients = parameters.ingredients,
        next_tier = parameters.next_tier,
        previous_tier = parameters.previous_tier,
        technology = parameters.technology,
    }

    vanilla_loaders.create_loader(name, source_belt_name, transcribed_parameters)
end

---Adds a loader with the given `name` and `color`, using the transport belt with the given
---`belt_name`, and unlocked by the given `technology`.
---@param name string # The prototype name of the loader to be created.
---@param color data.Color # The color to use with the loader.
---@param belt_name string # The prototype name of the transport belt to use.
---@param technology? string # The prototype name of the technology that unlocks the loader.
---@param previous_tier? string # The prototype name of the previous tier of loader, used to set upgrade path of the previous_tier and default recipe. Required if no recipe already exists, optional otherwise.
---@param next_tier? string # For use with the upgrade planner; the prototype name of the next tier of loader.
local function addLoader(name, color, belt_name, technology, previous_tier, next_tier)
    log("Vanilla Loaders: vanillaHD.addLoader has been deprecated and will be removed in a future version. Use vanilla-loaders.create_loader.")

    ---@type LoaderCreationParameters
    local transcribed_parameters = {
        base_tint = color,
        mask_tint = color or util.color("#ffffff"),
        next_tier = next_tier,
        previous_tier = previous_tier,
        technology = technology,
    }

    vanilla_loaders.create_loader(name, belt_name, transcribed_parameters)
end

---@deprecated Use `vanilla_loaders`. This variable is being removed.
vanillaHD = {
    ---@deprecated Use `vanilla_loaders.create_loader`. This function is being removed.
    setup_loader = setup_loader,
    ---@deprecated Use `vanilla_loaders.create_loader`. This function is being removed.
    addLoader = addLoader,
    ---@deprecated Use `vanilla_loaders.set_loader_item_order_from_belt`. This function is being removed.
    set_item_order = vanilla_loaders.set_loader_item_order_from_belt,

    ---Raises an error with the given `string` when `is_debug_mode` is `true`.
    ---@param string string
    ---@deprecated This function is being removed.
    debug_error = function(string) end,

    ---Prints the given `string` to the log when `is_debug_mode` is `true`.
    ---@param string string
    ---@deprecated This function is being removed.
    debug_log = function(string) end,

    tint_mask = {
        -- Bob's Logistics
        ["basic-loader"] = util.color("7d7d7dd1"),
        ["loader"] = util.color("ffc340d1"),
        ["fast-loader"] = util.color("e31717d1"),
        ["express-loader"] = util.color("43c0fad1"),
        ["purple-loader"] = util.color("a510e5d1"),
        ["green-loader"] = util.color("16f263d1"),
    },
}

if mods["UltimateBelts_Owoshima_And_Pankeko-Mod"] then
    -- Pankeko Ultimate Belts
    vanillaHD.tint_mask["ub-ultra-fast-loader"] = util.color("2bc24bDB")
    vanillaHD.tint_mask["ub-extreme-fast-loader"] = util.color("c4632fDB")
    vanillaHD.tint_mask["ub-ultra-express-loader"] = util.color("6f2de0D1")
    vanillaHD.tint_mask["ub-extreme-express-loader"] = util.color("3d3af0DB")
    vanillaHD.tint_mask["ub-ultimate-loader"] = util.color("999999D1")
else
    -- Ultimate Belts
    vanillaHD.tint_mask["ub-ultra-fast-loader"] = util.color("00b30cFF")
    vanillaHD.tint_mask["ub-extreme-fast-loader"] = util.color("e00000FF")
    vanillaHD.tint_mask["ub-ultra-express-loader"] = util.color("3604b5E8")
    vanillaHD.tint_mask["ub-extreme-express-loader"] = util.color("002bffFF")
    vanillaHD.tint_mask["ub-ultimate-loader"] = util.color("00ffddD1")
end

-- Match the tint used in Bob's Logistics Belt Reskin / Bob's Logistics Basic Belt Reskin.
if mods["boblogistics-belt-reskin"] or mods["bob-basic-belt-reskin"] then
    vanillaHD.tint_mask["basic-loader"] = util.color("00000000")
end

-- Match the tint used in Bob's Logistics Belt Reskin
if mods["boblogistics-belt-reskin"] then
    vanillaHD.tint_mask["purple-loader"] = util.color("df1ee5d1")
end
