-- Challenge - Snel Klikken
local vars = {time=30,name="",clicks=0,active=false,nameInput=nil,gameNameInput=nil,timerHandle=nil,timerDisplay=nil}
local leaderboard = {}
local json = require("json")
local stage = display.getCurrentStage()

local function clearScreen() for i=stage.numChildren,1,-1 do stage[i]:removeSelf() end end
local function addText(txt,x,y,sz,bold,col) col=col or {1,1,1} local t=display.newText({parent=stage,text=txt,x=x,y=y,fontSize=sz,font=bold and native.systemFontBold or native.systemFont}) t:setFillColor(col[1],col[2],col[3]) return t end
local function addButton(txt,y,cb,col) col=col or {0.8,0.2,0.2} local b=display.newRoundedRect(stage,display.contentCenterX,y,280,55,10) b:setFillColor(col[1],col[2],col[3]) addText(txt,display.contentCenterX,y,20,true) b:addEventListener("tap",cb) return b end

local function loadLeaderboard() local p=system.getDocumentsDirectory().."/leaderboard.json" local f=io.open(p,"r") leaderboard=f and json.decode(f:read("*a")) or {} if f then io.close(f) end end
local function saveScore(n,c) table.insert(leaderboard,{name=n,clicks=c}) table.sort(leaderboard,function(a,b) return a.clicks>b.clicks end) while #leaderboard>5 do table.remove(leaderboard) end local f=io.open(system.getDocumentsDirectory().."/leaderboard.json","w") if f then f:write(json.encode(leaderboard)) io.close(f) end end

function startGame()
    vars.name=vars.nameInput.text if vars.name=="" then vars.name="Gast" end
    if vars.time==30 and vars.name=="Gast" then native.showAlert("Naam","Voer naam in!",{"OK"}) return end
    clearScreen() vars.active=true vars.clicks=0 vars.timeRemaining=vars.time
    local bg=display.newRect(stage,display.contentCenterX,display.contentCenterY,display.contentWidth,display.contentHeight) bg:setFillColor(0.2,0.5,0.8)
    addText("Klik zo snel!",display.contentCenterX,100,32,true) addText("Speler: "..vars.name,display.contentCenterX,160,20)
    vars.timerDisplay=addText(vars.timeRemaining,display.contentCenterX,250,100,true,{1,1,0})
    local clicks=addText("Klikken: "..vars.clicks,display.contentCenterX,400,48,true)
    local clickBtn=display.newRect(stage,display.contentCenterX,550,300,200) clickBtn:setFillColor(1,0.5,0) addText("KLI MEE!",display.contentCenterX,550,40,true)
    clickBtn:addEventListener("tap",function() if vars.active then vars.clicks=vars.clicks+1 clicks.text="Klikken: "..vars.clicks end end)
    if vars.timerHandle then timer.cancel(vars.timerHandle) end
    vars.timerHandle=timer.performWithDelay(1000,function() vars.timeRemaining=vars.timeRemaining-1 vars.timerDisplay.text=vars.timeRemaining if vars.timeRemaining<=0 then timer.cancel(vars.timerHandle) vars.active=false endGame() end end,0)
end

function endGame()
    clearScreen() local bg=display.newRect(stage,display.contentCenterX,display.contentCenterY,display.contentWidth,display.contentHeight) bg:setFillColor(0,0,0) bg.alpha=0.8
    addText("Spel Voorbij!",display.contentCenterX,100,48,true,{1,1,0}) addText("Klikken: "..vars.clicks,display.contentCenterX,200,40,true)
    if vars.time==30 then
        addText("30-sec! Voer naam in:",display.contentCenterX,280,20,false,{1,1,0})
        vars.gameNameInput=native.newTextField(display.contentCenterX,350,300,50) vars.gameNameInput.placeholder="Naam"
        addButton("Bewaar",450,function() local n=vars.gameNameInput.text if n=="" then n="Anoniem" end saveScore(n,vars.clicks) display.remove(vars.gameNameInput) addText("Opgeslagen!",display.contentCenterX,350,24,false,{0,1,0}) end,{0.2,0.8,0.2})
    end
    addButton("Menu",vars.time==30 and 550 or 380,init,{0.2,0.2,0.8})
end

function showLeaderboard()
    clearScreen() local bg=display.newRect(stage,display.contentCenterX,display.contentCenterY,display.contentWidth,display.contentHeight) bg:setFillColor(0.1,0.1,0.1) bg.alpha=0.95
    addText("Top 5 Leaderboard",display.contentCenterX,80,40,true,{1,1,0})
    if #leaderboard==0 then addText("Geen scores!",display.contentCenterX,400,22,false,{1,0,0}) else for i=1,math.min(5,#leaderboard) do addText(i..". "..leaderboard[i].name.." - "..leaderboard[i].clicks,display.contentCenterX,140+(i-1)*70,24) end end
    addButton("Menu",700,init,{0.2,0.8,0.2})
end

function init()
    clearScreen() loadLeaderboard()
    local bg=display.newRect(stage,display.contentCenterX,display.contentCenterY,display.contentWidth,display.contentHeight) bg:setFillColor(0.2,0.6,0.2)
    addText("Challenge",display.contentCenterX,60,48,true) addText("Naam:",display.contentCenterX,140,20)
    vars.nameInput=native.newTextField(display.contentCenterX,190,280,50) vars.nameInput.placeholder="Naam"
    addText("Tijd (1-60):",display.contentCenterX,270,18)
    local sliderBg=display.newRect(stage,display.contentCenterX,330,250,15) sliderBg:setFillColor(0.4,0.4,0.4)
    local sliderBtn=display.newCircle(stage,display.contentCenterX-125+(vars.time-1)*5,330,12) sliderBtn:setFillColor(1,1,0)
    local disp=addText("Gekozen: "..vars.time.." Sec",display.contentCenterX,380,20)
    local function upSlider(x) local mn=display.contentCenterX-125 local mx=display.contentCenterX+125 x=math.max(mn,math.min(mx,x)) sliderBtn.x=x vars.time=math.min(60,math.ceil((x-mn)/250*59)+1) disp.text="Gekozen: "..vars.time.." Sec" if vars.time==30 then disp:setFillColor(1,1,0) sliderBtn:setFillColor(1,1,0) else disp:setFillColor(1,1,1) sliderBtn:setFillColor(1,0.5,0) end end
    local function sliderEvt(e) if e.phase=="moved" or e.phase=="began" then upSlider(e.x) end end
    sliderBg:addEventListener("touch",sliderEvt) sliderBtn:addEventListener("touch",sliderEvt)
    addButton("START",470,startGame,{0.2,0.8,0.2}) addButton("Leaderboard",540,showLeaderboard,{0.2,0.2,0.8}) addButton("Menu",600,function() print("Menu") end,{0.6,0.6,0.6})
end

init()
