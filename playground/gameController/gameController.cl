/*****************************************************************************

                        Copyright © 

******************************************************************************/
class gameController : gameController
    open core, vpiDomains
predicates
    init:(window).
    % @short Init game controller
    % Init state of class
    % @end
    start:().
    % @short Start new game
    % Reset to initial start and prepare all required objects
    % @end
    stop:().
    % @short Stop game
    % Stop the timer
    % @end
    timer:(drawWindow).
    % @short onTimer
    % Called on each timer tick
    % @end
    draw:(windowGDI, rct).
    % @short onDraw
    % Called after invalidate when redraw required
    % @end
    keyDown:(integer).
    % @short onKeyDown
    % Called when user press any key
    % @end
    keyUp:(integer).
    % @short onKeyUp
    % Called when user un - press any key
    % @end    
end class gameController