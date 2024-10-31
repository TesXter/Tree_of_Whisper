local utils = require "core.utils"
local enums = require "data.enums"
local tracker = require "core.tracker"

local task = {
    name = "Moving to Tree of Whispers",
    shouldExecute = function()
        return utils.is_player_at_tree_of_whispers() and tracker.start_task and not utils.is_player_near_tree_of_whispers() and utils.is_bounty_quest_active()
    end,
    Execute = function()
        utility.toggle_mount()
        pathfinder.request_move(enums.TREE_OF_WHISPERS_LOCATION)
        console.print("Moving to Tree of Whispers")
    end,
}

return task
