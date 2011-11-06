/*****************************************************************************

                        Copyright © 

******************************************************************************/

implement gameController
    open core, vpiDomains, carDomains
    
constants
    timeRedraw:positive = 20.
    carsAINumber:positive = 3.

        
class facts
    tm:vpiDomains::timerId := nullHandle.
    carUser:car := erroneous.
    cars:car_list := [].
    carsAI:car_list := [].
class predicates
    createCars:().
    findRoadCell:(integer I, integer J, integer CellI, integer CellJ) procedure (i,i,o,o).
    placeCar:(car) procedure (i).
    createAICars:(integer) procedure (i).
    updateCars:(car_list,drawWindow) procedure (i,i).
clauses
            
    start(W) :- 
        draw::load(),
        cityGenerator::create(), 
        createCars(),
        tm := W:timerSet(timeRedraw).

    stop() :- vpi::timerKill(tm).

    createCars() :-  
        cars:=[],
        carsAI:=[],
        carUser := car::new(),
        placeCar(carUser),
        cars:=list::append(cars,[carUser]),
        createAICars(carsAINumber),
        cars:=list::append(cars,carsAI).
    
    createAICars(Count):-
        Count = 0,!.
    createAICars(Count):-
        Car = carAI::new(),
        placeCar(Car),
        carsAI:=list::append(carsAI,[Car]),
        createAICars(Count-1).
        
    timer(W):-
        moveAICars(carsAI),
        updateCars(cars,W).

    updateCars([],_):-!.
    updateCars([Car|Tail],W):-
        Car:update(),
        pnt(X,Y) = Car:getPosition(),
        W:invalidate(rct(X+10,Y+10,X+32+10,Y+32+10)),
        updateCars(Tail,W),!.  
    
    draw(GDIObject, Rect):-
        draw::draw(GDIObject, Rect, cars).
      
    placeCar(Car):-
        findRoadCell(cityGenerator::maxCol,cityGenerator::maxRow,CellI,CellJ),
        Car:setPosition(pnt(CellI*draw::cellImgSize,CellJ*draw::cellImgSize)),!.
        
    findRoadCell(I, _, 0, 0):-
        I<0,!.
    findRoadCell(I,J,CellI,CellJ):-
        J<0,!,
        findRoadCell(I-1,cityGenerator::maxRow, CellI,CellJ).
    findRoadCell(I,J,I,J):-
        cityGenerator::getCellType(I,J,Type),
        Type = cityGenerator::cellRoad,
        !.
    findRoadCell(I,J,CellI,CellJ):-!,
        findRoadCell(I,J-1, CellI,CellJ).
                   
    keyDown(Key):-
        Key = 65, % a
        carUser:turnLeft(),
        fail.
    keyDown(Key):-
        Key = 68, % d
        carUser:turnRight(),
        fail.
    keyDown(Key):-
        Key = 87, % w
        carUser:drive(),
        fail.
    keyDown(Key):-
        Key = 83, % s
        carUser:stop(),
        fail.
    keyDown(_Key).
    

end implement gameController
