/*****************************************************************************

                        Copyright © 

******************************************************************************/
class cityGenerator : cityGenerator
    open core

constants
    maxCol:positive = 20.
    maxRow:positive = 15.
    cellEmpty = 0.
    cellRoad = 1. 
    cellBuilding = 2. 
    
predicates
    classInfo : core::classInfo.
    % @short Class information  predicate. 
    % @detail This predicate represents information predicate of this class.
    % @end
    create:().
    % @short create city map with roads and buildings
    getCellType : (integer I,integer J,integer Type) nondeterm (i,i,o). 
    % @short return cell type @see cell*
end class cityGenerator