#include "lua_cocos2dx_custom.hpp"
#include "EffectSprite3D.h"
#include "DrawNode3D.h"
#include "tolua_fix.h"
#include "LuaBasicConversions.h"



int lua_cocos2dx_custom_Effect3D_draw(lua_State* tolua_S)
{
    int argc = 0;
    Effect3D* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Effect3D",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Effect3D*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cocos2dx_custom_Effect3D_draw'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Mat4 arg0;

        ok &= luaval_to_mat4(tolua_S, 2, &arg0, "Effect3D:draw");
        if(!ok)
            return 0;
        cobj->draw(arg0);
        return 0;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d \n", "Effect3D:draw",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_custom_Effect3D_draw'.",&tolua_err);
#endif

    return 0;
}
int lua_cocos2dx_custom_Effect3D_setTarget(lua_State* tolua_S)
{
    int argc = 0;
    Effect3D* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Effect3D",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Effect3D*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cocos2dx_custom_Effect3D_setTarget'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        EffectSprite3D* arg0;

        ok &= luaval_to_object<EffectSprite3D>(tolua_S, 2, "EffectSprite3D",&arg0);
        if(!ok)
            return 0;
        cobj->setTarget(arg0);
        return 0;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d \n", "Effect3D:setTarget",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_custom_Effect3D_setTarget'.",&tolua_err);
#endif

    return 0;
}
static int lua_cocos2dx_custom_Effect3D_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (Effect3D)");
    return 0;
}

int lua_register_cocos2dx_custom_Effect3D(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"Effect3D");
    tolua_cclass(tolua_S,"Effect3D","Effect3D","cc.Ref",nullptr);

    tolua_beginmodule(tolua_S,"Effect3D");
        tolua_function(tolua_S,"draw",lua_cocos2dx_custom_Effect3D_draw);
        tolua_function(tolua_S,"setTarget",lua_cocos2dx_custom_Effect3D_setTarget);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(Effect3D).name();
    g_luaType[typeName] = "Effect3D";
    g_typeCast["Effect3D"] = "Effect3D";
    return 1;
}

int lua_cocos2dx_custom_Effect3DOutline_setOutlineWidth(lua_State* tolua_S)
{
    int argc = 0;
    Effect3DOutline* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Effect3DOutline",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Effect3DOutline*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cocos2dx_custom_Effect3DOutline_setOutlineWidth'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "Effect3DOutline:setOutlineWidth");
        if(!ok)
            return 0;
        cobj->setOutlineWidth(arg0);
        return 0;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d \n", "Effect3DOutline:setOutlineWidth",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_custom_Effect3DOutline_setOutlineWidth'.",&tolua_err);
#endif

    return 0;
}
int lua_cocos2dx_custom_Effect3DOutline_setOutlineColor(lua_State* tolua_S)
{
    int argc = 0;
    Effect3DOutline* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Effect3DOutline",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Effect3DOutline*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cocos2dx_custom_Effect3DOutline_setOutlineColor'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Vec3 arg0;

        ok &= luaval_to_vec3(tolua_S, 2, &arg0, "Effect3DOutline:setOutlineColor");
        if(!ok)
            return 0;
        cobj->setOutlineColor(arg0);
        return 0;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d \n", "Effect3DOutline:setOutlineColor",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_custom_Effect3DOutline_setOutlineColor'.",&tolua_err);
#endif

    return 0;
}
int lua_cocos2dx_custom_Effect3DOutline_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"Effect3DOutline",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
            return 0;
        Effect3DOutline* ret = Effect3DOutline::create();
        object_to_luaval<Effect3DOutline>(tolua_S, "Effect3DOutline",(Effect3DOutline*)ret);
        return 1;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d\n ", "Effect3DOutline:create",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_custom_Effect3DOutline_create'.",&tolua_err);
#endif
    return 0;
}
static int lua_cocos2dx_custom_Effect3DOutline_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (Effect3DOutline)");
    return 0;
}

int lua_register_cocos2dx_custom_Effect3DOutline(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"Effect3DOutline");
    tolua_cclass(tolua_S,"Effect3DOutline","Effect3DOutline","Effect3D",nullptr);

    tolua_beginmodule(tolua_S,"Effect3DOutline");
        tolua_function(tolua_S,"setOutlineWidth",lua_cocos2dx_custom_Effect3DOutline_setOutlineWidth);
        tolua_function(tolua_S,"setOutlineColor",lua_cocos2dx_custom_Effect3DOutline_setOutlineColor);
        tolua_function(tolua_S,"create", lua_cocos2dx_custom_Effect3DOutline_create);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(Effect3DOutline).name();
    g_luaType[typeName] = "Effect3DOutline";
    g_typeCast["Effect3DOutline"] = "Effect3DOutline";
    return 1;
}

int lua_cocos2dx_custom_EffectSprite3D_setEffect3D(lua_State* tolua_S)
{
    int argc = 0;
    EffectSprite3D* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"EffectSprite3D",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (EffectSprite3D*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cocos2dx_custom_EffectSprite3D_setEffect3D'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        Effect3D* arg0;

        ok &= luaval_to_object<Effect3D>(tolua_S, 2, "Effect3D",&arg0);
        if(!ok)
            return 0;
        cobj->setEffect3D(arg0);
        return 0;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d \n", "EffectSprite3D:setEffect3D",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_custom_EffectSprite3D_setEffect3D'.",&tolua_err);
#endif

    return 0;
}
int lua_cocos2dx_custom_EffectSprite3D_addEffect(lua_State* tolua_S)
{
    int argc = 0;
    EffectSprite3D* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"EffectSprite3D",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (EffectSprite3D*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cocos2dx_custom_EffectSprite3D_addEffect'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        Effect3DOutline* arg0;
        ssize_t arg1;

        ok &= luaval_to_object<Effect3DOutline>(tolua_S, 2, "Effect3DOutline",&arg0);

        ok &= luaval_to_ssize(tolua_S, 3, &arg1, "EffectSprite3D:addEffect");
        if(!ok)
            return 0;
        cobj->addEffect(arg0, arg1);
        return 0;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d \n", "EffectSprite3D:addEffect",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_custom_EffectSprite3D_addEffect'.",&tolua_err);
#endif

    return 0;
}
int lua_cocos2dx_custom_EffectSprite3D_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"EffectSprite3D",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        std::string arg0;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "EffectSprite3D:create");
        if(!ok)
            return 0;
        EffectSprite3D* ret = EffectSprite3D::create(arg0);
        object_to_luaval<EffectSprite3D>(tolua_S, "EffectSprite3D",(EffectSprite3D*)ret);
        return 1;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d\n ", "EffectSprite3D:create",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_custom_EffectSprite3D_create'.",&tolua_err);
#endif
    return 0;
}
int lua_cocos2dx_custom_EffectSprite3D_createFromObjFileAndTexture(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"EffectSprite3D",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 2)
    {
        std::string arg0;
        std::string arg1;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "EffectSprite3D:createFromObjFileAndTexture");
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "EffectSprite3D:createFromObjFileAndTexture");
        if(!ok)
            return 0;
        EffectSprite3D* ret = EffectSprite3D::createFromObjFileAndTexture(arg0, arg1);
        object_to_luaval<EffectSprite3D>(tolua_S, "EffectSprite3D",(EffectSprite3D*)ret);
        return 1;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d\n ", "EffectSprite3D:createFromObjFileAndTexture",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_custom_EffectSprite3D_createFromObjFileAndTexture'.",&tolua_err);
#endif
    return 0;
}
static int lua_cocos2dx_custom_EffectSprite3D_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (EffectSprite3D)");
    return 0;
}

int lua_register_cocos2dx_custom_EffectSprite3D(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"EffectSprite3D");
    tolua_cclass(tolua_S,"EffectSprite3D","EffectSprite3D","cc.Sprite3D",nullptr);

    tolua_beginmodule(tolua_S,"EffectSprite3D");
        tolua_function(tolua_S,"setEffect3D",lua_cocos2dx_custom_EffectSprite3D_setEffect3D);
        tolua_function(tolua_S,"addEffect",lua_cocos2dx_custom_EffectSprite3D_addEffect);
        tolua_function(tolua_S,"create", lua_cocos2dx_custom_EffectSprite3D_create);
        tolua_function(tolua_S,"createFromObjFileAndTexture", lua_cocos2dx_custom_EffectSprite3D_createFromObjFileAndTexture);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(EffectSprite3D).name();
    g_luaType[typeName] = "EffectSprite3D";
    g_typeCast["EffectSprite3D"] = "EffectSprite3D";
    return 1;
}

int lua_cocos2dx_custom_DrawNode3D_getBlendFunc(lua_State* tolua_S)
{
    int argc = 0;
    cocos2d::DrawNode3D* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"cc.DrawNode3D",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (cocos2d::DrawNode3D*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cocos2dx_custom_DrawNode3D_getBlendFunc'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
            return 0;
        const cocos2d::BlendFunc& ret = cobj->getBlendFunc();
        blendfunc_to_luaval(tolua_S, ret);
        return 1;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d \n", "cc.DrawNode3D:getBlendFunc",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_custom_DrawNode3D_getBlendFunc'.",&tolua_err);
#endif

    return 0;
}
int lua_cocos2dx_custom_DrawNode3D_setBlendFunc(lua_State* tolua_S)
{
    int argc = 0;
    cocos2d::DrawNode3D* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"cc.DrawNode3D",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (cocos2d::DrawNode3D*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cocos2dx_custom_DrawNode3D_setBlendFunc'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::BlendFunc arg0;

        #pragma warning NO CONVERSION TO NATIVE FOR BlendFunc;
        if(!ok)
            return 0;
        cobj->setBlendFunc(arg0);
        return 0;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d \n", "cc.DrawNode3D:setBlendFunc",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_custom_DrawNode3D_setBlendFunc'.",&tolua_err);
#endif

    return 0;
}
int lua_cocos2dx_custom_DrawNode3D_drawLine(lua_State* tolua_S)
{
    int argc = 0;
    cocos2d::DrawNode3D* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"cc.DrawNode3D",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (cocos2d::DrawNode3D*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cocos2dx_custom_DrawNode3D_drawLine'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        cocos2d::Vec3 arg0;
        cocos2d::Vec3 arg1;
        cocos2d::Color4F arg2;

        ok &= luaval_to_vec3(tolua_S, 2, &arg0, "cc.DrawNode3D:drawLine");

        ok &= luaval_to_vec3(tolua_S, 3, &arg1, "cc.DrawNode3D:drawLine");

        ok &=luaval_to_color4f(tolua_S, 4, &arg2, "cc.DrawNode3D:drawLine");
        if(!ok)
            return 0;
        cobj->drawLine(arg0, arg1, arg2);
        return 0;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d \n", "cc.DrawNode3D:drawLine",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_custom_DrawNode3D_drawLine'.",&tolua_err);
#endif

    return 0;
}
int lua_cocos2dx_custom_DrawNode3D_clear(lua_State* tolua_S)
{
    int argc = 0;
    cocos2d::DrawNode3D* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"cc.DrawNode3D",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (cocos2d::DrawNode3D*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cocos2dx_custom_DrawNode3D_clear'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
            return 0;
        cobj->clear();
        return 0;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d \n", "cc.DrawNode3D:clear",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_custom_DrawNode3D_clear'.",&tolua_err);
#endif

    return 0;
}
int lua_cocos2dx_custom_DrawNode3D_onDraw(lua_State* tolua_S)
{
    int argc = 0;
    cocos2d::DrawNode3D* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"cc.DrawNode3D",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (cocos2d::DrawNode3D*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cocos2dx_custom_DrawNode3D_onDraw'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        cocos2d::Mat4 arg0;
        unsigned int arg1;

        ok &= luaval_to_mat4(tolua_S, 2, &arg0, "cc.DrawNode3D:onDraw");

        ok &= luaval_to_uint32(tolua_S, 3,&arg1, "cc.DrawNode3D:onDraw");
        if(!ok)
            return 0;
        cobj->onDraw(arg0, arg1);
        return 0;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d \n", "cc.DrawNode3D:onDraw",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_custom_DrawNode3D_onDraw'.",&tolua_err);
#endif

    return 0;
}
int lua_cocos2dx_custom_DrawNode3D_drawCube(lua_State* tolua_S)
{
    int argc = 0;
    cocos2d::DrawNode3D* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"cc.DrawNode3D",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (cocos2d::DrawNode3D*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cocos2dx_custom_DrawNode3D_drawCube'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        cocos2d::Vec3* arg0;
        cocos2d::Color4F arg1;

        ok &= luaval_to_object<cocos2d::Vec3>(tolua_S, 2, "cc.Vec3",&arg0);

        ok &=luaval_to_color4f(tolua_S, 3, &arg1, "cc.DrawNode3D:drawCube");
        if(!ok)
            return 0;
        cobj->drawCube(arg0, arg1);
        return 0;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d \n", "cc.DrawNode3D:drawCube",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_custom_DrawNode3D_drawCube'.",&tolua_err);
#endif

    return 0;
}
int lua_cocos2dx_custom_DrawNode3D_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"cc.DrawNode3D",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
            return 0;
        cocos2d::DrawNode3D* ret = cocos2d::DrawNode3D::create();
        object_to_luaval<cocos2d::DrawNode3D>(tolua_S, "cc.DrawNode3D",(cocos2d::DrawNode3D*)ret);
        return 1;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d\n ", "cc.DrawNode3D:create",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_custom_DrawNode3D_create'.",&tolua_err);
#endif
    return 0;
}
static int lua_cocos2dx_custom_DrawNode3D_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (DrawNode3D)");
    return 0;
}

int lua_register_cocos2dx_custom_DrawNode3D(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"cc.DrawNode3D");
    tolua_cclass(tolua_S,"DrawNode3D","cc.DrawNode3D","cc.Node",nullptr);

    tolua_beginmodule(tolua_S,"DrawNode3D");
        tolua_function(tolua_S,"getBlendFunc",lua_cocos2dx_custom_DrawNode3D_getBlendFunc);
        tolua_function(tolua_S,"setBlendFunc",lua_cocos2dx_custom_DrawNode3D_setBlendFunc);
        tolua_function(tolua_S,"drawLine",lua_cocos2dx_custom_DrawNode3D_drawLine);
        tolua_function(tolua_S,"clear",lua_cocos2dx_custom_DrawNode3D_clear);
        tolua_function(tolua_S,"onDraw",lua_cocos2dx_custom_DrawNode3D_onDraw);
        tolua_function(tolua_S,"drawCube",lua_cocos2dx_custom_DrawNode3D_drawCube);
        tolua_function(tolua_S,"create", lua_cocos2dx_custom_DrawNode3D_create);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(cocos2d::DrawNode3D).name();
    g_luaType[typeName] = "cc.DrawNode3D";
    g_typeCast["DrawNode3D"] = "cc.DrawNode3D";
    return 1;
}
TOLUA_API int register_all_cocos2dx_custom(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"cc",0);
	tolua_beginmodule(tolua_S,"cc");

	lua_register_cocos2dx_custom_EffectSprite3D(tolua_S);
	lua_register_cocos2dx_custom_Effect3D(tolua_S);
	lua_register_cocos2dx_custom_Effect3DOutline(tolua_S);
	lua_register_cocos2dx_custom_DrawNode3D(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

