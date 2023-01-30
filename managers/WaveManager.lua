local Model = require("Model")
local ScoreManager = require("ScoreManager")
local ObjectManager = require("ObjectManager")
local ObjectPool = require("ObjectPool")

local wave1 = {
    waveNumber = 1,
    durationBetweenInnerWaves = 5,
    durationAfterWave = 10,
    waveScoreValue = 100,
    spaceBetweenEnemies = 20,
    innerWaves = {
        { 0, 1, 1, 0, 1, 1, 0 },
        { 1, 0, 0, 1, 1, 0, 1 },
        { 1, 1, 1, 0, 1, 1, 1 },
        { 0, 0, 0, 2, 0, 0, 0 }
    }
}
local wave2 = {
    waveNumber = 2,
    durationBetweenInnerWaves = 5,
    durationAfterWave = 7,
    waveScoreValue = 100,
    spaceBetweenEnemies = 20,
    innerWaves = {
        { 0, 2, 1, 0, 2, 1, 0 },
        { 1, 0, 2, 0, 1, 0, 1 },
        { 1, 1, 1, 0, 1, 1, 1 }
    }
}
local wave3 = {
    waveNumber = 3,
    durationBetweenInnerWaves = 4,
    durationAfterWave = 7,
    waveScoreValue = 100,
    spaceBetweenEnemies = 20,
    innerWaves = {
        { 0, 2, 2, 0, 2, 2, 0 },
        { 1, 0, 2, 0, 2, 0, 1 },
        { 1, 2, 2, 0, 2, 1, 1 }
    }
}

local allWaves = {
    wave1, wave2, wave3
}

local WaveManager = {}

function WaveManager:init()
    self.waves = allWaves

    self.innerWaveCooldown = 3 --cooldown between InnerWaves or waves
    self.waveCooldown = 0 --cooldown between Waves or waves

    self.currentWaveIndex = 1
    self.currentInnerWaveIndex = 0
    self.spaceBetweenEnemies = 20

    self.maxWaveIndex = #self.waves
    self.maxInnerWaveIndex = #self.waves[self.currentWaveIndex].innerWaves

    self.newWaveLoaded = false
    self.gameWon = false
end

function WaveManager:isGameWon()
    return self.gameWon
end

function WaveManager:updateScore()
    ScoreManager:incrementScore(self.waves[self.currentWaveIndex].waveScoreValue)
end

function WaveManager:loadNextWave()
    self.currentWaveIndex = self.currentWaveIndex + 1

    if self.currentWaveIndex > self.maxWaveIndex then
        self.gameWon = true

        self.currentWaveIndex = self.maxWaveIndex
        self.currentInnerWaveIndex = #self.waves[self.currentWaveIndex].innerWaves
        return
    end

    self.maxInnerWaveIndex = #(self.waves[self.currentWaveIndex].innerWaves)
    self.currentInnerWaveIndex = 1

    self.waveCooldown = self.waves[self.currentWaveIndex - 1].durationAfterWave
    self.innerWaveCooldown = self.waves[self.currentWaveIndex].durationBetweenInnerWaves
end

function WaveManager:loadNextInnerWave()
    self.currentInnerWaveIndex = self.currentInnerWaveIndex + 1

    --If wave cleared load next wave
    if self.currentInnerWaveIndex > self.maxInnerWaveIndex then
        WaveManager:updateScore() -- we cleared a wave, incrementScore
        WaveManager:loadNextWave()
        self.newWaveLoaded = true
    else
        self.newWaveLoaded = false
        self.innerWaveCooldown = self.waves[self.currentWaveIndex].durationBetweenInnerWaves
    end

    return self.newWaveLoaded
end

function WaveManager:spawnEnemyCentral(enemyType, lastPosition) -- returns last enemyPos
    local newPosition = { x = lastPosition.x, y = lastPosition.y }

    if enemyType == 0 then
        return newPosition
    end

    local newEnemy = ObjectPool:getEnemy(enemyType)
    newEnemy:setPosition(newPosition)
    ObjectManager.enemies:addObject(newEnemy)

    return newPosition
end

function WaveManager:spawnEnemyRight(enemyType, lastPosition) -- returns last enemyPos
    --!Should change if enemies different in size
    local newPostionX = lastPosition.x + self.spaceBetweenEnemies + Model.enemyL1Params.asset:getWidth()
    local newPositionY = lastPosition.y
    local newPosition = { x = newPostionX, y = newPositionY }

    if enemyType == 0 then
        return newPosition
    end

    local newEnemy = ObjectPool:getEnemy(enemyType)

    if newPosition.x > (Model.stage.stageWidth - newEnemy.dimention.width) then
        newPosition.x = Model.stage.stageWidth
        return newPosition
    end

    newEnemy:setPosition(newPosition)
    ObjectManager.enemies:addObject(newEnemy)

    return newPosition
end

function WaveManager:spawnEnemyLeft(enemyType, lastPosition) -- returns last enemyPos
    --!Should change if enemies different in size
    local newPostionX = lastPosition.x - self.spaceBetweenEnemies - Model.enemyL1Params.asset:getWidth()
    local newPositionY = lastPosition.y
    local newPosition = { x = newPostionX, y = newPositionY }

    if enemyType == 0 then
        return newPosition
    end

    local newEnemy = ObjectPool:getEnemy(enemyType)

    if newPosition.x < newEnemy.dimention.width then
        newPosition.x = 0
        return newPosition
    end

    newEnemy:setPosition(newPosition)
    ObjectManager.enemies:addObject(newEnemy)

    return newPosition
end

function WaveManager:spawnEnemies()
    local innerWave = self.waves[self.currentWaveIndex].innerWaves[self.currentInnerWaveIndex]
    local innerWaveWidth = #innerWave
    local leftIndex, rightIndex, centralIndex

    if innerWaveWidth % 2 == 0 then
        leftIndex = innerWaveWidth / 2
        rightIndex = innerWaveWidth / 2 + 1
    else
        centralIndex = math.ceil(innerWaveWidth / 2)
        leftIndex = centralIndex - 1
        rightIndex = centralIndex + 1
    end

    local screenCenter = Model.stage.stageWidth / 2
    local centralPosition = { x = screenCenter, y = 0 }
    local lastLeftPosition = centralPosition
    local lastRightPosition = centralPosition

    --Create central enemy
    if centralIndex ~= nil then
        local enemyType = innerWave[centralIndex]
        WaveManager:spawnEnemyCentral(enemyType, centralPosition)
    else
        lastLeftPosition.x = lastLeftPosition.x + Model.enemyL1Params.asset:getWidth() / 2
        lastRightPosition.x = lastLeftPosition.x - Model.enemyL1Params.asset:getWidth() / 2
    end

    --Create left enemies
    while (lastLeftPosition.x > 0) and (leftIndex > 0) do
        local enemyType = innerWave[leftIndex]
        leftIndex = leftIndex - 1

        lastLeftPosition = WaveManager:spawnEnemyLeft(enemyType, lastLeftPosition)
    end

    --Create right enemies
    while (lastRightPosition.x < Model.stage.stageWidth) and (rightIndex <= innerWaveWidth) do
        local enemyType = innerWave[rightIndex]
        rightIndex = rightIndex + 1

        lastRightPosition = WaveManager:spawnEnemyRight(enemyType, lastRightPosition)
    end
end

function WaveManager:update(dt)
    --If there are no waves
    if #self.waves == 0 then
        return
    end

    if self.gameWon == true then
        return
    end

    --Just check if there are no innerWaves
    local innerWaves = self.waves[self.currentWaveIndex].innerWaves
    if innerWaves == nil or #innerWaves == 0 then
        WaveManager:loadNextWave()
        return
    end

    if self.newWaveLoaded then
        if (self.waveCooldown <= 0) then
            --1)Load new innerWave
            WaveManager:loadNextInnerWave()
            if self.gameWon then
                return
            end
            --2)Create enemies
            WaveManager:spawnEnemies()
        else
            self.waveCooldown = self.waveCooldown - dt
        end
    else
        if (self.innerWaveCooldown <= 0) then
            --1)Load new innerWave
            WaveManager:loadNextInnerWave()
            if self.gameWon then
                return
            end
            --2)Create enemies
            WaveManager:spawnEnemies()
        else
            self.innerWaveCooldown = self.innerWaveCooldown - dt
        end
    end
end

function WaveManager:draw()

    local font = love.graphics.newFont(20)
    local waveNum = self.currentWaveIndex
    local innerWaveNum = self.currentInnerWaveIndex

    local waveText = "Wave " .. waveNum .. "." .. innerWaveNum

    waveText = love.graphics.newText(font, { { 1, 1, 1 }, waveText })
    local waveTextPositionX = Model.stage.stageWidth / 2 - waveText:getWidth() / 2
    local waveTextPositionY = 0
    love.graphics.draw(waveText, waveTextPositionX, waveTextPositionY)
end

return WaveManager

--[[
    Update function will check if the spawner timer is 0 and then spawn one inner wave and
    return the list of sawn enemies
]]


--[[
    Every wave should have 
    wave = {
        waveNumber = 1
        durationBetweenInnerWaves = seconds
        durationAfterWave = seconds, before new wave starts
        scoreValueOfWaveClear = 100
        wave = {
            {0, 1, 1, 0, 1, 1, 0},
            {1, 0, 1, 0, 1, 0, 1},
            {1, 1, 1, 0, 1, 1, 1}
        } -> order of enemies in wave
    }

    when we draw enemies we start from the middle elem and go left and right 
    so if there is no space some enemies are drone

    number represents the enemy level (1 - lowest)
]]


--[[ Enemy creating
    createEnemy(enemyType){
        enemyDatabase[enemyType].createEnemy(position)
    }

    this should return a struct that has
    {
        EnemyClass of the enemy, and params
        We need to change position of params and call EnemyClass.new(with new params)
    }
]]
