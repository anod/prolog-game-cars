/*****************************************************************************

                        Copyright © 

******************************************************************************/

implement carUser inherits car
    open core
    
clauses
    classInfo(className, classVersion).

    getClassName()=className.

    turnLeft():-
        getDirection() = dirTop,!,
        setDirection(dirLeft).
    turnLeft():-
        getDirection() = dirBottom,!,
        setDirection(dirRight).
    turnLeft():-
        getDirection() = dirLeft,!,
        setDirection(dirBottom).
    turnLeft():-
        getDirection() = dirRight,!,
        setDirection(dirTop).
    turnLeft().
    
    turnRight():-
        getDirection() = dirTop,!,
        setDirection(dirRight). 
    turnRight():-
        getDirection() = dirBottom,!,
        setDirection(dirLeft).
    turnRight():-
        getDirection() = dirLeft,!,
        setDirection(dirTop).
    turnRight():-
        getDirection() = dirRight,!,
        setDirection(dirBottom).
    turnRight().
    
end implement carUser
