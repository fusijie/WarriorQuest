/****************************************************************************
 Copyright (c) 2013-2014 Chukong Technologies Inc.
 
 http://www.cocos2d-x.org
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ****************************************************************************/
#include "lua_cocos2dx_3d_manual.h"
#include "lua_cocos2dx_3d_auto.hpp"
#include "CCLuaEngine.h"
#include "LuaBasicConversions.h"

//add 2 return value and extand this function
int lua_cocos2dx_camera_unproject(lua_State* tolua_S)
{
    int argc = 0;
    cocos2d::Camera* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"cc.Camera",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (cocos2d::Camera*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cocos2dx_Camera_unproject'", nullptr);
        return 0;
    }
#endif
    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        cocos2d::Size arg0;
        cocos2d::Vec3 arg1;
        cocos2d::Vec3 arg2;

        ok &= luaval_to_size(tolua_S, 2, &arg0, "cc.Camera:unproject");

        ok &= luaval_to_vec3(tolua_S, 3, &arg1);

        ok &= luaval_to_vec3(tolua_S, 4, &arg2);
        
        if(!ok)
            return 0;
        cobj->unproject(arg0, &arg1, &arg2);

        vec3_to_luaval(tolua_S, arg2);
        
        return 1;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d \n", "cc.Camera:unproject",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_Camera_unproject'.",&tolua_err);
#endif

    return 0;
}

static void extendCamera(lua_State* tolua_S)
{
    lua_pushstring(tolua_S,"cc.Camera");
    lua_rawget(tolua_S,LUA_REGISTRYINDEX);
    if (lua_istable(tolua_S,-1))
    {
        lua_pushstring(tolua_S,"unproject");
        lua_pushcfunction(tolua_S,lua_cocos2dx_camera_unproject);
        lua_rawset(tolua_S,-3);
    }
    lua_pop(tolua_S, 1);
}

int register_cocos3d_module(lua_State* L)
{
    lua_getglobal(L, "_G");
    if (lua_istable(L,-1))//stack:...,_G,
    {
        register_all_cocos2dx_3d(L);
    }
    lua_pop(L, 1);
    
    extendCamera(L);

    return 1;
}
