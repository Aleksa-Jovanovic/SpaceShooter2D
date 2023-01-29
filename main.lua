--this is how you require files in directories
package.path = package.path .. ";utils/?.lua;"
package.path = package.path .. ";managers/?.lua"
----------------------
--for debugging in zero brane, add breakpoints. be sure to activate "start debugging server" under "Project"
require("mobdebug").start()

--this is to make prints appear right away in zerobrane
io.stdout:setvbuf("no")

--GLOBAL Variable
_G.SHOW_SPACE_GRID = true
_G.USE_SPACE_PARTITION = false --If the screen is large and there are a lot of objects it would benefit processing time

----INSTANTIATING A CLASS
local LiveObjectArrayCls = require("LiveObjectArray")
local StarsCls = require("Stars")
local stars = nil

local ObjectManager = require("ObjectManager")
local CollisionManager = require("CollisionManager")
local ScoreManager = require("ScoreManager")
local ObjectPool = require("ObjectPool")
--local objectManager = nil

local ShipCls = require("Ship") --import the class
local ship = nil

local EnemyCls = require("Enemy")
local spawnRate = 1
local spawnCountdown = 0

local AssetsManager = require("AssetsManager")
local Model = require("Model")

local SpacePartitionCls = require("SpacePartition")

local LEFT_KEY = "left"
local RIGHT_KEY = "right"
local UP_KEY = "up"
local DOWN_KEY = "down"

local function spawnEnemy(dt)
    if spawnCountdown <= 0 then
        spawnCountdown = 1 / spawnRate
        local newEnemy = ObjectPool:getEnemy(1)

        ObjectManager.enemies:addObject(newEnemy)
    else
        spawnCountdown = spawnCountdown - dt
    end
end

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


end

function love.update(dt)
    --Stop game if player is dead
    if (not ObjectManager:isPlayerAlive()) then
        return
    end

    stars:update(dt)

    ObjectManager:update(dt)
    CollisionManager:update(dt)
    spawnEnemy(dt)


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

function love.draw()
    --note the function on the instance is called with a : rather than a .
    --calling a function with a : passes the calling instance as reference into the funciton, allowing you to use "self"

    --Show current FPS
    local fps = love.timer.getFPS()
    love.graphics.print("FPS : " .. fps, 0, 0)

    stars:draw()

    --If player is dead show score and GameOver text
    if (not ObjectManager:isPlayerAlive()) then
        GameOver()
        return
    end

    --Default draw functions
    ObjectManager:draw()
    CollisionManager:draw()
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

    if (not ObjectManager:isPlayerAlive()) then
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
