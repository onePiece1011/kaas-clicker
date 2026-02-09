display.setStatusBar(display.HiddenStatusBar)

local json = require("json")

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local screenW = display.actualContentWidth
local screenH = display.actualContentHeight

local cheeseYellow = {1, 0.9, 0.4}
local black = {0, 0, 0}
local white = {1, 1, 1}

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

local productionTimer = nil
local frenzyTimer = nil
local autoSaveTimer = nil

local leaderboardFile = "challenge_leaderboard.json"
local leaderboard = {}
local challengeTimerId = nil
local challengeCountdown = 0
local challengeScore = 0
local challengeName = ""
local challengeLength = 0
local times = {1,2,3,4,5,10,15,20,25,30}

local times = {1,2,3,4,5,10,15,20,25,30}


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

local function hasSaveFile()
    local path = system.pathForFile("Cheese_data.json", system.DocumentsDirectory)
    local file = io.open(path, "r")
    if file then
        io.close(file)
        return true
    end
    return false
end

local function loadLeaderboard()
    local path = system.pathForFile(leaderboardFile, system.DocumentsDirectory)
    local OpenLeaderBoardPath = io.open(path, "r")
    if OpenLeaderBoardPath then
        local contents = OpenLeaderBoardPath:read("*a")
        io.close(OpenLeaderBoardPath)
        local data = json.decode(contents)
        if data then leaderboard = data end
    end
end

local function saveLeaderboard()
    local path = system.pathForFile(leaderboardFile, system.DocumentsDirectory)
    local OpenLeaderBoardPath = io.open(path, "w")
    if OpenLeaderBoardPath then
        OpenLeaderBoardPath:write(json.encode(leaderboard))
        io.close(OpenLeaderBoardPath)
    end
end

loadLeaderboard()


local startScreen = display.newGroup()
local creditsScreen = display.newGroup()
local gameScreen = display.newGroup()
local ChallengeModeScreen = display.newGroup()
local challengePlay = display.newGroup()
local challengeEnd = display.newGroup()

gameScreen.isVisible = false
creditsScreen.isVisible = false
ChallengeModeScreen.isVisible = false
challengePlay.isVisible = false
challengeEnd.isVisible = false


local startBg = display.newRect(centerX, centerY, screenW, screenH)
startBg:setFillColor(0.95, 0.85, 0.6)
startScreen:insert(startBg)

local startTitle = display.newText({
    text = "KAAS\nCLICKER",
    x = centerX,
    y = centerY - 280,
    font = native.systemFontBold,
    fontSize = 65,
    align = "center"
})
startTitle:setFillColor(1, 0.6, 0)
startScreen:insert(startTitle)

local cheeseIcon = display.newText({
    text = "🧀",
    x = centerX,
    y = centerY - 170,
    fontSize = 70
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

-- Challenge Mode knop
local challengeButton = display.newRoundedRect(centerX, centerY + 70, 250, 70, 12)
challengeButton:setFillColor(0.6, 0.2, 0.8)
challengeButton.strokeWidth = 3
challengeButton:setStrokeColor(0.5, 0.1, 0.6)
startScreen:insert(challengeButton)

local challengeText = display.newText({
    text = "CHALLENGE MODE",
    x = centerX,
    y = centerY + 70,
    font = native.systemFontBold,
    fontSize = 25
})
challengeText:setFillColor(1, 1, 1)
startScreen:insert(challengeText)

local creditButton = display.newRoundedRect(centerX, centerY + 160, 250, 70, 12)
creditButton:setFillColor(0.3, 0.3, 0.3)
creditButton.strokeWidth = 3
creditButton:setStrokeColor(0.5, 0.5, 0.5)
startScreen:insert(creditButton)

local creditText = display.newText({
    text = "CREDITS",
    x = centerX,
    y = centerY + 160,
    font = native.systemFontBold,
    fontSize = 30
})
creditText:setFillColor(1, 1, 1)
startScreen:insert(creditText)


local creditsBg = display.newRect(centerX, centerY, screenW, screenH)
creditsBg:setFillColor(0, 0, 0, 0.92)
creditsScreen:insert(creditsBg)

local panelMargin = 40
local panel = display.newRoundedRect(centerX, centerY, screenW - panelMargin * 2, screenH - 160, 12)
panel:setFillColor(0.06, 0.04, 0.02)
panel.strokeWidth = 2
panel:setStrokeColor(0.12, 0.08, 0.02)
creditsScreen:insert(panel)

local headerY = panel.y - panel.height/2 + 50
local cheeseIconSmall = display.newText({ text = "🧀", x = centerX - 80, y = headerY, font = native.systemFontBold, fontSize = 36 })
creditsScreen:insert(cheeseIconSmall)

local creditsTitle = display.newText({
    text = "CHEESE",
    x = centerX + 10,
    y = headerY,
    font = native.systemFontBold,
    fontSize = 32,
    align = "left"
})
creditsTitle:setFillColor(1, 0.85, 0.3)
creditsScreen:insert(creditsTitle)

local divider = display.newRect(centerX, creditsTitle.y + 30, panel.width - 40, 2)
divider:setFillColor(0.18, 0.18, 0.18)
creditsScreen:insert(divider)

local contentYStart = divider.y + 30
local lineSpacing = 32

local madeByLabel = display.newText({ text = "Gemaakt door", x = centerX, y = contentYStart, font = native.systemFontBold, fontSize = 18 })
madeByLabel:setFillColor(1, 1, 1)
creditsScreen:insert(madeByLabel)

local name1 = display.newText({ text = "Mandu Ismail", x = centerX, y = madeByLabel.y + lineSpacing, font = native.systemFont, fontSize = 16 })
name1:setFillColor(0.95, 0.9, 0.7)
creditsScreen:insert(name1)

local name2 = display.newText({ text = "Jalen Versteilen", x = centerX, y = name1.y + lineSpacing, font = native.systemFont, fontSize = 16 })
name2:setFillColor(0.95, 0.9, 0.7)
creditsScreen:insert(name2)

local thanks = display.newText({ text = "Bedankt voor het spelen!", x = centerX, y = name2.y + lineSpacing + 8, font = native.systemFontBold, fontSize = 18 })
thanks:setFillColor(1, 1, 1)
creditsScreen:insert(thanks)

local backBtnBg = display.newRoundedRect(centerX, panel.y + panel.height/2 - 40, 160, 48, 10)
backBtnBg:setFillColor(1, 0.6, 0)
backBtnBg.strokeWidth = 2
backBtnBg:setStrokeColor(0.8, 0.4, 0)
creditsScreen:insert(backBtnBg)

local backBtn = display.newText({ text = "Terug", x = centerX, y = backBtnBg.y, font = native.systemFontBold, fontSize = 18 })
backBtn:setFillColor(1, 1, 1)
creditsScreen:insert(backBtn)

local function closeCredits()
    creditsScreen.isVisible = false
    startScreen.isVisible = true
end

backBtnBg:addEventListener("tap", closeCredits)
backBtn:addEventListener("tap", closeCredits)


local function endChallenge()
    if challengeTimerId then timer.cancel(challengeTimerId); challengeTimerId = nil end
    if challengePlay then
        for i = challengePlay.numChildren,1,-1 do
            challengePlay[i]:removeSelf()
        end
    end
    challengePlay.isVisible = false

    for i = challengeEnd.numChildren,1,-1 do
        challengeEnd[i]:removeSelf()
    end
    challengeEnd.isVisible = true
    local bg = display.newRect(centerX, centerY, screenW, screenH)
    bg:setFillColor(0.95, 0.9, 0.7)
    challengeEnd:insert(bg)

    local title = display.newText({text = "Tijd is om!", x = centerX, y = 80, font = native.systemFontBold, fontSize = 28})
    title:setFillColor(1,0.2,0.2)
    challengeEnd:insert(title)

    local scoreTxt = display.newText({text = "Score: " .. tostring(challengeScore), x = centerX, y = 140, font = native.systemFontBold, fontSize = 22})
    challengeEnd:insert(scoreTxt)

    if challengeLength == 10 then
        table.insert(leaderboard, {name = challengeName, score = challengeScore})
        table.sort(leaderboard, function(a,b) return a.score > b.score end)
        while #leaderboard > 5 do table.remove(leaderboard) end
        saveLeaderboard()
    end

    local restartBtn = display.newRoundedRect(centerX - 80, screenH - 160, 120, 36, 8)
    restartBtn:setFillColor(1,0.6,0)
    restartBtn.strokeWidth = 2
    restartBtn:setStrokeColor(0.8,0.45,0.05)
    challengeEnd:insert(restartBtn)
    local restartTxt = display.newText({text = "Herstart", x = restartBtn.x, y = restartBtn.y, font = native.systemFontBold, fontSize = 15})
    restartTxt:setFillColor(1)
    challengeEnd:insert(restartTxt)

    local menuBtn = display.newRoundedRect(centerX + 80, screenH - 160, 120, 36, 8)
    menuBtn:setFillColor(0.2,0.5,0.9)
    menuBtn.strokeWidth = 2
    menuBtn:setStrokeColor(0.08,0.35,0.7)
    challengeEnd:insert(menuBtn)
    local menuTxt = display.newText({text = "Menu", x = menuBtn.x, y = menuBtn.y, font = native.systemFontBold, fontSize = 15})
    menuTxt:setFillColor(1)
    challengeEnd:insert(menuTxt)

    restartBtn:addEventListener("tap", function()
        challengeEnd.isVisible = false
        showChallengeSelect()
    end)
    menuBtn:addEventListener("tap", function()
        challengeEnd.isVisible = false
        startScreen.isVisible = true
    end)

    if challengeLength == 10 then
        local lbY = 190
        local lbTitle = display.newText({text = "Leaderboard", x = centerX, y = lbY, font = native.systemFontBold, fontSize = 18})
        lbTitle:setFillColor(0)
        challengeEnd:insert(lbTitle)
        lbY = lbY + 30
        for i,entry in ipairs(leaderboard) do
            local t = display.newText({text = i .. ". " .. entry.name .. " - " .. entry.score, x = centerX, y = lbY, font = native.systemFont, fontSize = 16})
            t:setFillColor(0.08)
            challengeEnd:insert(t)
            lbY = lbY + 26
        end
    end
end

function startChallenge(name, seconds)
    challengeName = name
    challengeCountdown = seconds
    challengeLength = seconds
    challengeScore = 0
    
    for i = challengePlay.numChildren,1,-1 do challengePlay[i]:removeSelf() end
    challengePlay.isVisible = true
    
    local bg = display.newRect(centerX, centerY, screenW, screenH)
    bg:setFillColor(0.95, 0.9, 0.7)
    challengePlay:insert(bg)
    
    local timerTxt = display.newText({text = tostring(challengeCountdown), x = screenW * 0.3, y = 60, font = native.systemFontBold, fontSize = 28})
    challengePlay:insert(timerTxt)
    
    local scoreTxt = display.newText({text = "0", x = screenW * 0.7, y = 60, font = native.systemFontBold, fontSize = 28})
    challengePlay:insert(scoreTxt)
    
    local kaasC = display.newImageRect("images/kaas.png", 180, 180)
    kaasC.x = centerX
    kaasC.y = centerY
    challengePlay:insert(kaasC)

    local function onTap()
        challengeScore = challengeScore + 1
        scoreTxt.text = tostring(challengeScore)
    end
    kaasC:addEventListener("tap", onTap)

    challengeTimerId = timer.performWithDelay(1000, function()
        challengeCountdown = challengeCountdown - 1
        timerTxt.text = tostring(challengeCountdown)
        if challengeCountdown <= 0 then
            endChallenge()
        end
    end, seconds)

    challengeSelect.isVisible = false
end

local function showChallengeSelect()
    startScreen.isVisible = false
    creditsScreen.isVisible = false
    gameScreen.isVisible = false
    challengePlay.isVisible = false
    challengeEnd.isVisible = false
    challengeSelect:toFront()
    challengeSelect.isVisible = true
    
    for i = challengeSelect.numChildren,1,-1 do
        local child = challengeSelect[i]
        child:removeSelf()
    end

    local bg = display.newRect(centerX, centerY, screenW, screenH)
    bg:setFillColor(0.95, 0.9, 0.7)
    challengeSelect:insert(bg)

    local title = display.newText({text = "CHALLENGE MODE", x = centerX, y = 60, font = native.systemFontBold, fontSize = 28})
    title:setFillColor(1,0.6,0)
    challengeSelect:insert(title)

    local title = display.newText({text = "(Kies 10 seconden voor scores)", x = centerX, y = 15, font = native.systemFontBold, fontSize = 12})
    title:setFillColor(0,0.0,0)
    challengeSelect:insert(title)

    local instructions = display.newText({text = "Kies een tijd (seconden):", x = centerX, y = 110, font = native.systemFont, fontSize = 16})
    instructions:setFillColor(0)
    challengeSelect:insert(instructions)

    local btnW, btnH = 140, 46
    local leftX = centerX - 90
    local rightX = centerX + 90
    local startY = 160
    local spacingY = 12
    for i, t in ipairs(times) do
        local col = (i <= 5) and 1 or 2
        local indexInCol = ((i - 1) % 5) + 1
        local x = (col == 1) and leftX or rightX
        local y = startY + (indexInCol - 1) * (btnH + spacingY)

        local b = display.newRoundedRect(x, y, btnW, btnH, 8)
        b:setFillColor(1, 0.85, 0.3)
        b.strokeWidth = 2
        b:setStrokeColor(0.8, 0.65, 0.2)
        challengeSelect:insert(b)

        local bt = display.newText({text = tostring(t) .. "s", x = x, y = y, font = native.systemFontBold, fontSize = 18})
        bt:setFillColor(0.08)
        challengeSelect:insert(bt)

        local function onSelect()
            if t == 10 then
                local panel = display.newRoundedRect(centerX, centerY, screenW - 80, 160, 12)
                panel:setFillColor(0.06,0.04,0.02)
                panel.strokeWidth = 2
                panel:setStrokeColor(0.12,0.08,0.02)
                challengeSelect:insert(panel)

                local nameField = native.newTextField(centerX, centerY - 10, 260, 36)
                nameField.placeholder = "Voer je naam in"

                local startBtn = display.newRoundedRect(centerX, centerY + 40, 140, 40, 8)
                startBtn:setFillColor(1,0.6,0)
                challengeSelect:insert(startBtn)
                local startTxt = display.newText({text = "START", x = centerX, y = centerY + 40, font = native.systemFontBold, fontSize = 16})
                startTxt:setFillColor(1)
                challengeSelect:insert(startTxt)

                local function begin()
                    local playerName = nameField.text
                    if not playerName or playerName == "" then playerName = "Anon" end
                    if nameField and nameField.removeSelf then nameField:removeSelf() end
                    nameField = nil
                    if panel and panel.removeSelf then panel:removeSelf() end
                    if startBtn and startBtn.removeSelf then startBtn:removeSelf() end
                    if startTxt and startTxt.removeSelf then startTxt:removeSelf() end
                    startChallenge(playerName, t)
                end

                startBtn:addEventListener("tap", begin)
            else
                startChallenge("Anon", t)
            end
        end

        b:addEventListener("tap", onSelect)
    end

    local back = display.newText({text = "Terug", x = centerX, y = screenH - 50, font = native.systemFontBold, fontSize = 18})
    back:setFillColor(0.2)
    challengeSelect:insert(back)
    back:addEventListener("tap", function()
        challengeSelect.isVisible = false
        startScreen.isVisible = true
    end)
end


local bg = display.newRect(centerX, centerY, screenW, screenH)
bg:setFillColor(0.95, 0.9, 0.7)
gameScreen:insert(bg)

local sidebarWidth = screenW * 0.35
local sidebar = display.newRect(screenW - sidebarWidth/2, centerY, sidebarWidth, screenH)
sidebar:setFillColor(0.2, 0.15, 0.1)
gameScreen:insert(sidebar)

local sidebarTitle = display.newText({
    text = "UPGRADES",
    x = screenW - sidebarWidth/2,
    y = 40,
    fontSize = 20,
    font = native.systemFontBold
})
sidebarTitle:setFillColor(1, 0.85, 0.4)
gameScreen:insert(sidebarTitle)

local titleText = display.newText({
    text = "   KAAS\nCLICKER",
    x = screenW * 0.30,
    y = 50,
    fontSize = 28,
    font = native.systemFontBold
})
titleText:setFillColor(1, 0.6, 0)
gameScreen:insert(titleText)

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

kaasimage = display.newImageRect("images/kaas.png", 140, 140)
kaasimage.x = screenW * 0.3
kaasimage.y = centerY
gameScreen:insert(kaasimage)

local saveButton = display.newRoundedRect(screenW * 0.3, screenH - 50, 140, 50, 8)
saveButton:setFillColor(0.2, 0.8, 0.2)
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

local buyKoeButton, buykoetext = createUpgradeButton("Koe 🐄", koecost, 100, koecost)
local buyBoerButton, buyboertext = createUpgradeButton("Boer 👨‍🌾", boercost, 190, boercost)
local buyKaasWinkelButton, buykaaswinkeltext = createUpgradeButton("Kaaswinkel 🏪", kaaswinkelcost, 280, kaaswinkelcost)

local menuButton = display.newRoundedRect(269, 500, 100, 50, 8)
menuButton:setFillColor(0.8, 0.2, 0.2)
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

local function onScreenTap()
    if kaas < math.huge then
        kaas = kaas + 1
        totalclicks = totalclicks + 1

        if koe >= 1 then
            kaas = kaas + (1 * koe)
        end
        
        if frenzyactive then
            kaas = kaas + (4 * (1 + (1 * koe)))
        end
        
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

local function kaaswinkelProduction()
    if kaaswinkel >= 1 then
        kaas = kaas + (2 * kaaswinkel)
        numberText.text = math.floor(kaas)
    end
end

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

local function startGame(loadSave)
    startScreen.isVisible = false
    
    if loadSave then
        loadGame()
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
    
    gameScreen.isVisible = true
    
    productionTimer = timer.performWithDelay(1000, kaaswinkelProduction, 0)
    frenzyTimer = timer.performWithDelay(30000, startFrenzyClicker, 0)
    autoSaveTimer = timer.performWithDelay(30000, saveGame, 0)
end

local function backToMenu()
    saveGame()
    
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
    
    gameScreen.isVisible = false
    startScreen.isVisible = true
end


playButton:addEventListener("tap", function()
    startGame(false)
end)

creditButton:addEventListener("tap", function()
    startScreen.isVisible = false
    creditsScreen.isVisible = true
end)

challengeButton:addEventListener("tap", function()
    showChallengeSelect()
end)

menuButton:addEventListener("tap", backToMenu)

saveButton:addEventListener("tap", function()
    saveGame()
    local savedMsg = display.newText({
        text = "✓ Opgeslagen!",
        x = screenW * 0.3,
        y = screenH - 100,
        fontSize = 20,
        font = native.systemFontBold
    })
    savedMsg:setFillColor(0, 1, 0)
    gameScreen:insert(savedMsg)
    timer.performWithDelay(1500, function() 
        savedMsg:removeSelf() 
    end)
end)

kaasimage:addEventListener("tap", onScreenTap)
buyKoeButton:addEventListener("tap", koopkoe)
buyBoerButton:addEventListener("tap", koopboer)
buyKaasWinkelButton:addEventListener("tap", koopkaaswinkel)
