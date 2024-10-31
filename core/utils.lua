local enums = require "data.enums"
local tracker = require "core.tracker"
local utils = {}

function utils.is_player_at_tree_of_whispers()
    local zone_name = get_current_world():get_current_zone_name()
    return zone_name == enums.ZONE_TREE_OF_WHISPERS
end

function utils.is_player_near_tree_of_whispers()
    local player_position = get_player_position()
    local distance_to_tree = player_position:squared_dist_to_ignore_z(enums.TREE_OF_WHISPERS_LOCATION)
    return distance_to_tree < enums.INTERACTION_DISTANCE
end

function utils.interact_with_bounty_npc()
    for _, actor in pairs(actors_manager:get_all_actors()) do
        if actor:get_skin_name():find("Temp_Bounty_Meta_NPC") then
            pathfinder.request_move(actor:get_position())
            if actor:is_interactable() then
                interact_object(actor)
                tracker.start_task = false
                return true
            end
        end
    end
    return false
end

function utils.is_bounty_quest_active()
    for _, quest in pairs(get_quests()) do
        if quest:get_name():find(enums.QUEST_NAME) then
            return true
        end
    end
end

return utils