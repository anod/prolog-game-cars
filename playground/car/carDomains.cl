 /*****************************************************************************

                        Copyright © 

******************************************************************************/
class carDomains : carDomains
    open core

domains
    car_list = car*.
    carai_list = carAI*.
    
constants
    carAI = "carAI".
    carUser = "carUser".
        
% @short List of car objects.
% @end

predicates
    classInfo : core::classInfo.
    % @short Class information  predicate. 
    % @detail This predicate represents information predicate of this class.
    % @end

end class carDomains