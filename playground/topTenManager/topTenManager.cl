/*****************************************************************************

                        Copyright © 

******************************************************************************/
class topTenManager : topTenManager
    open core, topTenDomains

predicates
    classInfo : core::classInfo.
    % @short Class information  predicate. 
    % @detail This predicate represents information predicate of this class.
    % @end
    init:().
    getTopTen:()->top10_list.
    addScore:(integer Score).
    calcScore:(integer TimeMillis)->integer.
    
end class topTenManager