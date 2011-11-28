/*****************************************************************************

                        Copyright © 

******************************************************************************/

implement utils
    open core, vpiDomains

constants
    className = "playground/utils/utils".
    classVersion = "".

class predicates
    adjustCoords:(integer Dir,integer X,integer Y, integer, integer) procedure (i,i,i,o,o).

clauses
    classInfo(className, classVersion).

    detectJunction(I,J)=1:-
       cityGenerator::getCellType(I-1,J,LeftType),
       cityGenerator::getCellType(I+1,J,RightType),
       cityGenerator::getCellType(I,J-1,TopType),
       cityGenerator::getCellType(I,J+1,DownType),
       Count = LeftType + RightType + TopType + DownType,
       Count > 2,!.
    detectJunction(_I,_J)=0.
       
    findRoadCell(I,J):-
        I = math::random(cityGenerator::maxCol+1),
        J = math::random(cityGenerator::maxRow+1),
        cityGenerator::getCellType(I,J,Type),
        Type = cityGenerator::cellRoad,
        !.
    findRoadCell(I,J):-!,
        findRoadCell(I,J).
        
    carToCell(Car,I,J):-
        pnt(CarX,CarY) = Car:getPosition(),
        CX = CarX,
        CY = CarY,
        pntToCell(CX,CY,I,J).

    carAdjToCell(Car,I,J):-
        Dir = Car:getDirection(),
        pnt(CarX,CarY) = Car:getPosition(),
        adjustCoords(Dir,CarX,CarY,CX,CY),
        pntToCell(CX,CY,I,J).
    
    adjustCoords(Dir, X, Y, X, Y+draw::cellImgSize - 1):-
        Dir = car::dirBottom,!.
    adjustCoords(Dir, X, Y, X+draw::cellImgSize - 1, Y):-
        Dir = car::dirLeft,!.
    adjustCoords(Dir, X, Y, X-1, Y):-
        Dir = car::dirRight,!.
    adjustCoords(Dir, X, Y, X, Y-1):-
        Dir = car::dirTop,!.
    adjustCoords(_, X, Y, X, Y).
            
    pntToCell(X,Y,I,J):-
       I=math::floor(X/draw::cellImgSize),
       J=math::floor(Y/draw::cellImgSize),!.


end implement utils
