/*****************************************************************************

                        Copyright © 

******************************************************************************/

interface carUser supports car
    open core

predicates

    driveForward:().
    driveBackward:().
    driveLeft:().
    driveRight:().

    redeemViolation:()->integer.
end interface carUser