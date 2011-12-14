/*****************************************************************************

                        Copyright © 

******************************************************************************/
class carManager : carManager
    open core, carDomains

predicates
    classInfo : core::classInfo.
    % @short Class information  predicate. 
    % @detail This predicate represents information predicate of this class.
    % @end

    createCars:(integer).
    getUserCar:()->carUser.
    getCarsAI:()->car_list.
    moveCars:().
end class carManager