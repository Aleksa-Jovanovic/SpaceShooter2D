--this is how you require files in directories
package.path = package.path .. ";utils/?.lua;"
----------------------
--for debugging in zero brane, add breakpoints. be sure to activate "start debugging server" under "Project"
require("mobdebug").start()

--this is to make prints appear right away in zerobrane
io.stdout:setvbuf("no")

--GLOBAL Variable
_G.SHOW_SPACE_GRID = true
_G.USE_SPACE_PARTITION = true --If the screen is large and there are a lot of objects it would benefit processing time

----INSTANTIATING A CLASS
local LiveObjectArrayCls = require("LiveObjectArray")
local StarsCls = require("Stars")
local stars = nil

local ObjectManagerCls = require("ObjectManager")
local objectManager = nil

local ShipCls = require("Ship") --import the class
local ship = nil

local EnemyCls = require("Enemy")
local enemy = nil
local enemies = nil
local spawnRate = 0.5
local spawnCountdown = 0

local BulletsCls = require("Bullets")
local bullets = nil

local AssetsManager = require("AssetsManager")
local Model = require("Model")

local SpacePartitionCls = require("SpacePartition")
local spacePartion = nil

local LEFT_KEY = "left"
local RIGHT_KEY = "right"
local UP_KEY = "up"
local DOWN_KEY = "down"

local function spawnEnemy(dt)
    if spawnCountdown <= 0 then
        spawnCountdown = 1 / spawnRate
        local newEnemy = EnemyCls.new(Model.enemyL1Params)

        objectManager.enemies:addObject(newEnemy)
    else
        spawnCountdown = spawnCountdown - dt
    end
end

function love.load()
    print("love.load")
    AssetsManager.init()
    Model.init()

    stars = StarsCls.new(Model.starsParams)
    ship = ShipCls.new(Model.shipParams)

    local objectManagerParams = { player = ship }
    objectManager = ObjectManagerCls.new(objectManagerParams)

    spacePartion = SpacePartitionCls.new()
end

function love.update(dt)
    stars:update(dt)

    objectManager:update(dt)
    spawnEnemy(dt)


    spacePartion:updateSpaceMatrix({ ship }, dt)
    --spacePartion:storeObjectIntoSpaceMatrix(ship)
end

function love.draw()


    --love.graphics.draw(AssetsManager.sprites.explosion, 0, 20)


    --note the function on the instance is called with a : rather than a .
    --calling a function with a : passes the calling instance as reference into the funciton, allowing you to use "self"
    stars:draw()

    objectManager:draw()
    spacePartion:draw()


    --Show current FPS
    local fps = love.timer.getFPS()
    love.graphics.print("FPS : " .. fps, 0, 0)
end

function love.keypressed(key)
    print(key)
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
