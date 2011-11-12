/*****************************************************************************

                        Copyright © 

******************************************************************************/

implement draw
   open core, vpiDomains, vpi, carDomains
   
   domains
    car_list = car*.
       
   constants
       boardWidth:positive = 672.
       boardHeight:positive = 512.
      
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
       drawCity:(windowHandle WindowHandle, integer I, integer J) procedure (i, i, i). 
       drawCityCell:(integer CellI,integer CellJ,windowHandle WindowHandle) procedure (i, i, i).
       redrawCityCell:(integer I,integer J,windowHandle WindowHandle) procedure (i, i, i).
       loadCellImg:(integer Type,picture Pict) determ (i, o). 
       loadCarImg:(integer Dir,picture Pict, picture Mask) determ (i,o,o).
       drawCar:(windowHandle WindowHandle,car Car) procedure (i, i).
       drawCars:(car_list Cars,windowHandle WindowHandle) procedure (i, i).
       
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

      draw(WindowGDI, Rect, Cars) :-!,
           rct(A,B,C,D) = Rect,
           WndRect = rct(0, 0, boardWidth, boardHeight),
           BackWH = pictOpen(WndRect), 
           if C - A > cellImgSize,! then
                drawCity(BackWH, cityGenerator::maxCol,cityGenerator::maxRow)
           else
                utils::pntToCell(A,B,I,J),

                redrawCityCell(I,J-1,BackWH),
                redrawCityCell(I-1,J-1,BackWH),
                redrawCityCell(I+1,J-1,BackWH),

                redrawCityCell(I,J,BackWH),
                redrawCityCell(I-1,J,BackWH),
                redrawCityCell(I+1,J,BackWH),
                
                redrawCityCell(I-1,J+1,BackWH),
                redrawCityCell(I,J+1,BackWH),
                redrawCityCell(I+1,J+1,BackWH)              
           end if,
           drawCars(Cars,BackWH),
           Pict = pictClose(BackWH), 
           WindowGDI:pictDraw(Pict, pnt(10, 10), rop_SrcCopy).
       
      redrawCityCell(I,_J,_WindowHandle):-
            I<0,!.
      redrawCityCell(_I,J,_WindowHandle):-
            J<0,!.
      redrawCityCell(I,_J,_WindowHandle):-
            I>cityGenerator::maxCol,!.
      redrawCityCell(_I,J,_WindowHandle):-
            J>cityGenerator::maxRow,!.
      redrawCityCell(I,J,WindowHandle):-
            drawCityCell(I,J,WindowHandle).

      drawCars([],_).
      drawCars([HeadCar|[]],BackWH):-!,
         drawCar(BackWH, HeadCar).
      drawCars([HeadCar|TailCars],BackWH):-
         drawCar(BackWH, HeadCar),
         drawCars(TailCars,BackWH).
                
      drawCity(_, I, _) :-
            I<0,!.
      drawCity(WindowHandle,I,J):-
            J<0,!,
            drawCity(WindowHandle,I-1,cityGenerator::maxRow).
      drawCity(WindowHandle,I,J) :-
            drawCityCell(I,J,WindowHandle),!,
            drawCity(WindowHandle,I,J-1).
        
      drawCityCell(I,J,WindowHandle):-
           cityGenerator::getCellType(I,J,Type),
           loadCellImg(Type, Pict),!,
           vpi::pictDraw(WindowHandle, Pict,  pnt(I*cellImgSize, J*cellImgSize), rop_SrcCopy),!.
      drawCityCell(_I,_J,_WindowHandle).
        
      drawCar(WindowHandle, Car) :-
           pnt(CarX,CarY) = Car:getPosition(),
           Dir = Car:getDirection(),
           loadCarImg(Dir,CarPict,CarMask),!,
           vpi::pictDraw(WindowHandle, CarMask, pnt(CarX,CarY), rop_SrcAnd),
           vpi::pictDraw(WindowHandle, CarPict, pnt(CarX,CarY), rop_SrcInvert),
           utils::carToCell(Car,I,J),
           vpi::drawText(WindowHandle,CarX,CarY+20,string::format("%d,%d",I,J)).
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
