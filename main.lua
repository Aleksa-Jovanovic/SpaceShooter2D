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
_G.USE_SPACE_PARTITION = true --If the screen is large and there are a lot of objects it would benefit processing time

----INSTANTIATING A CLASS
local LiveObjectArrayCls = require("LiveObjectArray")
local StarsCls = require("Stars")
local stars = nil

local ObjectManager = require("ObjectManager")
local CollisionManager = require("CollisionManager")
--local objectManager = nil

local ShipCls = require("Ship") --import the class
local ship = nil

local EnemyCls = require("Enemy")
local spawnRate = 0.5
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
        local newEnemy = EnemyCls.new(Model.enemyL1Params)

        ObjectManager.enemies:addObject(newEnemy)
    else
        spawnCountdown = spawnCountdown - dt
    end
end

local function checkCollision(object1, object2)
    --Double check if some object is invalid, should be removed in the end
    if (not object1.isValidInstance) or (not object2.isValidInstance) then
        return false
    end

    local collider1 = { position = {}, dimention = {} }
    local collider2 = { position = {}, dimention = {} }

    collider1.position.x = object1.position.x - object1.dimention.width / 2
    collider1.position.y = object1.position.y - object1.dimention.height / 2
    collider1.dimention = object1.dimention

    collider2.position.x = object2.position.x - object2.dimention.width / 2
    collider2.position.y = object2.position.y - object2.dimention.height / 2
    collider2.dimention = object2.dimention

    if (collider1.position.x < collider2.position.x + collider2.dimention.width and
        collider1.position.x + collider1.dimention.width > collider2.position.x and
        collider1.position.y < collider2.position.y + collider2.dimention.height and
        collider1.position.y + collider1.dimention.height > collider2.position.y) then
        return true
    end
    return false
end

function love.load()
    print("love.load")
    AssetsManager.init()
    Model.init()

    --Create player
    stars = StarsCls.new(Model.starsParams)
    ship = ShipCls.new(Model.shipParams)

    --Init managers
    local objectManagerParams = { player = ship }
    ObjectManager:init(objectManagerParams)
    CollisionManager:init()


end

function love.update(dt)
    stars:update(dt)

    ObjectManager:update(dt)
    CollisionManager:update(dt)
    spawnEnemy(dt)

    --[[
--Enemy get hit
    for enemyIndex, enemy in pairs(ObjectManager.enemies.liveObjectArray) do
        if not enemy.isValidInstance then --if previous bullet invalidated this enemy
            goto continueInvalidEnemy --goto not good option but i didn't want to use nested ifs and there is no continue
        end

        for bulletIndex, bullet in pairs(ObjectManager.bullets.playerBulletsArray) do
            if (checkCollision(bullet, enemy)) then

                enemy:takeDamage(bullet.damage)
                bullet:destroyBullet()

                --objectManager.enemies:removeObject(enemyIndex)
                --objectManager.bullets:removePlayerBullet(bulletIndex)
                break
            end
        end
        ::continueInvalidEnemy::
    end

    --Plaeyr getHit

    for bulletIndex, bullet in pairs(ObjectManager.bullets.enemyBulletsArray) do
        if (checkCollision(bullet, ObjectManager.player)) then

            ship:takeDamage(bullet.damage)
            bullet:destroyBullet()
        end
    end
]]

end

function love.draw()
    --love.graphics.draw(AssetsManager.sprites.explosion, 0, 20)


    --note the function on the instance is called with a : rather than a .
    --calling a function with a : passes the calling instance as reference into the funciton, allowing you to use "self"
    stars:draw()

    ObjectManager:draw()
    CollisionManager:draw()

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
