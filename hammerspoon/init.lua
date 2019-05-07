--
-- Grid Configuration
--
-- grid size
local grids = {}
grids.DEFAULT = {}
grids.DEFAULT.HEIGHT = 100
grids.DEFAULT.WIDTH = 100
grids.DEFAULT.PADTOP = 0
grids.DEFAULT.PADBOTTOM = 1
grids.DEFAULT.PADLEFT = 1
grids.DEFAULT.PADRIGHT = 1
grids['DELL UP2414Q'] = {}
grids['DELL UP2414Q'].PADTOP = 0
grids['DELL UP2414Q'].PADLEFT = 19
grids['DELL UP2414Q'].PADRIGHT = 1
grids['DELL U2713HM'] = {}
grids['DELL U2713HM'].PADTOP = 10
grids['DELL U2713HM'].PADBOTTOM = 10
grids['DELL U2713HM'].PADLEFT = 0
grids['DELL U2713HM'].PADRIGHT = 0
grids['S22B300'] = {}
grids['S22B300'].PADBOTTOM = 0
grids['S22B300'].PADLEFT = 0
grids['S22B300'].PADRIGHT = 0

function getGridSettings(scr)
    local settings = {}
    for key, val in pairs(grids.DEFAULT) do
        settings[key] = val
    end
    if grids[scr:name()] then
        for key, val in pairs(grids[scr:name()]) do
            settings[key] = val
        end
    end
    return settings
end

function getUsableHeight(scr)
    local settings = getGridSettings(scr)
    return (settings.HEIGHT - (settings.PADTOP + settings.PADBOTTOM))
end

function getUsableWidth(scr)
    local settings = getGridSettings(scr)
    return (settings.WIDTH - (settings.PADLEFT + settings.PADRIGHT))
end

function debugGrid(scr)
    local grid = getGridSettings(scr)
    print("===============================")
    print(string.format("NAME: %s", scr:name()))
    print(string.format("HEIGHT: %d", grid.HEIGHT))
    print(string.format("WIDTH: %d", grid.WIDTH))
    print(string.format("PADTOP: %d", grid.PADTOP))
    print(string.format("PADBOTTOM: %d", grid.PADBOTTOM))
    print(string.format("PADLEFT: %d", grid.PADLEFT))
    print(string.format("PADRIGHT: %d", grid.PADRIGHT))
    print("===============================")
end

-- previous window locations for snapback
local _prevRefs = {}

-- move window to a grid reference
function moveWindow(win, gridRef, relative, updatePrev)
    debugGrid(scr)

    local scr = win:screen()
    grid = getGridSettings(scr)
    hs.grid.setGrid(string.format('%dx%d', grid.HEIGHT, grid.WIDTH))

    curGridRef = hs.grid.get(win, scr)
    if relative then
        for key, val in pairs(curGridRef) do
            gridRef[key] = (val + (gridRef[key] or 0))
        end
    end

    if updatePrev then
        _prevRefs[win:id()] = curGridRef
    end

    hs.grid.set(win, gridRef, scr)
end
-- move the currnetly focused window
function moveCurrentWindow(gridRef, relative, updatePrev)
    moveWindow(hs.window.focusedWindow(), gridRef, relative, updatePrev)
end
-- move window back to previous position
function moveCurrentWindowToPrevious()
    local win = hs.window.focusedWindow()
    local gridRef = _prevRefs[win:id()]
    if gridRef then
        moveWindow(win, gridRef, false, true)
    end
end

--
-- Global Hotkeys
--
local mash = {"cmd", "alt", "ctrl"}
-- floating centre
hs.hotkey.bind(mash, "c", function()
    scr = hs.window.focusedWindow():screen()
    grid = getGridSettings(scr)
    local padX = 6.5
    local padY = 5
    moveCurrentWindow({
        x = (grid.PADLEFT + padX),
        y = (grid.PADTOP + padY),
        w = (getUsableWidth(scr) - (padX * 2)),
        h = (getUsableHeight(scr) - (padY * 1.5))
    }, false, true)
end)
-- maximize
hs.hotkey.bind(mash, "m", function()
    scr = hs.window.focusedWindow():screen()
    grid = getGridSettings(scr)
    moveCurrentWindow({
        x = grid.PADLEFT,
        y = grid.PADTOP,
        w = getUsableWidth(scr),
        h = getUsableHeight(scr),
    }, false, true)
end)
-- snapback
mash = {"cmd", "ctrl", "alt"}
hs.hotkey.bind(mash, "\\", moveCurrentWindowToPrevious)

--
-- Sides
--
-- top side
hs.hotkey.bind(mash, "up", function()
    scr = hs.window.focusedWindow():screen()
    grid = getGridSettings(scr)
    moveCurrentWindow({
        x = grid.PADLEFT,
        y = grid.PADTOP,
        w = getUsableWidth(scr),
        h = (getUsableHeight(scr) / 2),
    }, false, true)
end)
-- bottom side
hs.hotkey.bind(mash, "down", function()
    scr = hs.window.focusedWindow():screen()
    grid = getGridSettings(scr)
    moveCurrentWindow({
        x = grid.PADLEFT,
        y = (grid.PADTOP + (getUsableHeight(scr) / 2)),
        w = getUsableWidth(scr),
        h = (getUsableHeight(scr) / 2),
    }, false, true)
end)
-- right side
hs.hotkey.bind(mash, "right", function()
    scr = hs.window.focusedWindow():screen()
    grid = getGridSettings(scr)
    moveCurrentWindow({
        x = (grid.PADLEFT + (getUsableWidth(scr) / 2)),
        y = grid.PADTOP,
        w = (getUsableWidth(scr) / 2),
        h = getUsableHeight(scr),
    }, false, true)
end)
-- left side
hs.hotkey.bind(mash, "left", function()
    scr = hs.window.focusedWindow():screen()
    grid = getGridSettings(scr)
    moveCurrentWindow({
        x = grid.PADLEFT,
        y = grid.PADTOP,
        w = (getUsableWidth(scr) / 2),
        h = getUsableHeight(scr)
    }, false, true)
end)

--
-- Corners
--
mash = {"alt", "ctrl", "shift"}
-- top right corner
hs.hotkey.bind(mash, "up", function()
    scr = hs.window.focusedWindow():screen()
    grid = getGridSettings(scr)
    moveCurrentWindow({
        x = (grid.PADLEFT + (getUsableWidth(scr) / 2)),
        y = grid.PADTOP,
        w = (getUsableWidth(scr) / 2),
        h = (getUsableHeight(scr) / 2),
    }, false, true)
end)
-- bottom left corner
hs.hotkey.bind(mash, "down", function()
    scr = hs.window.focusedWindow():screen()
    grid = getGridSettings(scr)
    moveCurrentWindow({
        x = grid.PADLEFT,
        y = (grid.PADTOP + (getUsableHeight(scr) / 2)),
        w = (getUsableWidth(scr) / 2),
        h = (getUsableHeight(scr) / 2),
    }, false, true)
end)
-- bottom right corner
hs.hotkey.bind(mash, "right", function()
    scr = hs.window.focusedWindow():screen()
    grid = getGridSettings(scr)
    moveCurrentWindow({
        x = (grid.PADLEFT + (getUsableWidth(scr) / 2)),
        y = (grid.PADTOP + (getUsableHeight(scr) / 2)),
        w = (getUsableWidth(scr) / 2),
        h = (getUsableHeight(scr) / 2),
    }, false, true)
end)
-- top left corner
hs.hotkey.bind(mash, "left", function()
    scr = hs.window.focusedWindow():screen()
    grid = getGridSettings(scr)
    moveCurrentWindow({
        x = grid.PADLEFT,
        y = grid.PADTOP,
        w = (getUsableWidth(scr) / 2),
        h = (getUsableHeight(scr) / 2),
    }, false, true)
end)

--
-- Grow/Shrink
--
mash = {"cmd", "ctrl", "shift"}
-- grow height
hs.hotkey.bind(mash, "up", function()
    moveCurrentWindow({y = -1, h = 2}, true, false)
end)
-- shrink height
hs.hotkey.bind(mash, "down", function()
    moveCurrentWindow({y = 1, h = -2}, true, false)
end)
-- grow width
hs.hotkey.bind(mash, "right", function()
    moveCurrentWindow({x = -1, w = 2}, true, false)
end)
-- shrink width
hs.hotkey.bind(mash, "left", function()
    moveCurrentWindow({x = 1, w = -2}, true, false)
end)

--
-- Nudge
--
mash = {"cmd", "alt", "shift"}
-- nudge up
hs.hotkey.bind(mash, "up", function()
    moveCurrentWindow({y = -1}, true, false)
end)
-- nudge down
hs.hotkey.bind(mash, "down", function()
    moveCurrentWindow({y = 1}, true, false)
end)
-- nudge right
hs.hotkey.bind(mash, "right", function()
    moveCurrentWindow({x = 1}, true, false)
end)
-- nudge left
hs.hotkey.bind(mash, "left", function()
    moveCurrentWindow({x = -1}, true, false)
end)
