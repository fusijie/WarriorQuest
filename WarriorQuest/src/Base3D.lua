require "Helper"

EnumType = 
{ 
    "BASE",
    "HERO", 
    "WARRIOR",
    "ARCHER",
    "SORCERESS",
    "MONSTER",
    "BOSS", 
}
EnumType = CreateEnumTable(EnumType) 


local Base3D = class ("Base3D", function ()
	return cc.Node:create()
end)

function Base3D:ctor()
	self._isalive = true
	self._blood = 1000
	self._attack = 100
	self._defense = 100
    self._type = EnumType.Base
    self._sprite3d = nil
end

function Base3D.create(type)
	
    local base = Base3D.new()	
	
	return base
end

-- get hero type
function Base3D:getHeroType()
    return self._type
end

return Base3D