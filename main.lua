local gui = require("gui")

-- Constants
local WAYPOINT_TREE_OF_WHISPERS = 0x90557
local TREE_OF_WHISPERS_LOCATION = vec3:new(-1330.0712890625, 780.5947265625, 1.4736328125)
local INTERACTION_DISTANCE = 2

-- State variables
local enabled = false
local moving_to_tree_of_whispers = false
local teleporting_to_tree_of_whispers = false

-- Get the local player
local local_player = get_local_player()
if not local_player then
    return
end

-- Add these new variables
local cached_bounty_quest_active = false
local last_quest_check_time = 0
local QUEST_CHECK_INTERVAL = 5  -- Check every 5 seconds

-- Function to find and interact with the Bounty NPC
local function interact_with_bounty_npc()
    for _, actor in pairs(actors_manager:get_all_actors()) do
        if actor:get_skin_name():find("Temp_Bounty_Meta_NPC") then
            pathfinder.request_move(actor:get_position())
            interact_object(actor)
            return true
        end
    end
    return false
end

-- Modify the is_bounty_quest_active function
local function is_bounty_quest_active()
    local current_time = os.time()
    if current_time - last_quest_check_time >= QUEST_CHECK_INTERVAL then
        last_quest_check_time = current_time
        for _, quest in pairs(get_quests()) do
            if quest:get_name():find("Bounty_Meta_Quest") then
                cached_bounty_quest_active = true
                return true
            end
        end
        cached_bounty_quest_active = false
    end
    return cached_bounty_quest_active
end

-- Function to handle movement to Tree of Whispers
local function handle_tree_of_whispers_movement()
    local player_position = local_player:get_position()
    local distance_to_tree = player_position:squared_dist_to_ignore_z(TREE_OF_WHISPERS_LOCATION)

    if distance_to_tree < INTERACTION_DISTANCE then
        moving_to_tree_of_whispers = false
        if interact_with_bounty_npc() then
            console.print("Interacting with Tree of Whispers")
        else
            console.print("Tree of Whispers not found")
        end
    else
        pathfinder.request_move(TREE_OF_WHISPERS_LOCATION)
        -- console.print("Moving to Tree of Whispers")
    end
end

-- Update function
on_update(function()
    enabled = gui.elements.main_toggle:get()
    if not enabled then return end

    if is_bounty_quest_active() then
        if moving_to_tree_of_whispers then
            handle_tree_of_whispers_movement()
        elseif world.get_current_world():get_current_zone_name() == "Hawe_Bog" then
            local distance_to_tree = local_player:get_position():squared_dist_to_ignore_z(TREE_OF_WHISPERS_LOCATION)
            if distance_to_tree > INTERACTION_DISTANCE and not moving_to_tree_of_whispers then
                console.print("Starting movement to Tree of Whispers")
                moving_to_tree_of_whispers = true
            end
        elseif teleporting_to_tree_of_whispers then
            teleport_to_waypoint(WAYPOINT_TREE_OF_WHISPERS)
            teleporting_to_tree_of_whispers = false
            console.print("Teleported to Tree of Whispers")
        end
    end
end)

-- Add this new function to reset the cache when needed
local function reset_bounty_quest_cache()
    cached_bounty_quest_active = false
    last_quest_check_time = 0
end

-- Key release event handler
on_key_release(function(key)
    if enabled and key == gui.elements.keybind:get_key() then
        reset_bounty_quest_cache()  -- Reset cache before checking
        if is_bounty_quest_active() then
            console.print("Teleporting to Tree of Whispers")
            teleporting_to_tree_of_whispers = true
        else
            console.print("No active Bounty quest")
        end
    end
end)

-- Render menu
on_render_menu(gui.render)
