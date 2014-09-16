require "Cocos2d"
require "Cocos2dConstants"

local ActivateGame = class("ActivateGame",
function ()
    return cc.Scene:create()
end
)

function ActivateGame:ctor()
    self.size = cc.Director:getInstance():getWinSize()
end

function ActivateGame:create()
    local activate = ActivateGame:new()
    local layer = activate:init()
    activate:addChild(layer)
    return activate
end

function ActivateGame:init()
    local layer = cc.Layer:create()

    local player = cc.Sprite3D:create("Sprite3DTest/girl.c3b")
    player:setPosition3D({x=self.size.width/2,y=self.size.height*0.45,z=0})
    player:setRotation3D({x=0,y=90,z=0})
    player:setCameraMask(2)
    layer:addChild(player)
    
    local animation = cc.Animation3D:create("Sprite3DTest/girl.c3b")
    local animate = cc.Animate3D:create(animation)
    player:runAction(cc.RepeatForever:create(animate))
    
    --create camera
    local camera = cc.Camera:createPerspective(40,self.size.width/self.size.height,1,1000)
    camera:setPosition3D({x=self.size.width*0.2,y=self.size.height*0.9,z=0})
    camera:lookAt(player:getPosition3D(),{x=0,y=1,z=0})
    camera:setCameraFlag(2)
    layer:addChild(camera)
    
    --schedule
    local offset = 1
    local function schedule_callback()
        local x = camera:getPositionX()
        if x <= -400 then
            offset = -1
        elseif x>=self.size.width*0.15 then
            offset = 1
        end
        camera:setPositionX(x-offset)
        camera:lookAt(player:getPosition3D(),{x=0,y=1,z=0})
    end
    cc.Director:getInstance():getScheduler():scheduleScriptFunc(schedule_callback,0.005,false)

    --create player2
    local player2 = cc.Sprite3D:create("Sprite3DTest/girl.c3b")
    player2:setPosition3D({x=self.size.width*0.2,y=self.size.height*0.45,z=0})
    player2:setRotation3D({x=0,y=50,z=0})
    player2:setCameraMask(4)
    layer:addChild(player2)

    local animation2 = cc.Animation3D:create("Sprite3DTest/girl.c3b")
    local animate2 = cc.Animate3D:create(animation2)
    player2:runAction(cc.RepeatForever:create(animate2))
    
    --create camera2
    local camera2 = cc.Camera:createPerspective(50,self.size.width/self.size.height,1,1000)
    camera2:setPosition3D({x=self.size.width*0.2,y=self.size.height*0.45,z=300})
    camera2:lookAt(player2:getPosition3D(),{x=0,y=1,z=0})
    camera2:setCameraFlag(4)
    layer:addChild(camera2)
    
    player2:setPositionX(self.size.width*0.08)
    player2:setPositionY(self.size.height*0.4)
    
    --schedule2
    local point_y = 0.1
    local point_z = 0.1
    local schedule2_callback = function ()
        if camera2:getPositionY() >= 350 then
            point_y = point_y - 0.2
        elseif camera2:getPositionY() <= self.size.height*0.45 then
            point_y = point_y + 0.2
        end
        
        if camera2:getPositionZ() <= 220 then
            point_z = point_z - 0.2
        elseif camera2:getPositionZ() >= 330 then
            point_z = point_z + 0.2
        end
        camera2:setPositionY(point_y+camera2:getPositionY())
        camera2:setPositionZ(camera2:getPositionZ()-point_z)
        
    end
    cc.Director:getInstance():getScheduler():scheduleScriptFunc(schedule2_callback,0.01,false)
    

    return layer
end
        
  
        
        
        
        

return ActivateGame
