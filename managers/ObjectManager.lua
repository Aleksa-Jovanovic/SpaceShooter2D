local Model = require("Model")
local ScoreManager = require("ScoreManager")
local ObjectPool = require("ObjectPool")
local LocalMath = require("LocalMath")

local ShipCls = require("Ship")
local BulletsCls = require("Bullets")
local ExplosionCls = require("Explosion")
local LiveObjectArrayCls = require("LiveObjectArray")

local ObjectManager = {}

--ObjectManager needs player to initialize
function ObjectManager:init(params)
    self.player = params.player or ShipCls.new(Model.shipParams)
    self.enemies = LiveObjectArrayCls.new()
    self.bullets = BulletsCls.new()

    self.explosions = LiveObjectArrayCls.new()

    self.scoreManager = ScoreManager
end

--BEGIN -> Getters for arrays
function ObjectManager:getEnemies()
    return self.enemies.liveObjectArray
end

function ObjectManager:getEnemyBullets()
    return self.bullets.enemyBulletsArray
end

function ObjectManager:getPlayerBullets()
    return self.bullets.playerBulletsArray
end

--END -> Getters for arrays

function ObjectManager:isPlayerAlive()
    return self.player:isAlive()
end

local function fire(objectManager, dt)
    local playerBullets = objectManager.player:fireBullets(dt)
    if (playerBullets) then
        for i = 1, #playerBullets, 1 do
            objectManager.bullets:addPlayerBullet(playerBullets[i])
        end
    end


    for index, enemy in pairs(objectManager.enemies.liveObjectArray) do
        local enemyBullets = enemy:fireBullets(dt)
        if (enemyBullets) then
            for i = 1, #enemyBullets, 1 do
                objectManager.bullets:addEnemyBullet(enemyBullets[i])
            end
        end
    end
end

function ObjectManager:createExplosion(explodingObject)
    local positionOfExplosion = explodingObject.position

    local explosionParams = Model.explosionParams
    explosionParams.position = positionOfExplosion

    local newExplosion = ExplosionCls.new(explosionParams)
    self.explosions:addObject(newExplosion)
end

--TODO: create a function to add a power up to the map when enemy is destroyed
function ObjectManager:createPowerUp(destroyedEnemy)
end

function ObjectManager:handleRemovedEnemies(removedEnemies)
    for _, destroyedEnemy in pairs(removedEnemies.inScreenViewObjects) do
        self.scoreManager:incrementScore(destroyedEnemy.scoreValue)

        ObjectManager:createExplosion(destroyedEnemy)
        ObjectManager:createPowerUp(destroyedEnemy)

        ObjectPool:returnEnemy(destroyedEnemy)
    end

    for _, escapedEnemy in pairs(removedEnemies.outOfScreenViewObjects) do
        self.scoreManager:decrementScore(escapedEnemy.scoreValue)

        ObjectPool:returnEnemy(escapedEnemy)
    end
end

function ObjectManager:handleRemovedBullets(removedBullets)
    for _, enemyBullet in pairs(removedBullets.enemyBullets) do
        ObjectPool:returnBullet(enemyBullet)
    end

    for _, playerBullet in pairs(removedBullets.playerBullets) do
        ObjectPool:returnBullet(playerBullet)
    end
end

function ObjectManager:update(dt)
    self.player:update(dt)
    local removedEnemies = self.enemies:update(dt)
    local removedBullets = self.bullets:update(dt)

    fire(self, dt)

    --!Every destroyed object should be returned to the ObjectPool
    ObjectManager:handleRemovedEnemies(removedEnemies)
    ObjectManager:handleRemovedBullets(removedBullets)
    self.explosions:update(dt)
end

function ObjectManager:draw()
    self.bullets:draw()

    self.player:draw()
    self.enemies:draw()

    self.explosions:draw()
end

return ObjectManager
