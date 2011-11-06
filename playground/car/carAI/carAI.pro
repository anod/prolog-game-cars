/*****************************************************************************

                        Copyright © 

******************************************************************************/

implement carAI
    inherits car
    open core

constants
    className = "playground/car/carAI/carAI".
    classVersion = "".

facts
    cellCount:positive:=0.
    


predicates
   newDirection(integer) procedure (o).

clauses
    classInfo(className, classVersion).

    move():-
        cellCount = 0,
        newDirection(NewDir),
        setDirection(NewDir).
        
    newDirection(NewDir):-
        pnt(CarX,CarY) = getPosition(),
        draw::pntToCell(CarX,CarY,CellI,CellJ),
        NewDir = random(4), % dirTop,dirLeft,dirRight,dirBottom
        
    
    
end implement carAI
