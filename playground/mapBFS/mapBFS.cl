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
    calcWay:(pnt A,pnt B)->pntlist determ (i,i).
end class mapBFS