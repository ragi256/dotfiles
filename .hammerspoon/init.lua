local escape = 0x35
local leftCommand = 0x37
local rightCommand = 0x36
local leftShift = 0x38
local rightShift = 0x3c
local eisuu = 0x66
local kana = 0x68

local enableIME
local released = 256

local function toggleIME(enableIME)
    if enableIME then
        hs.eventtap.keyStroke({}, eisuu)
    else
        hs.eventtap.keyStroke({}, kana)
    end
    return not(enableIME)
end

local function handleEvent(e)
    local keyCode = e:getKeyCode()
    local eventData = e:getRawEventData().NSEventData.modifierFlags
    
    if keyCode == rightShift and eventData == released then
        hs.eventtap.keyStroke({}, escape)
    end
    
    if keyCode == rightCommand and eventData == released then
        enableIME = toggleIME(enableIME)
    end
end

eventtap = hs.eventtap.new({hs.eventtap.event.types.flagsChanged, hs.eventtap.event.types.keyDown, hs.eventtap.event.types.keyUp}, handleEvent)
eventtap:start()
