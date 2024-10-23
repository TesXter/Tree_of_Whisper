local gui = require("gui")

-- Get the local player
local local_player = get_local_player()
if local_player == nil then
    return
end

local waypoint_tree_of_whispers = 0x90557

-- Global variables
local enabled = false
local tree_of_whispers_waypoint_location = vec3:new(-1330.0712890625, 780.5947265625, 1.4736328125)
local moving_to_tree_of_whispers = false
local wait_start_time = 0
local pending_action = nil

-- Function to create a delayed action
local function wait_and_execute(action, delay)
    wait_start_time = get_time_since_inject()
    return function()
        if get_time_since_inject() - wait_start_time >= delay then
            action()
            return true
        end
        return false
    end
end

-- Function to interact with the Bounty NPC
local function interact_with_bounty_npc()
    local actors = actors_manager:get_all_actors()
    for _, actor in pairs(actors) do
        local name = actor:get_skin_name()
        if name:find("Temp_Bounty_Meta_NPC") then        
            pathfinder.request_move(actor:get_position())
            interact_object(actor)
        end
    end
end

-- Function to check if a Bounty quest is active
local function check_quest_status()
    local quests = get_quests()
    for _, quest in pairs(quests) do
        if quest:get_name():find("Bounty_Meta_Quest") then
            return true
        end
    end
    return false
end

-- Update function
on_update(function()
    enabled = gui.elements.main_toggle:get()

    if enabled then
        if pending_action then
            if pending_action() then
                pending_action = nil
            end
        elseif moving_to_tree_of_whispers then
            -- Check if player is already at the Tree of Whispers
            local player_position = local_player:get_position()
            if player_position:squared_dist_to_ignore_z(tree_of_whispers_waypoint_location) < 5 then
                moving_to_tree_of_whispers = false
                interact_with_bounty_npc()
                console.print("Arrived at Tree of Whispers")
            else
                pathfinder.request_move(tree_of_whispers_waypoint_location)
                console.print("Moving to Tree of Whispers")
            end
        end
    end
end)

-- Key release event handler
on_key_release(function(key)
    if enabled then
        if key == gui.elements.keybind:get_key() then
            if check_quest_status() then    
                teleport_to_waypoint(waypoint_tree_of_whispers)
                pending_action = wait_and_execute(function()
                    moving_to_tree_of_whispers = true
                end, 5)
            end
        end
    end
end)

-- Render menu
on_render_menu(gui.render)
