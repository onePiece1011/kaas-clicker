local composer = require("composer")
local scene = composer.newScene()

function scene:create(event)
    local sceneGroup = self.view

    -- Achtergrond
    local bg = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY,
        display.actualContentWidth, display.actualContentHeight)
    bg:setFillColor(0, 0, 0) -- zwart

    -- Titel
    local title = display.newText({
        parent = sceneGroup,
        text = "Cheese Clicker",
        x = display.contentCenterX,
        y = 200,
        font = native.systemFontBold,
        fontSize = 70
    })
    title:setFillColor(1, 1, 1)

    -- Makers
    local makers = display.newText({
        parent = sceneGroup,
        text = "Gemaakt door\nMandu Ismail\nJalen Versteilen",
        x = display.contentCenterX,
        y = display.contentCenterY - 50,
        font = native.systemFont,
        fontSize = 50,
        align = "center"
    })
    makers:setFillColor(1, 1, 1)

    -- Bedankt voor spelen
    local thanks = display.newText({
        parent = sceneGroup,
        text = "Bedankt voor het spelen!",
        x = display.contentCenterX,
        y = display.contentCenterY + 200,
        font = native.systemFontBold,
        fontSize = 55
    })
    thanks:setFillColor(1, 1, 1)

    -- Terug knop
    local backBtn = display.newText({
        parent = sceneGroup,
        text = "Terug",
        x = display.contentCenterX,
        y = display.contentHeight - 150,
        font = native.systemFontBold,
        fontSize = 60
    })
    backBtn:setFillColor(1, 1, 1)

    backBtn:addEventListener("tap", function()
        composer.gotoScene("menu")
    end)
end

scene:addEventListener("create", scene)
return scene