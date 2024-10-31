local gui = require "gui"

local settings = {
    enabled = false,
    keybind = 0x31,
}

function settings:update_settings()
    settings.enabled = gui.elements.main_toggle:get()
    settings.keybind = gui.elements.keybind:get_key()
end

return settings