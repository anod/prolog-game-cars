/*****************************************************************************

                        Copyright © 

******************************************************************************/

implement cityTrafficLights
    open core, vpiDomains

constants
    className = "playground/cityTrafficLights/cityTrafficLights".
    classVersion = "".
    
class facts
    traffic_lights : (integer I, integer J, integer Light,integer Timeout) nondeterm.

clauses
    classInfo(className, classVersion).

    place() :-
        purge(),
        placeTrafficLights(cityGenerator::maxCol,cityGenerator::maxRow),!.       

    getLight(I,J) = Light :-
        traffic_lights(I,J,Light,_).
    
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
        addRandomLight(I,J),
        placeTrafficLights(I,J-1),!.
    placeTrafficLights(I,J):-
        placeTrafficLights(I,J-1),!.
        
class predicates
    addRandomLight:(integer I,integer J).
clauses
    addRandomLight(I,J) :-
        retract(traffic_lights(I,J,_,_)),
        Light = math::random(2),
        Timout = math::random(timeoutDefault),
        assert(traffic_lights(I,J, Light, Timout)),!.
    addRandomLight(I,J) :-
        Light = math::random(2),
        Timout = math::random(timeoutDefault),
        assert(traffic_lights(I,J, Light, Timout)),!.
        
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
        retractall(traffic_lights(_,_,_,_)),!.

end implement cityTrafficLights
