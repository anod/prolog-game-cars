/*****************************************************************************

                        Copyright © 

******************************************************************************/
class draw : draw
    open core, vpiDomains

predicates
    classInfo : core::classInfo.
    % @short Class information  predicate. 
    % @detail This predicate represents information predicate of this class.
    % @end
    load:().
    draw:(windowGDI GDI,rct Rect, cityGenerator, car).
end class draw