local count = 0

-- Tekst die het nummer laat zien
local numberText = display.newText({
    text = "Number: 0",
    x = display.contentCenterX,
    y = display.contentCenterY - 50,
    fontSize = 40
})

-- Maximum bereikt tekst (verborgen)
local maxText = display.newText({
    text = "Maximum bereikt",
    x = display.contentCenterX,
    y = display.contentCenterY + 50,
    fontSize = 35
})
maxText.isVisible = false

-- Reset knop (verborgen)
local resetButton = display.newRect(display.contentCenterX, display.contentCenterY + 120, 200, 60)
resetButton:setFillColor(0.2, 0.6, 1)
resetButton.isVisible = false

local resetText = display.newText({
    text = "RESET",
    x = resetButton.x,
    y = resetButton.y,
    fontSize = 30
})
resetText.isVisible = false

-- Reset functie
local function resetCounter()
    count = -1
    numberText.text = "Number: 1"
    maxText.isVisible = false
    resetButton.isVisible = false
    resetText.isVisible = false
end

resetButton:addEventListener("tap", resetCounter)

-- Klik op scherm → +1
local function onScreenTap()
    if count < 10 then
        count = count + 1
        numberText.text = "Number: " .. count
    end

    -- Als maximum bereikt is
    if count == 10 then
        maxText.isVisible = true
        resetButton.isVisible = true
        resetText.isVisible = true
    end
end

Runtime:addEventListener("tap", onScreenTap)