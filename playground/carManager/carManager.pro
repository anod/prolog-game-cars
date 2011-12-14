/*****************************************************************************

                        Copyright © 

******************************************************************************/

implement carManager
    open core, carDomains, vpiDomains

constants
    className = "playground/carManager/carManager".
    classVersion = "".

class facts
    carUser:carUser := erroneous.
    carsAI:car_list := [].

clauses
    classInfo(className, classVersion).

    createCars(CarsNumber):-  
        carsAI:=[],
        carUser := carUser::new(),
        placeCar(carUser),
        createAICars(CarsNumber),
        pnt(CellI,CellJ) = carUser:getCell(),
        utils::findRoadCellDist(CellI,CellJ,DestI,DestJ),
        carUser:setDestCell(pnt(DestI,DestJ)).

    getUserCar()=carUser.
        
    moveCars():-
        moveAICars(carsAI),
        carUser:move(),!.

    getCarsAI()=carsAI.


class predicates
    moveAICars:(car_list) procedure (i).
clauses 
    moveAICars([]):-!.
    moveAICars([Car|Tail]):-
        Car:move(),
        moveAICars(Tail),!.  
        
class predicates    
    createAICars:(integer) procedure (i).
clauses
    createAICars(Count):-
        Count = 0,!.
    createAICars(Count):-
        Car = carAI::new(),
        placeCar(Car),
        carsAI:=list::append(carsAI,[Car]),
        createAICars(Count-1).

class predicates
    placeCar:(car) procedure (i).
clauses    
    placeCar(Car):-
        utils::findRoadCell(CellI,CellJ),
        Car:init(pnt(CellI,CellJ)),!.


end implement carManager
