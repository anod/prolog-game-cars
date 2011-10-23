/*****************************************************************************

                        Copyright © 

******************************************************************************/

implement draw
   open core, vpiDomains, vpi
   
   constants
       boardWidth:positive = 640.
       boardHeight:positive = 480.
       cellImgSize:positive = 32.
      
   class predicates
       drawCity:(windowHandle WindowHandle, cityGenerator CGen, integer I, integer J) procedure (i, i, i, i). 
       loadCellImg:(integer Type,picture Pict) determ (i, o). 
       drawBgCell:(windowHandle WindowHandle,integer Type, integer I, integer J) determ (i,i,i,i).
       
   clauses
       classInfo("playground/draw/draw",  "1.0").

       draw(WindowGDI, C) :-
           !, Rectangle= rct(0, 0, boardWidth, boardHeight),
           WindowHandle = pictOpen(Rectangle), 
           drawCity(WindowHandle ,C,cityGenerator::maxRow-1,cityGenerator::maxCol-1),
           Pict= pictClose(WindowHandle), 
           WindowGDI:pictDraw(Pict, pnt(10, 10), rop_SrcCopy).         
           
       drawCity(_,_, I, _) :-
            I<0,!.
       drawCity(WindowHandle,C,I,J):-
            J<0,!,
            drawCity(WindowHandle,C,I-1,cityGenerator::maxCol-1).
       drawCity(WindowHandle,C,I,J) :-
            C:getCellType(I,J,Type),
            drawBgCell(WindowHandle,Type,I,J),!,
            drawCity(WindowHandle,C,I,J-1).
       drawCity(_,_,_,_).
        
       drawBgCell(WindowHandle, Type, I,J) :-
            loadCellImg(Type, Pict),
            vpi::pictDraw(WindowHandle, Pict,  pnt(I*cellImgSize, J*cellImgSize), rop_SrcCopy).
            
       loadCellImg(Type,Pict) :-
            Type = cityGenerator::cellEmpty, !,
            Pict= vpi::pictLoad("graphics\\empty.bmp").
       loadCellImg(Type, Pict) :-
            Type = cityGenerator::cellRoad, !,
            Pict= vpi::pictLoad("graphics\\road_horizontal.bmp").
            
        
end implement draw
