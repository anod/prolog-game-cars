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
    pntToCell:(pnt,pnt) procedure (i,o).
    findRoadCell:(integer CellI, integer CellJ) procedure (o,o).
end class utils