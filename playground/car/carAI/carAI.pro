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
    finalPoint:positive:=1.
    


predicates
    

clauses
    classInfo(className, classVersion).


    move():-
        finalPoint = 1,
        createPath().
    move():-
        
    
end implement carAI
