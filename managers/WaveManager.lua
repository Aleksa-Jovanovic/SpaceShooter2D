local Model = require("Model")

local WaveManager = {}

local wave1 = {
    waveNumber = 1,
    durationBetweenInnerWaves = 5,
    durationAfterWave = 10,
    waveScoreValue = 100,
    innerWaves = {
        { 0, 1, 1, 0, 1, 1, 0 },
        { 1, 0, 1, 0, 1, 0, 1 },
        { 1, 1, 1, 0, 1, 1, 1 }
    }
}
local wave2 = {
    waveNumber = 2,
    durationBetweenInnerWaves = 5,
    durationAfterWave = 10,
    waveScoreValue = 100,
    innerWaves = {
        { 0, 1, 1, 0, 1, 1, 0 },
        { 1, 0, 1, 0, 1, 0, 1 },
        { 1, 1, 1, 0, 1, 1, 1 }
    }
}
local wave3 = {
    waveNumber = 3,
    durationBetweenInnerWaves = 5,
    durationAfterWave = 10,
    waveScoreValue = 100,
    innerWaves = {
        { 0, 1, 1, 0, 1, 1, 0 },
        { 1, 0, 1, 0, 1, 0, 1 },
        { 1, 1, 1, 0, 1, 1, 1 }
    }
}

local allWaves = {
    wave1, wave2, wave3
}

local function getClassForEnemyType(enemyType)
    if enemyType == 1 then
        return require("Ene")
    end
end

local function spawnEnemy(enemyType, position)
end

--TODO: add next wave countdown
function WaveManager:init()
    self.waves = allWaves

    self.spawnCooldown = 0 --cooldown between innerWaves or waves


    self.currentWave = self.waves[1].waveNumber
    self.currentInnerWave = 1
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
