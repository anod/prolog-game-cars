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

    checkCarInCell(Dir,Cell)=1:-
        carUser:getCell() = Cell,
        carUser:getDirection() = Dir,!.
    checkCarInCell(Dir,Cell)=1:-
        checkAICarsInCellList(carsAI,Dir,Cell,Res),
        Res = 1,!.
    checkCarInCell(_Dir,_Cell)=0.
    
    checkAICarInCell(Dir,Cell)=1:-
        checkAICarsInCellList(carsAI,Dir,Cell,Res),
        Res = 1,!.
    checkAICarInCell(_Dir,_Cell)=0.
    
class predicates
    checkAICarsInCellList:(car_list,integer,pnt,integer) procedure (i,i,i,o).
clauses 
    checkAICarsInCellList([],_,_,0):-!.
    checkAICarsInCellList([Car|_Tail],Dir,Cell,1):-
        Car:getCell() = Cell,
        Car:getDirection() = Dir,!.
    checkAICarsInCellList([_Car|Tail],Dir,Cell,Result):-
        checkAICarsInCellList(Tail,Dir,Cell,Result),!.  

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
