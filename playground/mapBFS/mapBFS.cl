/*****************************************************************************

                        Copyright © 

******************************************************************************/
class mapBFS : mapBFS
    open core, vpiDomains

predicates
    classInfo : core::classInfo.
    % @short Class information  predicate. 
    % @detail This predicate represents information predicate of this class.
    % @end
    build:().
    % @short build graph arcs based on current map
    calcWay:(pnt A,pnt B)->pntlist determ (i,i).
    % @short Calc way between 2 points using BFS
end class mapBFS