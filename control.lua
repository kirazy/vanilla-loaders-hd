-- Copyright (c) 2017 Thaui
-- Copyright (c) 2018 Kirazy
-- Part of Vanilla Loaders HD
--
-- See LICENSE.md in the project directory for license information.

-- ########## CONTROL ##########
local util = require("__core__.lualib.util")

local function get_contents(inventory)
	local items = inventory.get_contents()

	for name, count in pairs(items) do
		if type(count) == "number" then
			local array = {}
			for name, count in pairs(items) do
				table.insert(array, {name=name,count=count})
			end
			return array -- pre-expansion, format remapped
		else
			return items -- post-expansion, format correct
		end
	end

	return {}
end

local function setup_loaders()
	global.loaders = {}

	for _, b in pairs(game.surfaces) do
		local wagon=b.find_entities_filtered{type="cargo-wagon"}
		if #wagon>0 then
			for i,w in pairs(wagon) do
				find_loader(w)
			end
		end
	end
end

--clean_loaders
function clean_loaders()
	for i,t in pairs(global.loaders) do
		if t[1].valid==false or t[2].valid==false or (t[2].train.state~=defines.train_state.wait_station and t[2].train.state~=defines.train_state.manual_control) or t[2].train.speed~=0 then
			table.remove(global.loaders,i)
			clean_loaders()
			break
		end
	end
end

--find loader
function find_loader(w,ent)
	if (w.train.state==defines.train_state.wait_station or w.train.state==defines.train_state.manual_control) and w.train.speed==0 then
		if not global.loaders then setup_loaders() end

		if w.orientation==0 or w.orientation==0.5 then
			for j,loader in pairs(w.surface.find_entities_filtered{type="loader",area={{w.position.x-1.5,w.position.y-2.2},{w.position.x-0.5,w.position.y+2.2}}}) do
				if ent and loader==ent then
					table.insert(global.loaders,{loader,w,defines.direction.west})
				elseif ent==nil then
					table.insert(global.loaders,{loader,w,defines.direction.west})
				end
			end
			for j,loader in pairs(w.surface.find_entities_filtered{type="loader",area={{w.position.x+0.5,w.position.y-2.2},{w.position.x+1.5,w.position.y+2.2}}}) do
				if ent and loader==ent then
					table.insert(global.loaders,{loader,w,defines.direction.east})
				elseif ent==nil then
					table.insert(global.loaders,{loader,w,defines.direction.east})
				end
			end
		elseif w.orientation==0.25 or w.orientation==0.75 then
			for j,loader in pairs(w.surface.find_entities_filtered{type="loader",area={{w.position.x-2.2,w.position.y-1.5},{w.position.x+2.2,w.position.y-0.5}}}) do
				if ent and loader==ent then
					table.insert(global.loaders,{loader,w,defines.direction.north})
				elseif ent==nil then
					table.insert(global.loaders,{loader,w,defines.direction.north})
				end
			end
			for j,loader in pairs(w.surface.find_entities_filtered{type="loader",area={{w.position.x-2.2,w.position.y+0.5},{w.position.x+2.2,w.position.y+1.5}}}) do
				if ent and loader==ent then
					table.insert(global.loaders,{loader,w,defines.direction.south})
				elseif ent==nil then
					table.insert(global.loaders,{loader,w,defines.direction.south})
				end
			end
		end
	end
end

--train state
local function do_train_changed_state(event)
	for i,w in pairs(event.train.carriages) do
		find_loader(w)
	end
end

--built
local function do_built_entity(event)
	local ent=event.created_entity
	if ent.type=="loader" then
		local w=ent.surface.find_entities_filtered{type="cargo-wagon",area={{ent.position.x-2,ent.position.y-2},{ent.position.x+2,ent.position.y+2}}}
		for a,b in pairs(w) do
			find_loader(b,ent)
		end
		local w=ent.surface.find_entities_filtered{type="locomotive",area={{ent.position.x-2,ent.position.y-2},{ent.position.x+2,ent.position.y+2}}}
		for a,b in pairs(w) do
			find_loader(b,ent)
		end
	elseif ent.type=="cargo-wagon" then
		find_loader(ent)
	elseif ent.type=="locomotive" then
		find_loader(ent)
	end
end

--on tick
local function do_tick(event)
	if not global.loaders then
		setup_loaders()
	elseif #global.loaders>0 then
		clean_loaders()

		--loaders work
		for i,t in pairs(global.loaders) do
			loader_work(t[1],t[2].get_inventory(defines.inventory.cargo_wagon),t[3])
		end
	end
end



function loader_active(ent,direction)
	if ent.loader_type=="output" and ent.direction==direction then
		return true
	elseif ent.loader_type=="input" and ent.direction==util.oppositedirection(direction) then
		return true
	else return false
	end
end

function loader_filter(ent)
	local filter={}
	for n=1, ent.filter_slot_count do
		if ent.get_filter(n) then
			table.insert(filter,n,ent.get_filter(n))
		end
	end
	if #filter==0 then filter=false end
	return filter
end

--loader work
function loader_work(ent,w,direction)
	if w then
		if ent.loader_type=="output" and loader_active(ent,direction) then
			if w.is_empty()==false and ent.get_transport_line(1).can_insert_at_back() then
				if loader_filter(ent) then
					local done=false
					for _,item in pairs(get_contents(w)) do
						if done then break end
						for n,filter in pairs(loader_filter(ent)) do
							if item.name==filter then
								item.count = 1
								w.remove(item)
								ent.get_transport_line(1).insert_at_back(item)
								done=true
								break
							end
						end
					end
				else
					for _,item in pairs(get_contents(w)) do
						item.count = 1
						w.remove(item)
						ent.get_transport_line(1).insert_at_back(item)
						break
					end
				end
			end
			if w.is_empty()==false and ent.get_transport_line(2).can_insert_at_back() then
				if loader_filter(ent) then
					local done=false
					for _,item in pairs(get_contents(w)) do
						if done then break end
						for n,filter in pairs(loader_filter(ent)) do
							if item.name==filter then
								item.count = 1
								w.remove(item)
								ent.get_transport_line(2).insert_at_back(item)
								done=true
								break
							end
						end
					end
				else
					for _,item in pairs(get_contents(w)) do
						item.count = 1
						w.remove(item)
						ent.get_transport_line(2).insert_at_back(item)
						break
					end
				end
			end
		elseif ent.loader_type=="input" and loader_active(ent,direction) then
			if ent.get_transport_line(1).get_item_count()>0 then
				for _, item in pairs(get_contents(ent.get_transport_line(1))) do
					item.count = 1
					if w.can_insert(item) then
						ent.get_transport_line(1).remove_item(item)
						w.insert(item)
						break
					end
				end
			end
			if ent.get_transport_line(2).get_item_count()>0 then
				for _,item in pairs(get_contents(ent.get_transport_line(2))) do
					item.count = 1
					if w.can_insert(item) then
						ent.get_transport_line(2).remove_item(item)
						w.insert(item)
						break
					end
				end
			end
		end
	end
end

-- ########## INIT ##########
local function register_loaders()
	if remote.interfaces["loader-redux"] then
		-- add loaders to the snapping whitelist
		remote.call("loader-redux", "add_loader", "basic-loader")
		remote.call("loader-redux", "add_loader", "ub-ultra-fast-loader")
		remote.call("loader-redux", "add_loader", "ub-extreme-fast-loader")
		remote.call("loader-redux", "add_loader", "ub-ultra-express-loader")
		remote.call("loader-redux", "add_loader", "ub-extreme-express-loader")
		remote.call("loader-redux", "add_loader", "ub-ultimate-loader")
	end
end

local function do_init()
	if remote.interfaces["loader-redux"] then
		-- LoaderRedux will handle control functionality
		script.on_event(defines.events.on_train_changed_state, nil)
		script.on_event(defines.events.on_built_entity, nil)
		script.on_event(defines.events.on_robot_built_entity, nil)
		script.on_event(defines.events.on_tick, nil)
	else
		-- register control functions
		script.on_event(defines.events.on_train_changed_state, do_train_changed_state)
		script.on_event(defines.events.on_built_entity, do_built_entity)
		script.on_event(defines.events.on_robot_built_entity, do_built_entity)
		script.on_event(defines.events.on_tick, do_tick)
	end
end

script.on_configuration_changed(function()
	register_loaders()
end)

script.on_load(function()
	do_init()
end)

script.on_init(function()
	do_init()
	register_loaders()
end)
