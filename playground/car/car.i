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
    getClassName:() -> string.

    getCell:() -> pnt.
    getPosition:() -> pnt.
    setPosition:(pnt).
    getDirection:() -> integer.
    setDirection:(integer).
    getNextCell:() -> pnt.    
    setNextCell:(integer,pnt).
    getDestCell:() -> pnt.
    setDestCell:(pnt).
    
    stop:().
    drive:().
    wait:().
    move:().
    
    onBeforeNextCell:().
    onWait:().
        
end interface car