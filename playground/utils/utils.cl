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
    checkRoadCell:(integer,integer) -> integer.
    getDirectionCell:(integer,pnt,pnt) procedure (i,i,o).
end class utils