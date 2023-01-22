local classes = require("classes")
local SpacePartition = classes.class()
local Model = require("Model")

function SpacePartition:init(params)
    self.colNum = Model.spacePartitionParam.colNumber
    self.rowNum = Model.spacePartitionParam.rowNumber
    self.stageWidth = Model.stage.stageWidth
    self.stageHeight = Model.stage.stageHeight

    --How wide and heigh is each elem in matrix
    self.cellWidt = math.ceil(self.stageWidth / self.colNum)
    self.cellHeight = math.ceil(self.stageHeight / self.rowNum)

    --Each element of matrix contains objects that are in that part of the screen
    self.spaceMatrix = {}
    for i = 1, self.rowNum, 1 do
        self.spaceMatrix[i] = {}
        for j = 1, self.colNum, 1 do
            self.spaceMatrix[i][j] = {}
        end
    end

end

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

    --print("Row : " .. row .. " Col : " .. col)
    return { row = row, col = col }
end

--Returns indexes of all elements that could contain object whit that position
function SpacePartition:calculateIndexesOfObject(object, objectPosition, objectDimention)
    local leftTopCorner = { x = objectPosition.x - objectDimention.width / 2,
        y = objectPosition.y - objectDimention.height / 2 }
    local leftBottomCorner = { x = objectPosition.x - objectDimention.width / 2,
        y = objectPosition.y + objectDimention.height / 2 }
    local rightTopCorner = { x = objectPosition.x + objectDimention.width / 2,
        y = objectPosition.y - objectDimention.height / 2 }
    local rightBottomCorner = { x = objectPosition.x + objectDimention.width / 2,
        y = objectPosition.y + objectDimention.height / 2 }

    local conrners = { leftTopCorner, leftBottomCorner, rightTopCorner, rightBottomCorner }

    for index, corner in ipairs(conrners) do
        local index = self:calculateIndexOfPoint({ x = corner.x, y = corner.y })
        local i = index.row
        local j = index.col

        self.spaceMatrix[i][j][objectPosition.y * (self.stageWidth - 1) + objectPosition.x] = object

        print(self.spaceMatrix[i][j][objectPosition.y * (self.stageWidth - 1) + objectPosition.x].tag)
    end
    print("---------------------------------------")
end

function SpacePartition:update(dt)

end

function SpacePartition:draw()

    self:drawSpaceGrid()

end

function SpacePartition:drawSpaceGrid()
    if (_G.SHOW_SPACE_GRID) then
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
