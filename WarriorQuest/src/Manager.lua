require "Helper"

WarriorManager = List.new()
MonsterManager = List.new()
BossManager = List.new()

function findAliveMonster()
    for val = 1, List.getSize(MonsterManager) do
        if MonsterManager[val-1]._isalive == true then
            return MonsterManager[val-1]
        end                  
    end

    return 0
end

function findAliveWarrior()
    for val = 1, List.getSize(WarriorManager) do
        if WarriorManager[val-1]._isalive == true then
            return WarriorManager[val-1]
        end                  
    end  

    return 0
end

function findAliveBoss()
    for val = 1, List.getSize(BossManager) do
        if BossManager[val-1]._isalive == true then
            return BossManager[val-1]
        end                  
    end  

    return 0
end

function tooClose(object1, object2)
    local aaa = object1.sprite3d:getBoundingBox()
    local bbb = object2.sprite3d:getBoundingBox()

    local minDistance = (aaa.width + bbb.width)/2
    local startP = object1:getPosition3D()
    local endP = object2:getPosition3D()

    local tempDistance = cc.pGetDistance(cc.p(startP.x, startP.z), cc.p(endP.x, endP.z))
    if tempDistance < minDistance then
        local tempX, tempZ
        if startP.x > endP.x then
            tempX =  startP.x - endP.x                
        else
            tempX = endP.x - startP.x
        end

        if startP.z > endP.z then
            tempZ =  startP.z - endP.z                
        else
            tempZ = endP.z - startP.z
        end

        local ratio = (minDistance - tempDistance) / minDistance
        tempX = ratio * tempX
        tempZ = ratio * tempZ

        if startP.x > endP.x then
            startP.x = startP.x + tempX/2
            endP.x = endP.x - tempX/2
        else
            startP.x = startP.x - tempX/2
            endP.x = endP.x + tempX/2                                        
        end

        if startP.z > endP.z then
            startP.z = startP.z + tempZ/2
            endP.z = endP.z - tempZ/2
        else
            startP.z = startP.z - tempZ/2
            endP.z = endP.z + tempZ/2                                        
        end                

        object1:setPosition3D(startP)
        object2:setPosition3D(endP)
    end  
end

function collisionDetectWarrior(Object)
    for val = 1, List.getSize(WarriorManager) do
        local sprite = WarriorManager[val-1]
        if sprite._isalive == true and sprite ~= Object then
            tooClose(sprite, Object)
        end
    end

    for val = 1, List.getSize(MonsterManager) do
        local sprite = MonsterManager[val-1]
        if sprite._isalive == true and sprite ~= Object then
            tooClose(sprite, Object)
        end                  
    end 

    for val = 1, List.getSize(BossManager) do
        local sprite = BossManager[val-1]
        if sprite._isalive == true and sprite ~= Object then
            tooClose(sprite, Object)
        end
    end     
end