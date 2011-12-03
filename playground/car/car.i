/*****************************************************************************

                        Copyright © 

******************************************************************************/

interface car
    open core, vpiDomains

constants
    dirTop:integer = 0.
    dirLeft:integer = 1.
    dirRight:integer = 2.
    dirBottom:integer = 3.
    
predicates
    init:(pnt Cell).
    initWay:().

    getCell:() -> pnt.
    getNextCell:() -> pnt.
    getDirection:() -> integer.
    getPosition:() -> pnt.
    setNextCell:(integer,pnt).

    stop:().
    drive:().
    wait:().
    move:().
    
    onBeforeNextCell:().
    onWait:().
        
    turnLeft:().
    turnRight:().
end interface car