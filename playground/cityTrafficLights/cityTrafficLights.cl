/*****************************************************************************

                        Copyright © 

******************************************************************************/
class cityTrafficLights : cityTrafficLights
    open core

constants
    timeoutDefault:positive = 60.
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
end class cityTrafficLights