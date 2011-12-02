/*****************************************************************************

                        Copyright © 

******************************************************************************/
class cityTrafficLights : cityTrafficLights
    open core, vpiDomains

constants
    lightGreen = 0.
    lightRed = 1. 
    
predicates
    classInfo : core::classInfo.
    % @short Class information  predicate. 
    % @detail This predicate represents information predicate of this class.
    % @end
    place:().
    % @short Place traffic lights on junctions
    % @end   
    getLight:(integer I,integer J) -> integer nondeterm (i,i).
    % @short Get light if available
    % @end
    updateTimers:().
    % @short Update timers
    % @end 
    getChangedLights:() -> pntlist.
    % @short Returns list of cell with traffic light that were changed their light
    % @end 
    
end class cityTrafficLights