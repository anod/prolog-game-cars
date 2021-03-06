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
    % @short preload resources
    drawGame:(windowGDI GDI,rct Rect, integer Time, integer ViolationTIme).
    % @short draw game screen
    drawMainMenu:(windowGDI GDI,integer MenuItemSelected).
    % @short draw main menu screen
    drawTopTen:(windowGDI GDI).
    % @short draw top ten screen
    drawFinish:(windowGDI GDI, integer Score).
    % @short draw finish screen
end class draw