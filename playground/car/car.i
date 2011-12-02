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
    stop:().
    drive:().
    update:().
    init:(pnt Cell).
    initWay:().
    getCell:() -> pnt.
    getDirection:() -> integer.
    getPosition:() -> pnt.
    setNextCell:(integer,pnt).
    turnLeft:().
    turnRight:().
    move:().
end interface car