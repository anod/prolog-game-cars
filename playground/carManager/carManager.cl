/*****************************************************************************

                        Copyright © 

******************************************************************************/
class carManager : carManager
    open core, carDomains, vpiDomains

predicates
    classInfo : core::classInfo.
    % @short Class information  predicate. 
    % @detail This predicate represents information predicate of this class.
    % @end

    createCars:(integer).
    % @short create cars and place them on map
    getUserCar:()->carUser.
    % @short return instance of user driven car
    getCarsAI:()->car_list.
    % @short return list of cumputer driven cars
    moveCars:().
    % @short move cars in their direction
    checkCarInCell:(integer,pnt)->integer.
    % @short check if any car currently in this cell
    % @detail If car in the cell and in the same direction return 1 else 0
    % @end
    checkAICarInCell:(integer,pnt)->integer.
    % @short check if Computer car currently in this cell
    % @detail If car in the cell and in the same direction return 1 else 0
    % @end
end class carManager