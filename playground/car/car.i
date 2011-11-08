/*****************************************************************************

                        Copyright © 

******************************************************************************/

interface car
    open core, vpiDomains

constants
    dirTop:positive = 0.
    dirLeft:positive = 1.
    dirRight:positive = 2.
    dirBottom:positive = 3.
    
predicates
    stop:().
    drive:().
    update:().
    getDirection:() -> integer.
    setDirection:(integer).
    getPosition:() -> pnt.
    setPosition:(pnt).
    turnLeft:().
    turnRight:().
    move:().
end interface car