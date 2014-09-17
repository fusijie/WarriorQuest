
--------------------------------
-- @module AABB
-- @parent_module cc

--------------------------------
-- @function [parent=#AABB] reset 
-- @param self
        
--------------------------------
-- @function [parent=#AABB] set 
-- @param self
-- @param #vec3_table vec3
-- @param #vec3_table vec3
        
--------------------------------
-- @function [parent=#AABB] transform 
-- @param self
-- @param #mat4_table mat4
        
--------------------------------
-- @function [parent=#AABB] getCenter 
-- @param self
-- @return vec3_table#vec3_table ret (return value: vec3_table)
        
--------------------------------
-- @function [parent=#AABB] isEmpty 
-- @param self
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- @function [parent=#AABB] getCorners 
-- @param self
-- @param #vec3_table vec3
        
--------------------------------
-- @function [parent=#AABB] updateMinMax 
-- @param self
-- @param #vec3_table vec3
-- @param #long long
        
--------------------------------
-- @function [parent=#AABB] containPoint 
-- @param self
-- @param #vec3_table vec3
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- @overload self, vec3_table, vec3_table         
-- @overload self         
-- @function [parent=#AABB] AABB
-- @param self
-- @param #vec3_table vec3
-- @param #vec3_table vec3

return nil
