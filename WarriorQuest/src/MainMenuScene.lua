require "Cocos2d"

--declare a class extends scene
local MainMenuScene = class("MainMenuScene",function()
    return cc.Scene:create()
end
)

--constructor init member variable
function MainMenuScene:ctor()
    --get win size
    self.size = cc.Director:getInstance():getVisibleSize()
end

function MainMenuScene.create()
    local scene = MainMenuScene.new()
    --add layer
    local layer = scene:createLayer()
    scene:addChild(layer)
    
    return scene
end

--crate a main layer
function MainMenuScene:createLayer()
    local mainLayer = cc.Layer:create()
    
    --background
    local bg = cc.Sprite:create("mainmenu_ground2.jpg")
    bg:setPosition(self.size.width/2,self.size.height/2)
    mainLayer:addChild(bg,2)
    
    --add cloud
    self:addCloud(mainLayer)
    
    
    return mainLayer
end

function MainMenuScene:addCloud(layer)
    --cloud
    local cloud1 = cc.Sprite:create("cloud1.png")
    local cloud2 = cc.Sprite:create("cloud3.png")
    local cloud3 = cc.Sprite:create("cloud2.png")
    
    --setPosition
    cloud1:setPosition(self.size.width*0.38,self.size.height*0.7)
    cloud2:setPosition(self.size.width*0.65,self.size.height*0.83)
    cloud3:setPosition(self.size.width*0.9,self.size.height*0.7)
    
    --add to layer
    layer:addChild(cloud1,3)
    layer:addChild(cloud2,3)
    layer:addChild(cloud3,3)
    local clouds = {cloud1,cloud2,cloud3}
    
    --move cloud
    local function cloud_move()
        --set cloud move speed
        local offset = {-1,-3,-2}
        for i,v in pairs(clouds) do
            local point = v:getPositionX()+offset[i]
            if(point<-v:getContentSize().width/2) then
                point = self.size.width+v:getContentSize().width/2
            end
            v:setPositionX(point)
        end

    end
    self.scheduleCloudMove = cc.Director:getInstance():getScheduler():scheduleScriptFunc(cloud_move,1/60,false)
end


return MainMenuScene