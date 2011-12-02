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
        
    pntToCell(pnt(X,Y),pnt(I,J)):-
       I=math::floor(X/draw::cellImgSize),
       J=math::floor(Y/draw::cellImgSize),!.


end implement utils
