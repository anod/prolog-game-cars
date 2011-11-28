/*****************************************************************************

                        Copyright © 

******************************************************************************/
class utils : utils
    open core, vpiDomains

predicates
    classInfo : core::classInfo.
    % @short Class information  predicate. 
    % @detail This predicate represents information predicate of this class.
    % @end
    pntToCell:(integer X,integer Y,integer I,integer J) procedure (i,i,o,o).
    carToCell:(car,integer I,integer J) procedure (i,o,o).
    carAdjToCell:(car,integer I,integer J) procedure (i,o,o).
    detectJunction:(integer I,integer J) -> integer.
    findRoadCell:(integer CellI, integer CellJ) procedure (o,o).
end class utils