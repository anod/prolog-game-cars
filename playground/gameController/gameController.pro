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
    placeCar:(car) procedure (i).
    createAICars:(integer) procedure (i).
    updateCars:(car_list,drawWindow) procedure (i,i).
clauses
            
    start(W) :- 
        draw::load(),
        cityGenerator::create(), 
        mapBFS::build(),
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
        Car:initDirection(),
        carsAI:=list::append(carsAI,[Car]),
        createAICars(Count-1).
        
    timer(W):-
        updateCars(cars,W).
        
    updateCars([],_):-!.
    updateCars([Car|Tail],W):-
        Car:update(),
        pnt(X,Y) = Car:getPosition(),
        %W:invalidate(rct(X+10,Y+10,X+32+10,Y+32+10)),
        W:invalidate(),
        updateCars(Tail,W),!.  
    
    draw(GDIObject, Rect):-
        draw::draw(GDIObject, Rect, cars).
      
    placeCar(Car):-
        utils::findRoadCell(CellI,CellJ),
        Car:setPosition(pnt(CellI*draw::cellImgSize,CellJ*draw::cellImgSize)),!.
        
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
