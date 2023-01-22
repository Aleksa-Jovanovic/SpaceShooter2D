LocalMath = {}

--Transforms direciton Vector (ai, bj) to radius
function LocalMath.calculateAngleFromDirectionVector(directionVector)
    local angle = 0

    --Case when there is no movement
    if directionVector.x == 0 and directionVector.y == 0 then
        return angle
    end
    --Case when there is no movement on X axis
    if directionVector.x == 0 then
        if directionVector.y > 0 then
            angle = angle + math.pi
        end

        return angle
    end
    --Case when there is no movement on Y axis
    if directionVector.y == 0 then
        if (directionVector.x > 0) then
            angle = angle + math.pi / 2
        else
            angle = angle - math.pi / 2
        end

        return angle
    end

    --Calcualteing the exact angle
    local horizontalComp = 1 / directionVector.x
    local verticalComp = 1 / directionVector.y
    angle = math.atan(verticalComp / horizontalComp)

    if directionVector.x >= 0 and directionVector.y >= 0 then --Quadrant I V
        angle = math.pi - angle
    elseif directionVector.x <= 0 and directionVector.y >= 0 then --Quadrant II
        angle = math.pi - angle
    elseif directionVector.x <= 0 and directionVector.y <= 0 then --Quadrant III V
        angle = 2 * math.pi - angle
    elseif directionVector.x >= 0 and directionVector.y <= 0 then --Quadrant IV
        angle = 2 * math.pi - angle
    end

    return angle
end

--Tranforms radius to direciton Vector (ai, bj)
function LocalMath.calculateDirectionVectorFromAngle(angle)
    local directionVector = {}

    directionVector.x = math.sin(angle)
    directionVector.y = -math.cos(angle)

    return directionVector
end

--Returns true if vector already exists in the vector array
function LocalMath.isVectorContainedInContainer(vector, container)
    for _, elem in ipairs(container) do
        if (vector.x == elem.x) and (vector.y == elem.y) then
            return true
        end
    end

    return false
end

return LocalMath
