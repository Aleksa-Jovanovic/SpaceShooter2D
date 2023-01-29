local Model = require("Model")

local ScoreManager = {}

function ScoreManager:init()
    self.currentScore = 0
end

function ScoreManager:incrementScore(incScore)
    self.currentScore = self.currentScore + incScore
end

function ScoreManager:decrementScore(decScore)
    self.currentScore = self.currentScore - decScore
end

function ScoreManager:getScoreAsText()
    local font = love.graphics.newFont(30)
    local scoreText = "Score : " .. self.currentScore

    scoreText = love.graphics.newText(font, { { 0.868, 0.92, 0.32 }, scoreText })

    return scoreText
end

function ScoreManager:draw()
    local scoreText = ScoreManager:getScoreAsText()
    local positionX = Model.stage.stageWidth - scoreText:getWidth()

    love.graphics.draw(scoreText, positionX, 0)
end

return ScoreManager
