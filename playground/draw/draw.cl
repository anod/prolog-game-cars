/*****************************************************************************

                        Copyright © 

******************************************************************************/
class draw : draw
    open core, vpiDomains, carDomains

constants
    cellImgSize:positive = 32.

predicates
    classInfo : core::classInfo.
    % @short Class information  predicate. 
    % @detail This predicate represents information predicate of this class.
    % @end
    load:().
    draw:(windowGDI GDI,rct Rect, car_list).
end class draw