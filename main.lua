--this is how you require files in directories
package.path = package.path .. ";utils/?.lua;"
----------------------
--for debugging in zero brane, add breakpoints. be sure to activate "start debugging server" under "Project"
--require("mobdebug").start()

--this is to make prints appear right away in zerobrane
io.stdout:setvbuf("no")

--GLOBAL Variable
_G.SHOW_SPACE_GRID = true
_G.USE_SPACE_PARTITION = true --If the screen is large and there are a lot of objects it would benefit processing time

----INSTANTIATING A CLASS
local ShipCls = require("Ship") --import the class
local ship = nil

local LiveObjectArrayCls = require("LiveObjectArray")

local EnemyCls = require("Enemy")
local enemies = nil
local spawnRate = 1
local spawnCountdown = 0

require("BaseObject")
local StarsCls = require("Stars")
local stars = nil

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

        local newEnemy = EnemyCls.new(Model.enemyParams)

        --local bulletPositionVec = { x = self.position.x, y = self.position.y }
        --local bulletDirectionVec = self.calculateFireDirection(self)
        --newBullet:configureBullet(bulletPositionVec, bulletDirectionVec)

        --return newBullet
        enemies:addObject(newEnemy)
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
    bullets = BulletsCls.new()
    enemies = LiveObjectArrayCls.new()

    spacePartion = SpacePartitionCls.new()
end

local function fireBullets(dt)
    --FirePower
    --[[
        local playerBullet = ship:fireBullet(dt)
    if (playerBullet) then
        bullets:addPlayerBullet(playerBullet)
    end
    ]]
    local playerBullets = ship:angleShots(dt)
    if (playerBullets) then
        for i = 1, #playerBullets, 1 do
            bullets:addPlayerBullet(playerBullets[i])
        end
    end

    for index, enemy in ipairs(enemies.liveObjectArray) do
        local enemyBullet = enemy:fireBullet(dt)
        if enemyBullet then
            bullets:addEnemyBullet(enemyBullet)
        end
    end
end

function love.update(dt)
    stars:update(dt)

    ship:update(dt)
    --spawnEnemy(dt)
    --enemies:update(dt)
    fireBullets(dt)

    bullets:update(dt)

    spacePartion:update(dt)
    spacePartion:calculateIndexesOfObject(ship, ship.position, ship.dimention)
end

function love.draw()


    love.graphics.draw(AssetsManager.sprites.explosion, 0, 20)


    --note the function on the instance is called with a : rather than a .
    --calling a function with a : passes the calling instance as reference into the funciton, allowing you to use "self"
    stars:draw()
    bullets:draw()

    spacePartion:draw()

    ship:draw()
    enemies:draw()



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

--
--
