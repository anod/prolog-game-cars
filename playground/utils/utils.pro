/*****************************************************************************

                        Copyright © 

******************************************************************************/

implement utils
    open core, vpiDomains

constants
    className = "playground/utils/utils".
    classVersion = "".

class predicates

clauses
    classInfo(className, classVersion).
       
    findRoadCell(I,J):-
        I = math::random(cityGenerator::maxCol+1),
        J = math::random(cityGenerator::maxRow+1),
        cityGenerator::getCellType(I,J,Type),
        Type = cityGenerator::cellRoad,
        !.
    findRoadCell(I,J):-!,
        findRoadCell(I,J).

    findRoadCellDist(A, B, I, J):-
        findRoadCell(I,J),
        calcDistance(pnt(A,B),pnt(I,J)) > 9,!.
    findRoadCellDist(A, B, I, J):-
        findRoadCellDist(A, B, I, J).
        
    pntToCell(pnt(X,Y),pnt(I,J)):-
       I=math::floor(X/draw::cellImgSize),
       J=math::floor(Y/draw::cellImgSize),!.

    checkRoadCell(I,_)=0:-
        I < 0,!.
    checkRoadCell(_,J)=0:-
        J < 0,!.
    checkRoadCell(I,_)=0:-
        I > cityGenerator::maxCol,!.
    checkRoadCell(_,J)=0:-
        J > cityGenerator::maxRow,!.
    checkRoadCell(I,J)=1:-
        cityGenerator::getCellType(I,J,Type),
        Type = cityGenerator::cellRoad,!.
    checkRoadCell(_,_)=0.

    getDirectionCell(Dir,pnt(CurI,CurJ),pnt(CurI,CurJ-1)):-
       Dir = car::dirTop,!.
    getDirectionCell(Dir,pnt(CurI,CurJ),pnt(CurI-1,CurJ)):-
       Dir = car::dirLeft,!.
    getDirectionCell(Dir,pnt(CurI,CurJ),pnt(CurI+1,CurJ)):-
       Dir = car::dirRight,!.
    getDirectionCell(Dir,pnt(CurI,CurJ),pnt(CurI,CurJ+1)):-
       Dir = car::dirBottom,!.
    getDirectionCell(_,A,A).
      
    checkTrafficLight(pnt(I,J)) = 0:-
        Light = cityTrafficLights::getLight(I,J),
        Light = cityTrafficLights::lightRed,!.
    checkTrafficLight(pnt(I,J)) = 0:-
        Light = cityTrafficLights::getLight(I,J),
        Light = cityTrafficLights::lightYellowRed,!.
    checkTrafficLight(pnt(I,J)) = 0:-
        Light = cityTrafficLights::getLight(I,J),
        Light = cityTrafficLights::lightYellowGreen,!.
    checkTrafficLight(_) = 1.

    checkRedTrafficLight(pnt(I,J)) = 0:-
        Light = cityTrafficLights::getLight(I,J),
        Light = cityTrafficLights::lightRed,!.
    checkRedTrafficLight(_) = 1.
    
    calcDistance(pnt(I,J),pnt(A,B))=Res:-
       Res = math::round( math::sqrt( (A-I)^2 + (B-J)^2 ) ),!.

end implement utils
