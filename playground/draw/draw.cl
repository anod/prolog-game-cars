/*****************************************************************************

                        Copyright © 

******************************************************************************/
class draw : draw
    open core

predicates
    classInfo : core::classInfo.
    % @short Class information  predicate. 
    % @detail This predicate represents information predicate of this class.
    % @end
    draw:(windowGDI Win, cityGenerator).

end class draw