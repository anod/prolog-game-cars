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
    % @short restore saved data
    getTopTen:()->top10_list.
    % @short get current top ten list
    addScore:(integer Score).
    % @short add new score
    calcScore:(integer TimeMillis)->integer.
    % @short calc scopre ased on user time
    
end class topTenManager