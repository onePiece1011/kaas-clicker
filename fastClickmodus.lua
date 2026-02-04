local composer = require("composer")
local scene = composer.newScene()
local json = require("json")

-- Variables
local timeRemaining = 0
local timerHandle = nil
local timerDisplay = nil
local selectedTime = 10 -- Default time
local playerName = ""
local clickCount = 0
local gameActive = false
local nameInput = nil
local leaderboard = {}

function scene:create(event)
    local sceneGroup = self.view
    
    -- Load leaderboard
    loadLeaderboard()

    -- Background
    local bg = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY,
        display.contentWidth, display.contentHeight)
    bg:setFillColor(1, 1, 0) -- yellow

    -- Title
    local title = display.newText({
        parent = sceneGroup,
        text = "Fast Click Mode",
        x = display.contentCenterX,
        y = 40,
        font = native.systemFontBold,
        fontSize = 44
    })
    title:setFillColor(1, 1, 1)

    -- Name input section
    local nameLabel = display.newText({
        parent = sceneGroup,
        text = "Enter Your Name:",
        x = display.contentCenterX,
        y = 100,
        font = native.systemFont,
        fontSize = 18
    })
    nameLabel:setFillColor(0, 0, 0)

    -- Name input field (using native text input)
    nameInput = native.newTextField(display.contentCenterX, 140, 250, 40)
    nameInput.inputType = "default"
    nameInput.placeholder = "Your name"

    -- Time selection text
    local timeText = display.newText({
        parent = sceneGroup,
        text = "Select Time (seconds):",
        x = display.contentCenterX,
        y = 200,
        font = native.systemFont,
        fontSize = 22
    })
    timeText:setFillColor(0, 0, 0)

    -- Button function
    local function makeButton(label, yPos, callback)
        local btn = display.newRoundedRect(sceneGroup, display.contentCenterX, yPos, 260, 50, 10)
        btn:setFillColor(0.8, 0.2, 0.2) -- red button

        local txt = display.newText({
            parent = sceneGroup,
            text = label,
            x = display.contentCenterX,
            y = yPos,
            font = native.systemFontBold,
            fontSize = 20
        })
        txt:setFillColor(1, 1, 1)

        btn:addEventListener("tap", callback)
    end

    -- Time selection buttons
    makeButton("10 Seconds", 240, function()
        selectedTime = 10
    end)

    makeButton("20 Seconds", 300, function()
        selectedTime = 20
    end)

    makeButton("30 Seconds (Leaderboard)", 360, function()
        selectedTime = 30
    end)

    makeButton("60 Seconds (Leaderboard)", 420, function()
        selectedTime = 60
    end)

    -- Timer display
    timerDisplay = display.newText({
        parent = sceneGroup,
        text = selectedTime,
        x = display.contentCenterX,
        y = 520,
        font = native.systemFontBold,
        fontSize = 70
    })
    timerDisplay:setFillColor(1, 1, 1)

    -- Start button
    makeButton("START GAME", 610, function()
        startGame(sceneGroup)
    end)

    -- Leaderboard button
    local leaderBtn = display.newRoundedRect(sceneGroup, display.contentCenterX, 670, 260, 50, 10)
    leaderBtn:setFillColor(0.2, 0.2, 0.8) -- blue button

    local leaderTxt = display.newText({
        parent = sceneGroup,
        text = "View Leaderboard",
        x = display.contentCenterX,
        y = 670,
        font = native.systemFontBold,
        fontSize = 20
    })
    leaderTxt:setFillColor(1, 1, 1)

    leaderBtn:addEventListener("tap", function()
        showLeaderboard(sceneGroup)
    end)

    -- Back button
    local backBtn = display.newRoundedRect(sceneGroup, display.contentCenterX, 730, 260, 50, 10)
    backBtn:setFillColor(0.6, 0.6, 0.6) -- gray button

    local backTxt = display.newText({
        parent = sceneGroup,
        text = "Back",
        x = display.contentCenterX,
        y = 730,
        font = native.systemFontBold,
        fontSize = 20
    })
    backTxt:setFillColor(1, 1, 1)

    backBtn:addEventListener("tap", function()
        if nameInput then
            display.remove(nameInput)
        end
        composer.gotoScene("menu")
    end)
end

-- Start game function
function startGame(sceneGroup)
    -- Get player name
    playerName = nameInput.text
    if playerName == "" or playerName == nil then
        playerName = "Guest"
    end

    -- 30 second rule: name is required for leaderboard entry
    if selectedTime >= 30 and playerName == "Guest" then
        native.showAlert("Name Required", "To play 30+ second modes, you must enter your name!", {"OK"})
        return
    end

    -- Clear the scene and create game UI
    display.remove(nameInput)
    nameInput = nil
    
    gameActive = true
    clickCount = 0
    timeRemaining = selectedTime
    
    -- Update timer display
    timerDisplay.text = timeRemaining

    -- Create game background
    local gameBg = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY,
        display.contentWidth, display.contentHeight)
    gameBg:setFillColor(0.2, 0.5, 0.8) -- blue

    -- Game title
    local gameTitle = display.newText({
        parent = sceneGroup,
        text = "Click as fast as you can!",
        x = display.contentCenterX,
        y = 100,
        font = native.systemFontBold,
        fontSize = 32
    })
    gameTitle:setFillColor(1, 1, 1)

    -- Player name display
    local nameDisplay = display.newText({
        parent = sceneGroup,
        text = "Player: " .. playerName,
        x = display.contentCenterX,
        y = 160,
        font = native.systemFont,
        fontSize = 20
    })
    nameDisplay:setFillColor(1, 1, 1)

    -- Timer display
    timerDisplay:removeSelf()
    timerDisplay = display.newText({
        parent = sceneGroup,
        text = timeRemaining,
        x = display.contentCenterX,
        y = 250,
        font = native.systemFontBold,
        fontSize = 100
    })
    timerDisplay:setFillColor(1, 1, 0)

    -- Clicks display
    local clicksDisplay = display.newText({
        parent = sceneGroup,
        text = "Clicks: " .. clickCount,
        x = display.contentCenterX,
        y = 400,
        font = native.systemFontBold,
        fontSize = 48
    })
    clicksDisplay:setFillColor(1, 1, 1)

    -- Clickable button
    local clickBtn = display.newRect(sceneGroup, display.contentCenterX, 550, 300, 200)
    clickBtn:setFillColor(1, 0.5, 0)

    local btnText = display.newText({
        parent = sceneGroup,
        text = "TAP ME!",
        x = display.contentCenterX,
        y = 550,
        font = native.systemFontBold,
        fontSize = 40
    })
    btnText:setFillColor(1, 1, 1)

    -- Click handler
    clickBtn:addEventListener("tap", function()
        if gameActive then
            clickCount = clickCount + 1
            clicksDisplay.text = "Clicks: " .. clickCount
        end
    end)

    -- Start countdown
    if timerHandle then
        timer.cancel(timerHandle)
    end

    timerHandle = timer.performWithDelay(1000, function()
        timeRemaining = timeRemaining - 1
        timerDisplay.text = timeRemaining

        if timeRemaining <= 0 then
            timer.cancel(timerHandle)
            gameActive = false
            endGame(sceneGroup, clickCount)
        end
    end, 0)
end

-- End game function
function endGame(sceneGroup, finalClicks)
    gameActive = false
    
    -- Show result
    local resultBg = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY,
        display.contentWidth, display.contentHeight)
    resultBg:setFillColor(0, 0, 0)
    resultBg.alpha = 0.8

    local resultTitle = display.newText({
        parent = sceneGroup,
        text = "Game Over!",
        x = display.contentCenterX,
        y = 200,
        font = native.systemFontBold,
        fontSize = 48
    })
    resultTitle:setFillColor(1, 1, 0)

    local scoreText = display.newText({
        parent = sceneGroup,
        text = playerName .. " - Clicks: " .. finalClicks,
        x = display.contentCenterX,
        y = 300,
        font = native.systemFontBold,
        fontSize = 32
    })
    scoreText:setFillColor(1, 1, 1)

    -- Save to leaderboard if 30+ seconds
    if selectedTime >= 30 then
        saveScore(playerName, finalClicks)
        local savedMsg = display.newText({
            parent = sceneGroup,
            text = "Score saved to leaderboard!",
            x = display.contentCenterX,
            y = 380,
            font = native.systemFont,
            fontSize = 20
        })
        savedMsg:setFillColor(0, 1, 0)
    end

    -- Back to menu button
    local backBtn = display.newRoundedRect(sceneGroup, display.contentCenterX, 500, 260, 60, 10)
    backBtn:setFillColor(0.2, 0.8, 0.2)

    local backTxt = display.newText({
        parent = sceneGroup,
        text = "Back to Menu",
        x = display.contentCenterX,
        y = 500,
        font = native.systemFontBold,
        fontSize = 22
    })
    backTxt:setFillColor(1, 1, 1)

    backBtn:addEventListener("tap", function()
        composer.gotoScene("menu")
    end)
end

-- Load leaderboard from file
function loadLeaderboard()
    local path = system.getDocumentsDirectory() .. "/leaderboard.json"
    local file = io.open(path, "r")
    
    if file then
        local contents = file:read("*a")
        io.close(file)
        leaderboard = json.decode(contents) or {}
    else
        leaderboard = {}
    end
end

-- Save score to leaderboard
function saveScore(name, clicks)
    table.insert(leaderboard, {name = name, clicks = clicks})
    
    -- Sort by clicks (highest first)
    table.sort(leaderboard, function(a, b)
        return a.clicks > b.clicks
    end)
    
    -- Keep only top 10
    if #leaderboard > 10 then
        for i = 11, #leaderboard do
            leaderboard[i] = nil
        end
    end
    
    -- Save to file
    local path = system.getDocumentsDirectory() .. "/leaderboard.json"
    local file = io.open(path, "w")
    if file then
        file:write(json.encode(leaderboard))
        io.close(file)
    end
end

-- Show leaderboard
function showLeaderboard(sceneGroup)
    local leaderBg = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY,
        display.contentWidth, display.contentHeight)
    leaderBg:setFillColor(0.1, 0.1, 0.1)
    leaderBg.alpha = 0.95

    local leaderTitle = display.newText({
        parent = sceneGroup,
        text = "30-Second Leaderboard",
        x = display.contentCenterX,
        y = 60,
        font = native.systemFontBold,
        fontSize = 36
    })
    leaderTitle:setFillColor(1, 1, 0)

    local startY = 140
    for i, entry in ipairs(leaderboard) do
        local rankText = display.newText({
            parent = sceneGroup,
            text = i .. ". " .. entry.name .. " - " .. entry.clicks,
            x = display.contentCenterX,
            y = startY + (i - 1) * 50,
            font = native.systemFont,
            fontSize = 22
        })
        rankText:setFillColor(1, 1, 1)
    end

    if #leaderboard == 0 then
        local emptyText = display.newText({
            parent = sceneGroup,
            text = "No scores yet!",
            x = display.contentCenterX,
            y = 400,
            font = native.systemFont,
            fontSize = 24
        })
        emptyText:setFillColor(1, 0, 0)
    end

    local backBtn = display.newRoundedRect(sceneGroup, display.contentCenterX, 650, 260, 60, 10)
    backBtn:setFillColor(0.2, 0.8, 0.2)

    local backTxt = display.newText({
        parent = sceneGroup,
        text = "Back",
        x = display.contentCenterX,
        y = 650,
        font = native.systemFontBold,
        fontSize = 22
    })
    backTxt:setFillColor(1, 1, 1)

    backBtn:addEventListener("tap", function()
        -- Reload scene to refresh
        composer.removeScene("fastClickmodus")
        composer.gotoScene("fastClickmodus")
    end)
end

function scene:destroy(event)
    if timerHandle then
        timer.cancel(timerHandle)
    end
    if nameInput then
        display.remove(nameInput)
    end
end

scene:addEventListener("create", scene)
scene:addEventListener("destroy", scene)
return scene
