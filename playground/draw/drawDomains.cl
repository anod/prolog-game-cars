/*****************************************************************************

                        Copyright © 

******************************************************************************/
class drawDomains : drawDomains
    open core, vpiDomains

domains
    violation = violation (pnt, integer, integer).
    violation_list = violation*.

predicates
    classInfo : core::classInfo.
    % @short Class information  predicate. 
    % @detail This predicate represents information predicate of this class.
    % @end

end class drawDomains