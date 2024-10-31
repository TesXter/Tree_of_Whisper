local utils = require "core.utils"
local enums = require "data.enums"
local tracker = require "core.tracker"

local task = {
    name = "Teleport to Tree of Whispers",
    shouldExecute = function()
        return utils.is_bounty_quest_active() and not utils.is_player_at_tree_of_whispers() and tracker.start_task
    end,
    Execute = function()
        teleport_to_waypoint(enums.WAYPOINT_TREE_OF_WHISPERS)
    end,
}

return task
