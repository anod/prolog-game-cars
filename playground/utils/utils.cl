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
    findRoadCellDist:(integer A,integer B,integer I,integer J) procedure (i,i,o,o).
    calcDistance:(pnt,pnt) -> integer.
    checkRoadCell:(integer,integer) -> integer.
    getDirectionCell:(integer,pnt,pnt) procedure (i,i,o).
    checkTrafficLight:(pnt) -> integer.
end class utils