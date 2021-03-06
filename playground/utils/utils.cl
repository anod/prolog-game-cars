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
    % @short Convert point coordinates to cell
    findRoadCell:(integer CellI, integer CellJ) procedure (o,o).
    % @short Finds random road cell on map
    findRoadCellDist:(integer A,integer B,integer I,integer J) procedure (i,i,o,o).
    % @short Finds random road cell on map with minimum distance limit from cell [A,B]
    calcDistance:(pnt,pnt) -> integer.
    % @short Calc distance between 2 cells
    checkRoadCell:(integer I,integer J) -> integer.
    % @short Check if cell is road, return 1 if true, 0 if false
    getDirectionCell:(integer Dir,pnt From,pnt To) procedure (i,i,o).
    % @short Calc next cell according to dircetion
    checkTrafficLight:(pnt Cell) -> integer.
    % @short Check if traffic light in cell red or yellor, return 1 or 0
    checkRedTrafficLight:(pnt Cell) -> integer.
    % @short Check if traffic light in cell is red, return 1 or 0
end class utils