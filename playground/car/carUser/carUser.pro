/*****************************************************************************

                        Copyright © 

******************************************************************************/

implement carUser inherits car
    open core, vpiDomains

facts
    violationsCounter:positive :=0.
    
clauses
    classInfo(className, classVersion).

    getClassName()=className.

    driveForward():-
        checkRoadCell(dirTop) = 1,
        drive(),   
        updateNextCell(dirTop),!.
    driveForward():-
        stop(),
        stdio::write("You cannot drive forward"), stdio::nl.
    
    driveBackward():-
        checkRoadCell(dirBottom) = 1,
        drive(),        
        updateNextCell(dirBottom),!.
    driveBackward():-
        stop(),
        stdio::write("You cannot drive backward"), stdio::nl.
        
    driveLeft():-
        checkRoadCell(dirLeft) = 1,
        drive(),        
        updateNextCell(dirLeft),!.
    driveLeft():-
        stop(),
        stdio::write("You cannot drive left"), stdio::nl.
    
    driveRight():-
        checkRoadCell(dirRight) = 1,
        drive(),
        updateNextCell(dirRight),!. 
    driveRight():-
        stop(),
        stdio::write("You cannot drive right"), stdio::nl.
    
    redeemViolation()=1:-
        violationsCounter > 0,
        violationsCounter := violationsCounter-1,!.
    redeemViolation()=0.
    
    onBeforeNextCell():-
       if utils::checkRedTrafficLight(getCell()) = 0,! then
            violationsCounter := violationsCounter+1
       end if,
       if carManager::checkAICarInCell(getDirection(),getCell()) = 1,! then
            violationsCounter := violationsCounter+1
       end if,!.
        
predicates
    updateNextCell:(integer Dir).
clauses
    updateNextCell(Dir):-
        Cell = getCell(),
        utils::getDirectionCell(Dir,Cell,NewCell),
        setNextCell(Dir,NewCell),!.
    
predicates
    checkRoadCell:(integer NewDir) -> integer.
clauses
    checkRoadCell(NewDir) = Result :-
        Cell = getCell(),
        checkPositionInCell(NewDir) = 1,
        utils::getDirectionCell(NewDir,Cell,NewCell),
        pnt(I,J) = NewCell,
        Result = utils::checkRoadCell(I,J),!.
    checkRoadCell(_Dir) = 0.

predicates
    checkPositionInCell:(integer NewDir) -> integer.
clauses
    checkPositionInCell(NewDir) = 1:-
        NewDir = getDirection(),!.
    checkPositionInCell(dirTop) = 1:-
        dirBottom = getDirection(),!.
    checkPositionInCell(dirBottom) = 1:-
        dirTop = getDirection(),!.
    checkPositionInCell(dirLeft) = 1:-
        dirRight = getDirection(),!.                
    checkPositionInCell(dirRight) = 1:-
        dirLeft = getDirection(),!.                       
    checkPositionInCell(_NewDir) = 1:-
       pnt(I,J) = getCell(),
       pnt(X,Y) = getPosition(),
       DiffX = math::abs(I * draw::cellImgSize - X),
       DiffY = math::abs(J * draw::cellImgSize - Y),
       DiffX < 5, DiffY < 5,
       %% TODO find better place for that
       Pos = pnt(I * draw::cellImgSize,J * draw::cellImgSize),
       setPosition(Pos),
       
       !.
    checkPositionInCell(_NewDir) = 0.
    
        
end implement carUser
