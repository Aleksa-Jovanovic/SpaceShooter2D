--this is how you require files in directories
package.path = package.path .. ";utils/?.lua;"
package.path = package.path .. ";managers/?.lua"
package.path = package.path .. ";powerUps/?.lua"
----------------------
--for debugging in zero brane, add breakpoints. be sure to activate "start debugging server" under "Project"
--require("mobdebug").start()

--this is to make prints appear right away in zerobrane
io.stdout:setvbuf("no")

--GLOBAL Variable
_G.SHOW_SPACE_GRID = false
_G.USE_SPACE_PARTITION = true --If the screen is large and there are a lot of objects it would benefit processing time

----BEGIN -> INSTANTIATING A CLASS
--Background
local StarsCls = require("Stars")
local stars = nil

--Data
local Model = require("Model")

--Managers
local AssetsManager = require("AssetsManager")
local ObjectManager = require("ObjectManager")
local CollisionManager = require("CollisionManager")
local WaveManager = require("WaveManager")
local ScoreManager = require("ScoreManager")
local ObjectPool = require("ObjectPool")

--Player
local ShipCls = require("Ship") --import the class
local ship = nil
----END -> INSTANTIATING A CLASS

--Controls
local LEFT_KEY = "left"
local RIGHT_KEY = "right"
local UP_KEY = "up"
local DOWN_KEY = "down"



function love.load()
    print("love.load")
    AssetsManager.init()
    Model.init()

    --Create starts for background
    stars = StarsCls.new(Model.starsParams)

    --Create player
    ship = ShipCls.new(Model.shipParams)

    --Init managers
    ScoreManager:init()
    ObjectPool:init()

    local objectManagerParams = { player = ship }
    ObjectManager:init(objectManagerParams)
    CollisionManager:init()
    WaveManager:init()
end

function love.update(dt)
    --Stop game if player is dead
    if (not ObjectManager:isPlayerAlive()) then
        return
    end

    --Stop game if all levels are finished
    if (WaveManager:isGameWon()) then
        return
    end

    --Update background
    stars:update(dt)

    --Main update
    ObjectManager:update(dt)
    CollisionManager:update(dt)
    WaveManager:update(dt)
end

local function GameOver()
    local font = love.graphics.newFont(45)
    local gameOver = "GAME OVER"

    gameOver = love.graphics.newText(font, { { 0.9, 0.2, 0.2 }, gameOver })
    local gameOverPositionX = Model.stage.stageWidth / 2 - gameOver:getWidth() / 2
    local gameOverPositionY = Model.stage.stageHeight / 2 - gameOver:getHeight() / 2
    love.graphics.draw(gameOver, gameOverPositionX, gameOverPositionY)

    local scoreText = ScoreManager:getScoreAsText()
    local scorePositionX = Model.stage.stageWidth / 2 - scoreText:getWidth() / 2
    local scorePositionY = gameOverPositionY - gameOver:getHeight() / 2
    love.graphics.draw(scoreText, scorePositionX, scorePositionY)
end

local function GameWon()
    local font = love.graphics.newFont(45)
    local gameWon = "GAME WON"

    gameWon = love.graphics.newText(font, { { 1, 1, 1 }, gameWon })
    local gameWonPositionX = Model.stage.stageWidth / 2 - gameWon:getWidth() / 2
    local gameWonPositionY = Model.stage.stageHeight / 2 - gameWon:getHeight() / 2
    love.graphics.draw(gameWon, gameWonPositionX, gameWonPositionY)

    local scoreText = ScoreManager:getScoreAsText()
    local scorePositionX = Model.stage.stageWidth / 2 - scoreText:getWidth() / 2
    local scorePositionY = gameWonPositionY - gameWon:getHeight() / 2
    love.graphics.draw(scoreText, scorePositionX, scorePositionY)
end

function love.draw()
    --Show current FPS
    local fps = love.timer.getFPS()
    love.graphics.print("FPS : " .. fps, 0, 0)

    --Draw background
    stars:draw()

    --If player is dead show score and GameOver text
    if (not ObjectManager:isPlayerAlive()) then
        GameOver()
        return
    end


    --If player won the game show GameWon and scor text
    if (WaveManager:isGameWon()) then
        GameWon()
        return
    end

    --Main draw functions
    ObjectManager:draw()
    CollisionManager:draw()
    WaveManager:draw()
    ScoreManager:draw()
end

function love.keypressed(key)
    if key == LEFT_KEY then
        Model.movement.left = true
    elseif key == RIGHT_KEY then
        Model.movement.right = true
    end

    if key == UP_KEY then
        Model.movement.up = true
    elseif key == DOWN_KEY then
        Model.movement.down = true
    end

    if (not ObjectManager:isPlayerAlive() or WaveManager:isGameWon()) then
        if key == "r" then
            --Restart game
            love.load()
        end
    end

    if key == "escape" then
        love.event.quit()
    end

end

function love.keyreleased(key)
    if key == LEFT_KEY then
        Model.movement.left = false
    elseif key == RIGHT_KEY then
        Model.movement.right = false
    end

    if key == UP_KEY then
        Model.movement.up = false
    elseif key == DOWN_KEY then
        Model.movement.down = false
    end
end
