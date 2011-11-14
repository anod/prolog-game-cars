/*****************************************************************************

                        Copyright © 

******************************************************************************/

implement utils
    open core, vpiDomains

constants
    className = "playground/utils/utils".
    classVersion = "".

clauses
    classInfo(className, classVersion).

    carToCell(Car,I,J):-
        Dir = Car:getDirection(),
        pnt(CarX,CarY) = Car:getPosition(),
        CX = CarX,
        CY = CarY,
        pntToCell(CX,CY,I,J).
            
    pntToCell(X,Y,I,J):-
       I=math::floor(X/draw::cellImgSize),
       J=math::floor(Y/draw::cellImgSize),!.


end implement utils
