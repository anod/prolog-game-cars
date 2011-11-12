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
    initDirection:().
    getDirection:() -> integer.
    setDirection:(integer).
    getPosition:() -> pnt.
    setPosition:(pnt).
    turnLeft:().
    turnRight:().
    move:().
end interface car