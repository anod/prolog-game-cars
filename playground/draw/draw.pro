/*****************************************************************************

                        Copyright © 

******************************************************************************/

implement draw
   open core, vpiDomains, vpi
   
   constants
       boardWidth:positive = 640.
       boardHeight:positive = 480.
       cellImgSize:positive = 32.
      
   class facts
       userCarTop:picture := erroneous.
       userCarTopMask:picture := erroneous.
       userCarDown:picture := erroneous.
       userCarDownMask:picture := erroneous.
       userCarLeft:picture := erroneous.
       userCarLeftMask:picture := erroneous.
       userCarRight:picture := erroneous.
       userCarRightMask:picture := erroneous.
       
       cityEmpty:picture := erroneous.
       cityRoad:picture := erroneous.
       
   class predicates
       drawCity:(windowHandle WindowHandle, cityGenerator CGen, integer I, integer J) procedure (i, i, i, i). 
       drawCityCell:(integer CellI,integer CellJ,cityGenerator CGen,windowHandle WindowHandle) procedure (i, i, i, i).
       redrawCityCell:(integer I,integer J,cityGenerator CGen,windowHandle WindowHandle) procedure (i, i, i, i).
       drawCar:(windowHandle WindowHandle,car Car) procedure (i, i).
       loadCellImg:(integer Type,picture Pict) determ (i, o). 
       loadCarImg:(integer Dir,picture Pict, picture Mask) determ (i,o,o).
       pntToCell:(integer X,integer Y,integer I,integer J) procedure (i,i,o,o).
       
   clauses
       classInfo("playground/draw/draw",  "1.0").

       load():-
            cityEmpty:= vpi::pictLoad("graphics\\empty.bmp"),
            cityRoad:= vpi::pictLoad("graphics\\road_horizontal.bmp"),
            
            userCarTop := vpi::pictLoad("graphics\\car_top.bmp"),
            userCarTopMask := vpi::pictLoad("graphics\\car_top_mask.bmp"),
            userCarLeft:= vpi::pictLoad("graphics\\car_left.bmp"),
            userCarLeftMask:= vpi::pictLoad("graphics\\car_left_mask.bmp"),
            userCarRight:= vpi::pictLoad("graphics\\car_right.bmp"),
            userCarRightMask:= vpi::pictLoad("graphics\\car_right_mask.bmp"),
            userCarDown := vpi::pictLoad("graphics\\car_down.bmp"),
            userCarDownMask := vpi::pictLoad("graphics\\car_down_mask.bmp").

       draw(WindowGDI, Rect, CGen, Car) :-!,
           rct(A,B,C,D) = Rect,
           WndRect = rct(0, 0, boardWidth, boardHeight),
           WindowHandle = pictOpen(WndRect), 
           if C - A > cellImgSize,! then
                drawCity(WindowHandle, CGen,cityGenerator::maxRow,cityGenerator::maxCol)
           else
                pntToCell(A,B,I,J),
                redrawCityCell(I,J,CGen,WindowHandle),
                redrawCityCell(I-1,J,CGen,WindowHandle),
                redrawCityCell(I,J-1,CGen,WindowHandle),
                redrawCityCell(I+1,J,CGen,WindowHandle),
                redrawCityCell(I,J+1,CGen,WindowHandle),
                redrawCityCell(I+1,J+1,CGen,WindowHandle)
           end if,
           drawCar(WindowHandle, Car),
           
           Pict = pictClose(WindowHandle), 
           WindowGDI:pictDraw(Pict, pnt(10, 10), rop_SrcCopy).         


       pntToCell(X,Y,I,J):-
            I=math::floor(X/cellImgSize),
            J=math::floor(Y/cellImgSize),!.
       
       redrawCityCell(I,_J,_CGen,_WindowHandle):-
            I<0,!.
       redrawCityCell(_I,J,_CGen,_WindowHandle):-
            J<0,!.
       redrawCityCell(I,_J,_CGen,_WindowHandle):-
            I>cityGenerator::maxCol,!.
       redrawCityCell(_I,J,_CGen,_WindowHandle):-
            J>cityGenerator::maxRow,!.
       redrawCityCell(I,J,CGen,WindowHandle):-
            drawCityCell(I,J,CGen,WindowHandle).
       
       drawCity(_,_, I, _) :-
            I<0,!.
       drawCity(WindowHandle,C,I,J):-
            J<0,!,
            drawCity(WindowHandle,C,I-1,cityGenerator::maxCol).
       drawCity(WindowHandle,C,I,J) :-
            drawCityCell(I,J,C,WindowHandle),!,
            drawCity(WindowHandle,C,I,J-1).
        
       drawCityCell(I,J,CGen,WindowHandle):-
           CGen:getCellType(I,J,Type),
           loadCellImg(Type, Pict),!,
           vpi::pictDraw(WindowHandle, Pict,  pnt(I*cellImgSize, J*cellImgSize), rop_SrcCopy),!.
        drawCityCell(_I,_J,_CGen,_WindowHandle).
        
       drawCar(WindowHandle, Car) :-
           pnt(CarX,CarY) = Car:getPosition(),
           Dir = Car:getDirection(),
           loadCarImg(Dir,CarPict,CarMask),!,
           vpi::pictDraw(WindowHandle, CarMask, pnt(CarX,CarY), rop_SrcAnd),
           vpi::pictDraw(WindowHandle, CarPict, pnt(CarX,CarY), rop_SrcInvert).
      drawCar(_WindowHandle, _Car).
            
       loadCellImg(Type,Pict) :-
            Type = cityGenerator::cellEmpty, !,
            Pict= cityEmpty.
       loadCellImg(Type, Pict) :-
            Type = cityGenerator::cellRoad, !,
            Pict= cityRoad.
        
       loadCarImg(Dir,Pict,Mask) :- 
            Dir = car::dirTop, !,
            Pict= userCarTop,
            Mask= userCarTopMask.
       loadCarImg(Dir,Pict,Mask) :- 
            Dir = car::dirLeft, !,
            Pict= userCarLeft,
            Mask= userCarLeftMask.
       loadCarImg(Dir,Pict,Mask) :- 
            Dir = car::dirRight, !,
            Pict= userCarRight,
            Mask= userCarRightMask.
       loadCarImg(Dir,Pict,Mask) :- 
            Dir = car::dirBottom, !,
            Pict= userCarDown,
            Mask= userCarDownMask.
            
                 
end implement draw
