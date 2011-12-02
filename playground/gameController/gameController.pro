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
    win:window := erroneous.
    running:integer := 0.
class predicates
    createCars:().
    placeCar:(car) procedure (i).
    createAICars:(integer) procedure (i).
    moveCars:(car_list,drawWindow) procedure (i,i).
clauses
       
    init(W) :-
      win:=W,
      draw::load().
       
    start() :-
      stop(),
      cityGenerator::create(), 
      cityTrafficLights::place(),
      mapBFS::build(),
      createCars(),
      tm := win:timerSet(timeRedraw),
      running:=1.

    stop() :-
       running = 1,
       vpi::timerKill(tm),
       running:=0,!.
    stop().
    
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
        moveCars(cars,W).
        
    moveCars([],_):-!.
    moveCars([Car|Tail],W):-
        Car:move(),
        pnt(X,Y) = Car:getPosition(),
        W:invalidate(rct(X+10,Y+10,X+32+10,Y+32+10)),
        %W:invalidate(),
        moveCars(Tail,W),!.  
    
    draw(GDIObject, Rect):-
        draw::draw(GDIObject, Rect, cars).
      
    placeCar(Car):-
        utils::findRoadCell(CellI,CellJ),
        Car:init(pnt(CellI,CellJ)),!.
        
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
