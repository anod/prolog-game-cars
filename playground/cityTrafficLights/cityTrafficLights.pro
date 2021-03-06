/*****************************************************************************

                        Copyright © 

******************************************************************************/

implement cityTrafficLights
    open core, vpiDomains

constants
    className = "playground/cityTrafficLights/cityTrafficLights".
    classVersion = "".

constants
    timeoutDefault:positive = 120.
    timeoutYellow:positive = 40.
    
class facts
    traffic_lights:(pnt A) nondeterm.
    traffic_lights_timer:(pnt A, integer Light,integer Timeout) nondeterm.
clauses
    classInfo(className, classVersion).

    place():-
        purge(),
        placeTrafficLights(cityGenerator::maxCol,cityGenerator::maxRow),!.       

    getLight(I,J)=Light :-
        traffic_lights_timer(pnt(I,J),Light,_).
    
    updateTimers():-
        changeTimers(),!.
    
class predicates 
    changeTimers:().
clauses
    changeTimers():-
        traffic_lights(Cell),
        changeTimer(Cell),
        fail.
    changeTimers().
         
class predicates 
    changeTimer:(pnt Cell).
clauses
    changeTimer(Cell):-
        traffic_lights_timer(Cell, Light, Timeout),
        NewTimeout = Timeout-1,
        if NewTimeout > 0,! then
            retract(traffic_lights_timer(Cell,Light,Timeout)),
            assert(traffic_lights_timer(Cell,Light,NewTimeout))
        else 
            NewLight = switchLight(Light),
            DefaultTimeout = defaultTimeout(NewLight),
            retract(traffic_lights_timer(Cell,Light,Timeout)),
            assert(traffic_lights_timer(Cell,NewLight,DefaultTimeout))  
        end if,!.
    changeTimer(_).

class predicates 
    defaultTimeout:(integer) -> integer.
clauses
    defaultTimeout(lightYellowGreen) = timeoutYellow :-!.
    defaultTimeout(lightYellowRed) = timeoutYellow :-!.
    defaultTimeout(_) = timeoutDefault.

class predicates 
    switchLight:(integer) -> integer.
clauses
    switchLight(lightRed)=NewLight:-
        NewLight = lightYellowGreen,!.
    switchLight(lightYellowGreen)=NewLight:-
        NewLight = lightGreen,!.
    switchLight(lightGreen)=NewLight:-
        NewLight = lightYellowRed,!.
    switchLight(lightYellowRed)=NewLight:-
        NewLight = lightRed,!.       
    switchLight(_)=lightRed.
    
class predicates 
    placeTrafficLights:(integer I, integer J).
clauses
    placeTrafficLights(I,_J):-
        I<0,!.
    placeTrafficLights(I,J):-
        J<0,!,
        placeTrafficLights(I-1,cityGenerator::maxCol).
    placeTrafficLights(I,J):-
        cityGenerator::getCellType(I,J,Type),
        Type = cityGenerator::cellRoad,
        detectJunction(I,J) = 1,
        addNewLight(pnt(I,J)),
        placeTrafficLights(I,J-1),!.
    placeTrafficLights(I,J):-
        placeTrafficLights(I,J-1),!.
        
class predicates
    addNewLight:(pnt Cell).
clauses
    addNewLight(Cell) :-
        retract(traffic_lights(Cell)),
        retract(traffic_lights_timer(Cell,_,_)),        
        assert(traffic_lights(Cell)),
        Light = math::random(2),
        Timout = math::random(timeoutDefault),
        assert(traffic_lights_timer(Cell, Light, Timout)),!.
    addNewLight(Cell) :-
        assert(traffic_lights(Cell)),
        Light = math::random(2),
        Timout = math::random(timeoutDefault),
        assert(traffic_lights_timer(Cell, Light, Timout)),!.
        
class predicates
    detectJunction:(integer I,integer J) -> integer.
    % @short Check if point is junction
    % @detail Return 1 in case cell is junction and 0 if not
    % @end
clauses   
    detectJunction(I,J)=1:-
       cityGenerator::getCellType(I-1,J,LeftType),
       cityGenerator::getCellType(I+1,J,RightType),
       cityGenerator::getCellType(I,J-1,TopType),
       cityGenerator::getCellType(I,J+1,DownType),
       Count = LeftType + RightType + TopType + DownType,
       Count > 2,!.
    detectJunction(_I,_J)=0.

class predicates
    purge:().
clauses
    purge():-
        retractall(traffic_lights(_)),
        retractall(traffic_lights_timer(_,_,_)),!.

end implement cityTrafficLights
