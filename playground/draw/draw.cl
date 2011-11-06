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
    pntToCell:(integer X,integer Y,integer I,integer J) procedure (i,i,o,o).
end class draw