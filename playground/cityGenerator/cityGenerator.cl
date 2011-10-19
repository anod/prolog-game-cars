/*****************************************************************************

                        Copyright © 

******************************************************************************/
class cityGenerator : cityGenerator
    open core

constants
    maxRow:positive = 10.
    maxCol:positive = 7.
    cellEmpty = -1.
    cellRoad = 1.
    
predicates
    classInfo : core::classInfo.
    % @short Class information  predicate. 
    % @detail This predicate represents information predicate of this class.
    % @end
end class cityGenerator