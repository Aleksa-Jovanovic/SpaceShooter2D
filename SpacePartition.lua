local classes = require("classes")
local SpacePartition = classes.class()

local Model = require("Model")
local LocalMath = require("LocalMath")

function SpacePartition:init()
    self.colNum = Model.spacePartitionParam.colNumber
    self.rowNum = Model.spacePartitionParam.rowNumber
    self.stageWidth = Model.stage.stageWidth
    self.stageHeight = Model.stage.stageHeight

    --How wide and heigh is each elem in matrix
    self.cellWidt = math.ceil(self.stageWidth / self.colNum)
    self.cellHeight = math.ceil(self.stageHeight / self.rowNum)

    --Maybe we dont need to update spaceMatrix on every love.update(dt)
    --It can update once every 1/updateRate
    self.updateRate = Model.spacePartitionParam.updateRate or 10
    self.updateCooldown = 0

    --Each element of matrix contains objects that are in that part of the screen
    self.spaceMatrix = self:reInitSpaceMatric()
end

--Fast way to empty a matrix and just create a new one, maybe its faster to iterate and set everything to nils
function SpacePartition:reInitSpaceMatric()
    self.spaceMatrix = {}
    for i = 1, self.rowNum, 1 do
        self.spaceMatrix[i] = {}
        for j = 1, self.colNum, 1 do
            self.spaceMatrix[i][j] = {}
        end
    end

    return self.spaceMatrix
end

--Returns index of a cell that contains that position(x,y)
function SpacePartition:calculateIndexOfPoint(position)
    local x = position.x or 0
    local y = position.y or 0
    local col = 1
    local row = 1

    while x > self.cellWidt do
        x = x - self.cellWidt
        col = col + 1
    end

    while y > self.cellHeight do
        y = y - self.cellHeight
        row = row + 1
    end

    return { row = row, col = col }
end

--Returns indexes of all cells that could contain object whit that position
function SpacePartition:calculateIndexesOfObject(object)
    local objectPosition = object.position
    local objectDimention = object.dimention

    local leftTopCorner = { x = objectPosition.x - objectDimention.width / 2,
        y = objectPosition.y - objectDimention.height / 2 }
    local leftBottomCorner = { x = objectPosition.x - objectDimention.width / 2,
        y = objectPosition.y + objectDimention.height / 2 }
    local rightTopCorner = { x = objectPosition.x + objectDimention.width / 2,
        y = objectPosition.y - objectDimention.height / 2 }
    local rightBottomCorner = { x = objectPosition.x + objectDimention.width / 2,
        y = objectPosition.y + objectDimention.height / 2 }

    local conrners = { leftTopCorner, leftBottomCorner, rightTopCorner, rightBottomCorner }
    local differentIndexes = {}
    for _, corner in ipairs(conrners) do
        local index = self:calculateIndexOfPoint({ x = corner.x, y = corner.y })

        if (not LocalMath.isIndexContainedInContainer(index, differentIndexes)) then
            table.insert(differentIndexes, index)
        end
    end

    return differentIndexes
end

function SpacePartition.calculatePreciseIndex(objectPosition, stageWith)
    return objectPosition.y * (stageWith) + objectPosition.x
end

--TODO: check and see should you use some kind of preciseIndex (ID could be used as an index/hash)
function SpacePartition:storeObjectIntoSpaceMatrix(object)
    local objectIndexes = self:calculateIndexesOfObject(object)

    for _, index in pairs(objectIndexes) do
        local i = index.row
        local j = index.col
        local preciseIndex = SpacePartition.calculatePreciseIndex(object.position, self.stageWidth)

        if (self.spaceMatrix[i] ~= nil) then
            table.insert(self.spaceMatrix[i][j], object)
        end
    end
end

function SpacePartition:updateSpaceMatrix(objectsToProcess, dt)
    dt = dt or love.timer.getDelta()

    if not _G.USE_SPACE_PARTITION then
        return nil
    end

    if objectsToProcess == nil then
        return nil
    end

    if self.updateCooldown <= 0 then
        self.updateCooldown = 1 / self.updateRate

        --Update
        print("Updateing spacePartition!")

        --Clear old matrix and then add objects
        self:reInitSpaceMatric()
        for i = 1, #objectsToProcess, 1 do
            self:storeObjectIntoSpaceMatrix(objectsToProcess[i])
        end
    else
        print("Not updateing spacePartition, cooldows = " .. self.updateCooldown)
        self.updateCooldown = self.updateCooldown - dt
    end

    return self.spaceMatrix
end

function SpacePartition:getCollideCandidates(collidingObject)
    local collideCandidates = {}

    local collidingObjectIndexes = self:calculateIndexesOfObject(collidingObject)

    for _, index in pairs(collidingObjectIndexes) do
        local i = index.row
        local j = index.col

        for _, collideCandidate in pairs(self.spaceMatrix[i][j]) do
            table.insert(collideCandidates, collideCandidate)
        end
    end

    return collideCandidates
end

function SpacePartition:draw()

    self:drawSpaceGrid()

end

function SpacePartition:drawSpaceGrid()
    if _G.SHOW_SPACE_GRID then
        local currentX = self.cellWidt
        local currentY = self.cellHeight

        while currentX < self.stageWidth do
            love.graphics.line(currentX, 0, currentX, self.stageHeight)
            currentX = currentX + self.cellWidt
        end

        while currentY < self.stageHeight do
            love.graphics.line(0, currentY, self.stageWidth, currentY)
            currentY = currentY + self.cellHeight
        end
    end
end

return SpacePartition
