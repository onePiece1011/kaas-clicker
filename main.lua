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
-- JSON bibliotheek voor opslaan/laden
local json = require("json")
-- Screen dimensies
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local screenW = display.actualContentWidth
local screenH = display.actualContentHeight

-- kleuren
local cheeseYellow = {1, 0.9, 0.4}
local black = {0, 0, 0}
local white = {1, 1, 1}

-- Voor save files
local json = require("json")

-- Functie om game data op te slaan
local function saveGame()
    local path = system.pathForFile("Cheese_data.json", system.DocumentsDirectory)
    local file = io.open(path, "w")
    
    if file then
        local gameData = {
            kaas = kaas,
            totalclicks = totalclicks,
            koe = koe,
            boer = boer,
            kaaswinkel = kaaswinkel,
            koecost = koecost,
            boercost = boercost,
            kaaswinkelcost = kaaswinkelcost
        }
        
        file:write(json.encode(gameData))
        io.close(file)
        print("Game opgeslagen!")
    end
end

-- Functie om game data te laden
local function loadGame()
    local path = system.pathForFile("Cheese_data.json", system.DocumentsDirectory)
    local file = io.open(path, "r")
    
    if file then
        local contents = file:read("*a")
        io.close(file)
        
        local gameData = json.decode(contents)
        
        if gameData then
            kaas = gameData.kaas or 0
            totalclicks = gameData.totalclicks or 1
            koe = gameData.koe or 0
            boer = gameData.boer or 0
            kaaswinkel = gameData.kaaswinkel or 0
            koecost = gameData.koecost or 50
            boercost = gameData.boercost or 200
            kaaswinkelcost = gameData.kaaswinkelcost or 500
            
            print("Game geladen!")
            return true
        end
    end
    return false
end

-- Functie om te checken of er een save bestand bestaat
local function hasSaveFile()
    local path = system.pathForFile("Cheese_data.json", system.DocumentsDirectory)
    local file = io.open(path, "r")
    if file then
        io.close(file)
        return true
    end
    return false
end

-- display groepen
local startScreen = display.newGroup()
local creditsScreen = display.newGroup()
local gameScreen = display.newGroup()
local ChallengeModeScreen = display.newGroup()
gameScreen.isVisible = false  -- Verstopt het game scherm bij start
creditsScreen.isVisible = false  -- Verstopt credits scherm bij start

-- start scherm elementen
local startBg = display.newRect(centerX, centerY, screenW, screenH)
startBg:setFillColor(0.95, 0.85, 0.6)
startScreen:insert(startBg)

local startTitle = display.newText({
    text = "KAAS\nCLICKER",
    x = centerX,
    y = centerY - 280,
    font = native.systemFontBold,
    fontSize = 50,
    align = "center"
})
startTitle:setFillColor(1, 0.6, 0)
startScreen:insert(startTitle)

local cheeseIcon = display.newText({
    text = "🧀",
    x = centerX,
    y = centerY - 170,
    fontSize = 0
})
startScreen:insert(cheeseIcon)

local playButton = display.newRoundedRect(centerX, centerY - 20, 250, 70, 12)
playButton:setFillColor(1, 0.7, 0.2)
playButton.strokeWidth = 3
playButton:setStrokeColor(0.8, 0.5, 0)
startScreen:insert(playButton)

local playText = display.newText({
    text = "SPEEL SPEL",
    x = centerX,
    y = centerY - 20,
    font = native.systemFontBold,
    fontSize = 30
})
playText:setFillColor(1, 1, 1)
startScreen:insert(playText)

-- Resume knop (alleen zichtbaar als er een save bestand is)
local resumeButton = display.newRoundedRect(centerX, centerY + 65, 250, 70, 12)
resumeButton:setFillColor(0.4, 0.6, 0.8)
resumeButton.strokeWidth = 3
resumeButton:setStrokeColor(0.3, 0.4, 0.6)
startScreen:insert(resumeButton)

local resumeText = display.newText({
    text = "HERVAT SPEL",
    x = centerX,
    y = centerY + 65,
    font = native.systemFontBold,
    fontSize = 30
})
resumeText:setFillColor(1, 1, 1)
startScreen:insert(resumeText)

-- Verberg resume knop als er geen save is
if not hasSaveFile() then
    resumeButton.isVisible = false
    resumeText.isVisible = false
end

-- Challenge Mode knop
local challengeButton = display.newRoundedRect(centerX, centerY + 150, 250, 70, 12)
challengeButton:setFillColor(0.6, 0.2, 0.8)
challengeButton.strokeWidth = 3
challengeButton:setStrokeColor(0.5, 0.1, 0.6)
startScreen:insert(challengeButton)

local challengeText = display.newText({
    text = "CHALLENGE MODE",
    x = centerX,
    y = centerY + 150,
    font = native.systemFontBold,
    fontSize = 25
})
challengeText:setFillColor(1, 1, 1)
startScreen:insert(challengeText)



-- Credits scherm elementen

-- Zwarte achtergrond voor credits
local creditsBg = display.newRect(centerX, centerY, screenW, screenH)
creditsBg:setFillColor(0, 0, 0)  -- Zwart
creditsScreen:insert(creditsBg)

-- Titel bovenaan
local creditsTitle = display.newText({
    text = "Cheese Clicker",
    x = centerX,
    y = 75,
    font = native.systemFontBold,
    fontSize = 30
})
creditsTitle:setFillColor(1, 1, 1)  -- Wit
creditsScreen:insert(creditsTitle)

-- Namen van mijn en mandu
local makers = display.newText({
    text = "Gemaakt door\nMandu Ismail\nJalen Versteilen",
    x = centerX,
    y = centerY - 50,
    font = native.systemFont,
    fontSize = 15,
    align = "center"
})
makers:setFillColor(1, 1, 1)  -- Wit
creditsScreen:insert(makers)

-- Bedankbericht
local thanks = display.newText({
    text = "Bedankt voor het spelen!",
    x = centerX,
    y = centerY + 75,
    font = native.systemFontBold,
    fontSize = 15
})
thanks:setFillColor(1, 1, 1)  -- Wit
creditsScreen:insert(thanks)

-- Terug knop naar startscherm
local backBtn = display.newText({
    text = "Terug",
    x = centerX,
    y = screenH - 150,
    font = native.systemFontBold,
    fontSize = 15
})
backBtn:setFillColor(1, 1, 1)  -- Wit
creditsScreen:insert(backBtn)

-- Functie voor terug knop - gaat terug naar startscherm
backBtn:addEventListener("tap", function()
    creditsScreen.isVisible = false  -- Verberg credits
    startScreen.isVisible = true      -- Toon startscherm
end)

-- Credits knop op startscherm (onderaan)
local creditButton = display.newRoundedRect(centerX, centerY + 235, 250, 70, 12)
creditButton:setFillColor(0.3, 0.3, 0.3)
creditButton.strokeWidth = 3
creditButton:setStrokeColor(0.5, 0.5, 0.5)
startScreen:insert(creditButton)

local creditText = display.newText({
    text = "CREDITS",
    x = centerX,
    y = centerY + 235,
    font = native.systemFontBold,
    fontSize = 30
})
creditText:setFillColor(1, 1, 1)
startScreen:insert(creditText)

-- Functie voor credits knop - opent credits scherm
creditButton:addEventListener("tap", function()
    startScreen.isVisible = false     -- Verberg startscherm
    creditsScreen.isVisible = true    -- Toon credits scherm
end)

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

-- Save knop (onderaan midden) - slaat game handmatig op
local saveButton = display.newRoundedRect(screenW * 0.3, screenH - 50, 140, 50, 8)
saveButton:setFillColor(0.2, 0.8, 0.2)  -- Groen
saveButton.strokeWidth = 2
saveButton:setStrokeColor(0.1, 0.6, 0.1)
gameScreen:insert(saveButton)

local saveButtonText = display.newText({
    text = "OPSLAAN",
    x = screenW * 0.3,
    y = screenH - 50,
    fontSize = 18,
    font = native.systemFontBold
})
saveButtonText:setFillColor(1, 1, 1)
gameScreen:insert(saveButtonText)

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

-- Menu knop
local menuButton = display.newRoundedRect(269, 500, 100, 50, 8)
menuButton:setFillColor(0.8, 0.2, 0.2)  -- Rood
menuButton.strokeWidth = 2
menuButton:setStrokeColor(0.6, 0.1, 0.1)
gameScreen:insert(menuButton)

local menuText = display.newText({
    text = "MENU",
    x = 270,
    y = 500,
    fontSize = 20,
    font = native.systemFontBold
})
menuText:setFillColor(1, 1, 1)
gameScreen:insert(menuText)

-- Variabelen om timer IDs op te slaan (zodat we ze kunnen stoppen)
local productionTimer = nil
local frenzyTimer = nil
local autoSaveTimer = nil

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
        text = " ⚡FRENZY!⚡",
        x = screenW * 0.3,
        y = centerY + 120,
        fontSize = 30,
        font = native.systemFontBold
    }
    FrenzyNotifier:setFillColor(1, 0.3, 0)
    gameScreen:insert(FrenzyNotifier)
    timer.performWithDelay(5000, function() frenzyactive = false end, 1)
    timer.performWithDelay(5000, function() FrenzyNotifier:removeSelf() end, 1)
end

-- ========== START GAME TRANSITION ==========
local function startGame(loadSave)
    -- Verberg start scherm
    startScreen.isVisible = false
    
    -- Laad game data als het een resume is
    if loadSave then
        loadGame()
        -- Update UI met geladen data
        if numberText then
            numberText.text = math.floor(kaas)
        end
        if buykoetext then
            buykoetext.text = "Koe 🐄\n" .. koecost .. " kaas\n- Owned: " .. koe
        end
        if buyboertext then
            buyboertext.text = "Boer 👨‍🌾\n" .. boercost .. " kaas\n- Owned: " .. boer
        end
        if buykaaswinkeltext then
            buykaaswinkeltext.text = "Kaaswinkel 🏪\n" .. kaaswinkelcost .. " kaas\n- Owned: " .. kaaswinkel
        end
    end
    
    -- Toon game scherm
    gameScreen.isVisible = true
    
    -- Start alle timers en sla IDs op (zodat we ze later kunnen stoppen)
    productionTimer = timer.performWithDelay(1000, kaaswinkelProduction, 0)
    frenzyTimer = timer.performWithDelay(30000, startFrenzyClicker, 0)
    autoSaveTimer = timer.performWithDelay(30000, saveGame, 0)  -- Auto-save elke 30 sec
end

-- ========== TERUG NAAR MENU FUNCTIE ==========
local function backToMenu()
    -- Sla eerst de game op voordat we teruggaan
    saveGame()
    
    -- Stop alle timers (anders blijven ze draaien in de achtergrond!)
    if productionTimer then 
        timer.cancel(productionTimer) 
        productionTimer = nil
    end
    if frenzyTimer then 
        timer.cancel(frenzyTimer) 
        frenzyTimer = nil
    end
    if autoSaveTimer then 
        timer.cancel(autoSaveTimer) 
        autoSaveTimer = nil
    end
    
    -- Verberg game scherm
    gameScreen.isVisible = false
    
    -- Toon start scherm
    startScreen.isVisible = true
    
    -- Update resume knop zichtbaarheid (nu is er een save bestand)
    if resumeButton and resumeText then
        resumeButton.isVisible = true
        resumeText.isVisible = true
    end
end

-- Event Listerners voor knoppen
-- Verbind play button (nieuwe game)
playButton:addEventListener("tap", function()
    startGame(false)
end)

-- Verbind resume button (laad opgeslagen game)
resumeButton:addEventListener("tap", function()
    startGame(true)
end)

-- Verbind menu button (terug naar hoofdmenu)
menuButton:addEventListener("tap", backToMenu)

-- Verbind save button (handmatig opslaan)
saveButton:addEventListener("tap", function()
    saveGame()
    -- Toon kort een "Opgeslagen!" bericht
    local savedMsg = display.newText({
        text = "✓ Opgeslagen!",
        x = screenW * 0.3,
        y = screenH - 100,
        fontSize = 20,
        font = native.systemFontBold
    })
    savedMsg:setFillColor(0, 1, 0)
    gameScreen:insert(savedMsg)
    -- Verwijder het bericht na 1.5 seconden
    timer.performWithDelay(1500, function() 
        savedMsg:removeSelf() 
    end)
end)
