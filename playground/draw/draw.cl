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
    drawGame:(windowGDI GDI,rct Rect, integer Time, integer ViolationTIme).
    drawMainMenu:(windowGDI GDI,integer MenuItemSelected).
    drawTopTen:(windowGDI GDI).
    drawLoading:(windowGDI GDI).    
    drawFinish:(windowGDI GDI, integer Score).
end class draw