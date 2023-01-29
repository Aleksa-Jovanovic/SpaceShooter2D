local classes = require("classes")
local ItemPool = classes.class()

local Model = require("Model")

---BEGIN -> ItemPool helperClass
local OBJECT_FREE = true
local OBJECT_NOT_FREE = false

function ItemPool:init(params)
    self.objectArray = {}
    self.flagArray = {} --Flag array TRUE (object free), FLASE(object not free)

    self.objectCls = params.objectClass
    self.objectInitParams = params.objectInitParams
end

function ItemPool:createNewObject()
    local newObject = self.objectCls.new(self.objectInitParams)
    self.objectArray[newObject.objectID] = newObject
    self.flagArray[newObject.objectID] = OBJECT_FREE

    return newObject
end

function ItemPool:getNextFreeObject()
    local freeObjectKey = 0

    for key, objectFlag in pairs(self.flagArray) do
        if objectFlag == OBJECT_FREE then
            freeObjectKey = key
        end
    end

    --If there is free object return it
    if freeObjectKey ~= 0 then
        self.flagArray[freeObjectKey] = OBJECT_NOT_FREE

        return self.objectArray[freeObjectKey]
    end

    --If there is no free object create anew one, save it and return it
    if freeObjectKey == 0 then
        local newObject = self:createNewObject()
        self.flagArray[newObject.objectID] = OBJECT_NOT_FREE

        return self.objectArray[newObject.objectID]
    end
end

function ItemPool:resetObject(object)
    --!Some times objects gets removed from objectArray, not sure why
    if self.objectArray[object.objectID] ~= nil then
        self.objectArray[object.objectID]:init(self.objectInitParams)
    else
        self.objectArray[object.objectID] = object
        self.objectArray[object.objectID]:init(self.objectInitParams)
    end
end

function ItemPool:returnObject(object)
    self.flagArray[object.objectID] = OBJECT_FREE
    self:resetObject(object)
end

---END -> ItemPool helperClass

--BEGIN -> ObjectPool Singleton
local ObjectPool = {}

function ObjectPool:init()

    local BulletCls = require("Bullet")
    local bulletPoolParams = { objectClass = BulletCls, objectInitParams = Model.bulletParams }
    self.bulletPool = ItemPool.new(bulletPoolParams)

    local EnemyL1Cls = require("Enemy")
    local enemyL1PoolParams = { objectClass = EnemyL1Cls, objectInitParams = Model.enemyL1Params }
    self.enemyPool = {
        ItemPool.new(enemyL1PoolParams), --L1
        ItemPool.new(enemyL1PoolParams) --L2 for now same as L1
    }

end

function ObjectPool:getBullet()
    return self.bulletPool:getNextFreeObject()
end

function ObjectPool:returnBullet(bullet)
    self.bulletPool:returnObject(bullet)
end

function ObjectPool:getEnemy(enemyType)
    return self.enemyPool[enemyType]:getNextFreeObject()
end

function ObjectPool:returnEnemy(enemy)
    self.enemyPool[enemy.level]:returnObject(enemy)
end

return ObjectPool
--END -> ObjectPool Singleton
