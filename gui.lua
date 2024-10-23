local gui = {}
local developer_id = "TesXter"

local function create_checkbox(key)
    return checkbox:new(false, get_hash(developer_id .. "_" .. key))
end

gui.elements = {
    main_tree = tree_node:new(0),
    main_toggle = create_checkbox("main_toggle"),

    keybind = keybind:new(0x21, false, get_hash(developer_id .. "_keybind_tree")),
}

function gui.render()
    if not gui.elements.main_tree:push("Tree of Whispers 0.1") then return end

    gui.elements.main_toggle:render("Enable", "Enable Hotkeys")
    if not gui.elements.main_toggle:get() then
        gui.elements.main_tree:pop()
        return
    end

    gui.elements.keybind:render("TP to Tree of Whispers", "")

    gui.elements.main_tree:pop()
end

return gui
