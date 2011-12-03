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
    carUser:carUser := erroneous.
    cars:car_list := [].
    carsAI:car_list := [].
    win:window := erroneous.
    running:integer := 0.
    
class predicates
    createCars:().
    placeCar:(car) procedure (i).
    createAICars:(integer) procedure (i).

clauses
       
    init(W) :-
      win:=W,
      draw::load().
       
    start() :-
      stop(),
      cityGenerator::create(), 
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
        carUser := carUser::new(),
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
        cityTrafficLights::updateTimers(),
        moveCars(cars),
        W:invalidate().
           
    class predicates
        moveCars:(car_list) procedure (i).
    clauses 
        moveCars([]):-!.
        moveCars([Car|Tail]):-
            Car:move(),
            moveCars(Tail),!.  
    
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
