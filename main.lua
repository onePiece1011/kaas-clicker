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

-- Tekst die het nummer laat zien
local numberText = display.newText({
    text = "Kaas: 0",
    x = display.contentCenterX,
    y = display.contentCenterY - 100,
    fontSize = 20
})
-- kaas afbeelding
kaasimage = display.newImageRect("images/kaas.png", 100, 100)
kaasimage.x = display.contentCenterX
kaasimage.y = display.contentCenterY - 25

--koop knoppen
local buyKoeButton = display.newRect(display.contentCenterX, display.contentCenterY + 90, 200, 50)
buyKoeButton:setFillColor(0, 0, 0)
local buykoetext = display.newText({
    text = "Koop Koe (" .. koecost .. " kaas)",
    x = buyKoeButton.x,
    y = buyKoeButton.y,
    fontSize = 10
})

local buyBoerButton = display.newRect(display.contentCenterX, display.contentCenterY + 150, 200, 50)
buyBoerButton:setFillColor(0, 0, 0)
local buyboertext = display.newText({
    text = "Koop Boer (" .. boercost .. " kaas)",
    x = buyBoerButton.x,
    y = buyBoerButton.y,
    fontSize = 10
})

local buyKaasWinkelButton = display.newRect(display.contentCenterX, display.contentCenterY + 210, 200, 50)
buyKaasWinkelButton:setFillColor(0, 0, 0)
local buykaaswinkeltext = display.newText({
    text = "Koop Kaaswinkel (" .. kaaswinkelcost .. " kaas)",
    x = buyKaasWinkelButton.x,
    y = buyKaasWinkelButton.y,
    fontSize = 10
})
-- koop functies
local function koopkoe()
    if kaas >= koecost then
        koe = koe + 1
        kaas = kaas - koecost
        koecost = math.floor(koecost * 1.5)
        buykoetext.text = "Koop Koe ( " .. koecost .. " kaas ) - " .. koe
        numberText.text = "Kaas: " .. kaas
    end
end

   local function koopboer()
    if kaas >= boercost then
        boer = boer + 1
        kaas = kaas - boercost
        boercost = math.floor(boercost * 1.5)
        buyboertext.text = "Koop Boer ( " .. boercost .. " kaas ) - " .. boer
        numberText.text = "Kaas: " .. kaas
    end
end

local function koopkaaswinkel()
    if kaas >= kaaswinkelcost then
        kaaswinkel = kaaswinkel + 1
        kaas = kaas - kaaswinkelcost
        kaaswinkelcost = math.floor(kaaswinkelcost * 1.5)
        buykaaswinkeltext.text = "Koop Kaaswinkel ( " .. kaaswinkelcost .. " kaas ) - " .. kaaswinkel
        numberText.text = "Kaas: " .. kaas
    end
end


-- Klik op scherm → +1
local function onScreenTap()
    if kaas < math.huge then
        kaas = kaas + 1
        totalclicks = totalclicks + 1
     
        -- berekent de bonusen

        -- koe bonus
        if koe >= 1 then
            kaas = kaas + (0.5 * koe)
        end
        
        -- Frenzy bonus
        if frenzyactive then
            kaas = kaas + (4 * (1 + (0.5 * koe)))
        end
        
 -- elke 50 kaas geeft het een 10 click bonus als er een boer is
        if boer >= 1 then
            if totalclicks >= 50 then
                bonusgiven = true
                if bonusgiven == true then
                    kaas = kaas + (10 * boer)
                    totalclicks = totalclicks - 49
                end
            end
        end
        
        numberText.text = "Kaas: " .. kaas
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
        numberText.text = "Kaas: " .. kaas
    end
end
-- frenzy functie
local function startFrenzyClicker()
    frenzyactive = true
    FrenzyNotifier = display.newText {
        text = "Frenzy Actief!",
        x = display.contentCenterX,
        y = display.contentCenterY - 200,
        fontSize = 50
    }
    timer.performWithDelay(5000, function() frenzyactive = false end, 1)
    timer.performWithDelay(5000, function() FrenzyNotifier:removeSelf() end, 1)
end
-- timers
timer.performWithDelay(1000, kaaswinkelProduction, 0)
timer.performWithDelay(30000, startFrenzyClicker, 0)
