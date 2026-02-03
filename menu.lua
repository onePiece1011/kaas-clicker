display.setStatusBar(display.HiddenStatusBar)

-- Telefoon staand formaat
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local screenW = display.actualContentWidth
local screenH = display.actualContentHeight

-- Kleuren
local cheeseYellow = {1, 0.9, 0.4}
local black = {0, 0, 0}
local white = {1, 1, 1}

-- Achtergrond
local bg = display.newImageRect("background.png", screenW, screenH)
bg.x = centerX
bg.y = centerY

-- Titel
local title = display.newText({
    text = "Cheese Clicker",
    x = centerX,
    y = 150,
    font = native.systemFontBold,
    fontSize = 70
})
title:setFillColor(1, 1, 1)

-- Functie om knoppen te maken
local function createButton(text, yPos)
    local buttonGroup = display.newGroup()

    local rect = display.newRoundedRect(buttonGroup, centerX, yPos, 500, 120, 30)
    rect:setFillColor(unpack(cheeseYellow))

    local label = display.newText({
        parent = buttonGroup,
        text = text,
        x = centerX,
        y = yPos,
        font = native.systemFontBold,
        fontSize = 40
    })
    label:setFillColor(0, 0, 0)

    return buttonGroup
end

-- Knoppen
local btnStart = createButton("Start Game", 450)
local btnFast = createButton("Fast Click Version", 600)
local btnResume = createButton("Resume Game", 750)
local btnCredits = createButton("Credits", 900)
