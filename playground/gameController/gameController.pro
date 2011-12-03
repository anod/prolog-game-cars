/*****************************************************************************

                        Copyright © 

******************************************************************************/

implement gameController
    open core, vpiDomains, carDomains
    
constants
    timerMillis:positive = 20.
    carsAINumber:positive = 3.

class facts
    tm:vpiDomains::timerId := nullHandle.
    carUser:carUser := erroneous.
    cars:car_list := [].
    carsAI:car_list := [].
    win:window := erroneous.

clauses
%
% Public predicates
%
    init(W) :-
        win:=W,
        draw::load(),
        cityGenerator::create(), 
        mapBFS::build(),
        createCars(),
        tm := win:timerSet(timerMillis).
       
    start() :-
        utils::findRoadCell(DestI,DestJ),
        carUser:setDestCell(pnt(DestI,DestJ)).

    stop() :-
        vpi::timerKill(tm),!.
        
    timer(W):-
        cityTrafficLights::updateTimers(),
        moveCars(cars),
        W:invalidate().
           
    draw(GDIObject, Rect):-
        draw::draw(GDIObject, Rect, cars).
        
    keyDown(Key):-
        Key = 65, % - A
        carUser:driveLeft(),
        fail.
    keyDown(Key):-
        Key = 68, % - D
        carUser:driveRight(),
        fail.
    keyDown(Key):-
        Key = 87, % - W
        carUser:driveForward(),
        fail.
    keyDown(Key):-
        Key = 83, % - S
        carUser:driveBackward(),
        fail.
    keyDown(_Key).
    
    keyUp(_Key):-
        carUser:stop(),!.
        
%
% Inner class predicates
%
class predicates
    createCars:().
clauses
    createCars() :-  
        cars:=[],
        carsAI:=[],
        carUser := carUser::new(),
        placeCar(carUser),
        cars:=list::append(cars,[carUser]),
        createAICars(carsAINumber),
        cars:=list::append(cars,carsAI).
        
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

class predicates
    moveCars:(car_list) procedure (i).
clauses 
    moveCars([]):-!.
    moveCars([Car|Tail]):-
        Car:move(),
        moveCars(Tail),!.  
        
end implement gameController
