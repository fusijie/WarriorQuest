require "Cocos2d"

local Hero = class ("Hero",function ()
	return cc.Node:create()
end)

function Hero.create()
    local hero = Hero.new()
    return hero
end

function Hero:ctor()
	self.isalive = true
	self.blood = 1000
	self.attack = 100
	self.defense = 100
end

function Hero:walk()
	
end

function Hero:attack()

end 

function Hero:skill()
	
end

function Hero:defend()
	
end

function Hero:hurt(blood)
    self.blood = self.blood - blood
    if self.blood <= 0 then
        self.blood = 0
        self.isalive = false
    end
end

function Hero:dead()

end

function Hero:isAlive()
    return self.isalive
end

return Hero