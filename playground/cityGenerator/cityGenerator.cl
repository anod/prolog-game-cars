/*****************************************************************************

                        Copyright © 

******************************************************************************/
class cityGenerator : cityGenerator
    open core

constants
    maxRow:positive = 20.
    maxCol:positive = 15.
    cellEmpty = 0.
    cellRoad = 1. 
    
predicates
    classInfo : core::classInfo.
    % @short Class information  predicate. 
    % @detail This predicate represents information predicate of this class.
    % @end
end class cityGenerator