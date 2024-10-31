local utils = require "core.utils"
local tracker = require "core.tracker"
local task = {
    name = "Interact with Tree of Whispers",
    shouldExecute = function()
        return utils.is_player_near_tree_of_whispers() and tracker.start_task and utils.is_player_at_tree_of_whispers() and utils.is_bounty_quest_active()
    end,
    Execute = function()
        console.print("Interacting with Tree of Whispers")
        utils.interact_with_bounty_npc()
    end,
}

return task
