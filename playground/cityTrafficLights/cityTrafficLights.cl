/*****************************************************************************

                        Copyright © 

******************************************************************************/
class cityTrafficLights : cityTrafficLights
    open core, vpiDomains

constants
    lightGreen = 0.
    lightYellowRed = 1. 
    lightYellowGreen = 2. 
    lightRed = 3. 

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
    
end class cityTrafficLights