/*****************************************************************************

                        Copyright © 

******************************************************************************/

interface cityGenerator
    open core
predicates
    create:().
    getCellType : (integer I,integer J,integer Type) nondeterm (i,i,o).
end interface cityGenerator