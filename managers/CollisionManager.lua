local Model = require("Model")
local LocalMath = require("LocalMath")

local ObjectManager = require("ObjectManager")
local SpacePartitionCls = require("SpacePartition")

local CollisionManager = {}

function CollisionManager:init()
    self.objectManager = ObjectManager
    self.spacePartitionEnemies = SpacePartitionCls.new()
end

local function checkCollision(object1, object2)
    --Double check if some objects are invalid, no need to checkCollision, should be removed in the end
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

local function checkCollision_PlayerBullets_EnemyShip_Default(ObjectManager)
    for enemyIndex, enemy in pairs(ObjectManager:getEnemies()) do
        --if not enemy.isValidInstance then --if previous bullet invalidated this enemy
        --  goto continueInvalidEnemy --goto not good option but i didn't want to use nested ifs and there is no continue
        --end
        for bulletIndex, playerBullet in pairs(ObjectManager:getPlayerBullets()) do
            if (checkCollision(playerBullet, enemy)) then
                enemy:takeDamage(playerBullet.damage)
                playerBullet:destroyBullet()
                break
            end
        end
        --::continueInvalidEnemy::
    end
end

local function checkCollision_PlayerBullets_EnemyShip_SpacePartition(ObjectManager, spacePartition)
    for bulletIndex, playerBullet in pairs(ObjectManager:getPlayerBullets()) do
        for _, enemyCandidate in pairs(spacePartition:getCollideCandidates(playerBullet)) do
            if (checkCollision(playerBullet, enemyCandidate)) then
                enemyCandidate:takeDamage(playerBullet.damage)
                playerBullet:destroyBullet()
                break --bullet hit enemy and was destroyed, break from enemy scan
            end
        end

    end
end

local function checkCollision_PlayerShip_EnemyShip_Default(ObjectManager)
    for enemyIndex, enemyShip in pairs(ObjectManager:getEnemies()) do
        if (checkCollision(enemyShip, ObjectManager.player)) then
            ObjectManager.player:takeDamage(enemyShip.health)
            enemyShip:takeDamage(enemyShip.health)
        end
    end
end

local function checkCollision_EnemyBullet_PlayerShip_Default(ObjectManager)
    for bulletIndex, enemyBullet in pairs(ObjectManager:getEnemyBullets()) do
        if (checkCollision(enemyBullet, ObjectManager.player)) then
            ObjectManager.player:takeDamage(enemyBullet.damage)
            enemyBullet:destroyBullet()
        end
    end
end

function CollisionManager:update(dt)
    --Check collision playerBullet <-> enemyShip
    if _G.USE_SPACE_PARTITION then
        self.spacePartitionEnemies:updateSpaceMatrix(self.objectManager:getEnemies(), dt)
        checkCollision_PlayerBullets_EnemyShip_SpacePartition(self.objectManager, self.spacePartitionEnemies)
    else
        checkCollision_PlayerBullets_EnemyShip_Default(self.objectManager)
    end

    --Check collision enemyBullet <-> playerShip
    checkCollision_EnemyBullet_PlayerShip_Default(self.objectManager)

    --Checl collision enemyShip <-> playerShip
    checkCollision_PlayerShip_EnemyShip_Default(self.objectManager)

    --Checl collision with powerUps!!
    --TODO create power ups when you kill enemies they drop powerUps and explode
end

function CollisionManager:draw()
    self.spacePartitionEnemies:draw()
end

return CollisionManager
