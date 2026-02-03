local menu
local speler1
local buttons 
function love.load()
    -- Kleuren en fonts
    yellow = {1, 1, 0}
    white = {1, 1, 1}
    font = love.graphics.newFont(32)
    love.graphics.setFont(font)

    buttons = {
        {text = "Start Game", x = 100, y = 200, w = 300, h = 60},
        {text = "Fast Game Mode", x = 100, y = 280, w = 300, h = 60},
        {text = "Resume Game", x = 100, y = 360, w = 300, h = 60}
    }
end
