local kaas = 0
local totalclicks = 1
local koe = 0
local boer = 0
local kaaswinkel = 0
local bonusgiven = false
local frenzyactive = false
local koecost = 50
local boercost = 200
local kaaswinkelcost = 500

display.setStatusBar(display.HiddenStatusBar)

-- Screen dimensies
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local screenW = display.actualContentWidth
local screenH = display.actualContentHeight

-- kleuren
local cheeseYellow = {1, 0.9, 0.4}
local black = {0, 0, 0}
local white = {1, 1, 1}

-- display groepen
local startScreen = display.newGroup()
local gameScreen = display.newGroup()
gameScreen.isVisible = false  -- Verstopt het game scherm bij start

-- start scherm elementen
local startBg = display.newRect(centerX, centerY, screenW, screenH)
startBg:setFillColor(0.95, 0.85, 0.6)
startScreen:insert(startBg)

local startTitle = display.newText({
    text = "KAAS\nCLICKER",
    x = centerX,
    y = centerY - 150,
    font = native.systemFontBold,
    fontSize = 70,
    align = "center"
})
startTitle:setFillColor(1, 0.6, 0)
startScreen:insert(startTitle)

local cheeseIcon = display.newText({
    text = "🧀",
    x = centerX,
    y = centerY - 20,
    fontSize = 120
})
startScreen:insert(cheeseIcon)

local playButton = display.newRoundedRect(centerX, centerY + 120, 300, 90, 15)
playButton:setFillColor(1, 0.7, 0.2)
playButton.strokeWidth = 4
playButton:setStrokeColor(0.8, 0.5, 0)
startScreen:insert(playButton)

local playText = display.newText({
    text = "SPEEL SPEL",
    x = centerX,
    y = centerY + 120,
    font = native.systemFontBold,
    fontSize = 38
})
playText:setFillColor(1, 1, 1)
startScreen:insert(playText)

-- Game UI elementen

-- Background
local bg = display.newRect(centerX, centerY, screenW, screenH)
bg:setFillColor(0.95, 0.9, 0.7)
gameScreen:insert(bg)

-- Sidebar achtergrond
local sidebarWidth = screenW * 0.35
local sidebar = display.newRect(screenW - sidebarWidth/2, centerY, sidebarWidth, screenH)
sidebar:setFillColor(0.2, 0.15, 0.1)
gameScreen:insert(sidebar)

-- Sidebar titel
local sidebarTitle = display.newText({
    text = "UPGRADES",
    x = screenW - sidebarWidth/2,
    y = 40,
    fontSize = 20,
    font = native.systemFontBold
})
sidebarTitle:setFillColor(1, 0.85, 0.4)
gameScreen:insert(sidebarTitle)

-- Title text
local titleText = display.newText({
    text = "   KAAS\nCLICKER",
    x = screenW * 0.30,
    y = 50,
    fontSize = 28,
    font = native.systemFontBold
})
titleText:setFillColor(1, 0.6, 0)
gameScreen:insert(titleText)

-- Kaas teller display
local counterBg = display.newRoundedRect(screenW * 0.3, 130, 180, 60, 12)
counterBg:setFillColor(1, 0.85, 0.3)
counterBg.strokeWidth = 3
counterBg:setStrokeColor(0.8, 0.6, 0)
gameScreen:insert(counterBg)

local numberText = display.newText({
    text = "0",
    x = screenW * 0.3,
    y = 130,
    fontSize = 32,
    font = native.systemFontBold
})
numberText:setFillColor(0.4, 0.2, 0)
gameScreen:insert(numberText)

-- Kaas foto (klikbare kaas)
kaasimage = display.newImageRect("images/kaas.png", 140, 140)
kaasimage.x = screenW * 0.3
kaasimage.y = centerY
gameScreen:insert(kaasimage)

-- Helper functie voor upgrade knoppen
local function createUpgradeButton(name, cost, yPos, costVar)
    local btnBg = display.newRoundedRect(screenW - sidebarWidth/2, yPos, sidebarWidth - 20, 70, 8)
    btnBg:setFillColor(0.35, 0.25, 0.15)
    btnBg.strokeWidth = 2
    btnBg:setStrokeColor(0.6, 0.45, 0.3)
    gameScreen:insert(btnBg)
    
    local btnText = display.newText({
        text = name .. "\n" .. cost .. " kaas",
        x = btnBg.x,
        y = btnBg.y,
        fontSize = 14,
        font = native.systemFont,
        align = "center"
    })
    btnText:setFillColor(1, 0.9, 0.6)
    gameScreen:insert(btnText)
    
    return btnBg, btnText
end

-- Upgrade buttons in sidebar
local buyKoeButton, buykoetext = createUpgradeButton("Koe 🐄", koecost, 100, koecost)
local buyBoerButton, buyboertext = createUpgradeButton("Boer 👨‍🌾", boercost, 190, boercost)
local buyKaasWinkelButton, buykaaswinkeltext = createUpgradeButton("Kaaswinkel 🏪", kaaswinkelcost, 280, kaaswinkelcost)

-- koop functies
local function koopkoe()
    if kaas >= koecost then
        koe = koe + 1
        kaas = kaas - koecost
        koecost = math.floor(koecost * 1.5)
        buykoetext.text = "Koe 🐄\n" .. koecost .. " kaas\n- Owned: " .. koe
        numberText.text = math.floor(kaas)
    end
end

   local function koopboer()
    if kaas >= boercost then
        boer = boer + 1
        kaas = kaas - boercost
        boercost = math.floor(boercost * 1.5)
        buyboertext.text = "Boer 👨‍🌾\n" .. boercost .. " kaas\n- Owned: " .. boer
        numberText.text = math.floor(kaas)
    end
end

local function koopkaaswinkel()
    if kaas >= kaaswinkelcost then
        kaaswinkel = kaaswinkel + 1
        kaas = kaas - kaaswinkelcost
        kaaswinkelcost = math.floor(kaaswinkelcost * 1.5)
        buykaaswinkeltext.text = "Kaaswinkel 🏪\n" .. kaaswinkelcost .. " kaas\n- Owned: " .. kaaswinkel
        numberText.text = math.floor(kaas)
    end
end


-- Klik op scherm = +1
local function onScreenTap()
    if kaas < math.huge then
        kaas = kaas + 1
        totalclicks = totalclicks + 1

        -- koe bonus
        if koe >= 1 then
            kaas = kaas + (1 * koe)
        end
        
        -- Frenzy bonus
        if frenzyactive then
            kaas = kaas + (4 * (1 + (0.5 * koe)))
        end
        
-- boer bonus elke 50 clicks +10 kaas per boer
        if boer >= 1 then
            if totalclicks >= 50 then
                bonusgiven = true
                if bonusgiven == true then
                    kaas = kaas + (10 * boer)
                    totalclicks = totalclicks - 49
                end
            end
        end
        
        numberText.text = math.floor(kaas)
    end
end 

-- event listeners
kaasimage:addEventListener("tap", onScreenTap)
buyKoeButton:addEventListener("tap", koopkoe)
buyBoerButton:addEventListener("tap", koopboer)
buyKaasWinkelButton:addEventListener("tap", koopkaaswinkel)

-- kaaswinkel productie functie
local function kaaswinkelProduction()
    if kaaswinkel >= 1 then
        kaas = kaas + (2 * kaaswinkel)
        numberText.text = math.floor(kaas)
    end
end

-- frenzy functie
local function startFrenzyClicker()
    frenzyactive = true
    local FrenzyNotifier = display.newText {
        text = "⚡ FRENZY! ⚡",
        x = screenW * 0.3,
        y = centerY + 120,
        fontSize = 40,
        font = native.systemFontBold
    }
    FrenzyNotifier:setFillColor(1, 0.3, 0)
    gameScreen:insert(FrenzyNotifier)
    timer.performWithDelay(5000, function() frenzyactive = false end, 1)
    timer.performWithDelay(5000, function() FrenzyNotifier:removeSelf() end, 1)
end

-- ========== START GAME TRANSITION ==========
local function startGame()
    -- Hide start screen
    startScreen.isVisible = false
    
    -- Show game screen
    gameScreen.isVisible = true
    
    -- Start timers
    timer.performWithDelay(1000, kaaswinkelProduction, 0)
    timer.performWithDelay(30000, startFrenzyClicker, 0)
end

-- Connect play button
playButton:addEventListener("tap", startGame)
