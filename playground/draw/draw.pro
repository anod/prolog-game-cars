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
       carUserTop:picture := erroneous.
       carUserDown:picture := erroneous.
       carUserLeft:picture := erroneous.
       carUserRight:picture := erroneous.
   
       carTop:picture := erroneous.
       carDown:picture := erroneous.
       carLeft:picture := erroneous.
       carRight:picture := erroneous.

       carTopMask:picture := erroneous.
       carDownMask:picture := erroneous.       
       carLeftMask:picture := erroneous.       
       carRightMask:picture := erroneous.
       
       cityEmpty:picture := erroneous.
       cityRoad:picture := erroneous.
       cityBuilding:picture := erroneous.
              
       trafficLightRed: picture := erroneous.
       trafficLightGreen: picture := erroneous.
       trafficLightYellow: picture := erroneous.
       trafficLightMask: picture := erroneous.              
       
       erroneousPict:picture := erroneous.
   clauses
      classInfo("playground/draw/draw",  "1.0").

      load():-
            % pre-load images for better performance
            cityEmpty:= vpi::pictLoad("graphics\\empty.bmp"),
            cityRoad:= vpi::pictLoad("graphics\\road_horizontal.bmp"),
            cityBuilding := vpi::pictLoad("graphics\\building.bmp"),
            
            carTop := vpi::pictLoad("graphics\\car_top.bmp"),
            carLeft:= vpi::pictLoad("graphics\\car_left.bmp"),
            carRight:= vpi::pictLoad("graphics\\car_right.bmp"),
            carDown := vpi::pictLoad("graphics\\car_down.bmp"),

            carUserTop := vpi::pictLoad("graphics\\car_top_user.bmp"),
            carUserLeft:= vpi::pictLoad("graphics\\car_left_user.bmp"),
            carUserRight:= vpi::pictLoad("graphics\\car_right_user.bmp"),
            carUserDown := vpi::pictLoad("graphics\\car_down_user.bmp"),

            carTopMask := vpi::pictLoad("graphics\\car_top_mask.bmp"),            
            carLeftMask:= vpi::pictLoad("graphics\\car_left_mask.bmp"),
            carRightMask:= vpi::pictLoad("graphics\\car_right_mask.bmp"),
            carDownMask := vpi::pictLoad("graphics\\car_down_mask.bmp"),

            trafficLightGreen := vpi::pictLoad("graphics\\traffic_light_green.bmp"),
            trafficLightRed := vpi::pictLoad("graphics\\traffic_light_red.bmp"),
            trafficLightYellow := vpi::pictLoad("graphics\\traffic_light_yellow.bmp"),
            trafficLightMask := vpi::pictLoad("graphics\\traffic_light_mask.bmp").
            
      draw(WindowGDI, _Rect, Cars) :-!,
           WndRect = rct(0, 0, boardWidth, boardHeight),
           BackWH = pictOpen(WndRect), 
           drawCity(BackWH, cityGenerator::maxCol,cityGenerator::maxRow),
           drawCars(Cars,BackWH),
           Pict = pictClose(BackWH), 
           WindowGDI:pictDraw(Pict, pnt(10, 10), rop_SrcCopy).

    class predicates
       drawCars:(car_list Cars,windowHandle WindowHandle) procedure (i, i).
    clauses
      drawCars([],_).
      drawCars([HeadCar|[]],BackWH):-!,
         drawCar(BackWH, HeadCar).
      drawCars([HeadCar|TailCars],BackWH):-
         drawCar(BackWH, HeadCar),
         drawCars(TailCars,BackWH).

class predicates
    drawCity:(windowHandle WindowHandle, integer I, integer J) procedure (i, i, i). 
clauses
    drawCity(_, I, _) :-
        I<0,!.
    drawCity(WindowHandle,I,J):-
        J<0,!,
        drawCity(WindowHandle,I-1,cityGenerator::maxRow).
    drawCity(WindowHandle,I,J) :-
        drawCityCell(I,J,WindowHandle),!,
        drawCity(WindowHandle,I,J-1).

class predicates
    drawCityCell:(integer CellI,integer CellJ,windowHandle WindowHandle) procedure (i, i, i).
clauses  
    drawCityCell(I,J,WindowHandle):-
        cityGenerator::getCellType(I,J,Type),
        loadCellImg(Type, Pict),!,
        vpi::pictDraw(WindowHandle, Pict,  pnt(I*cellImgSize, J*cellImgSize), rop_SrcCopy),
        
        drawLightTraffic(I,J,WindowHandle),
        
        % debug  
        %  vpi::winsetPen(WindowHandle,pen(1, ps_solid, color_DarkOrange)),
        %  vpi::winsetForeColor(WindowHandle,color_DarkSeaGreen),
        %  vpi::winSetBrush(WindowHandle,brush(pat_Hollow, 0)),
        %  vpi::winSetBackMode(WindowHandle, vpiDomains::bk_Transparent),
        %  vpi::winSetFont(WindowHandle, vpi::fontCreateByName("Tahoma", 8)),
        
        %  vpi::drawTextInRect(WindowHandle, 
        %       rct(I*cellImgSize,J*cellImgSize,I*cellImgSize+cellImgSize,J*cellImgSize+cellImgSize),
        %       string::format("%d,%d",I,J),
        %       [vpiDomains::dtext_center, dtext_vcenter]
        %  ),
        !.
    drawCityCell(_I,_J,_WindowHandle).
        
class predicates
      drawLightTraffic:(integer I,integer J,windowHandle WindowHandle) procedure (i, i, i).
clauses
      drawLightTraffic(I,J, WindowHandle):-
        Light = cityTrafficLights::getLight(I,J),
        trafficLightPict(Light,Pict),
        vpi::pictDraw(WindowHandle, trafficLightMask, pnt(I*cellImgSize, J*cellImgSize), rop_SrcAnd),        
        vpi::pictDraw(WindowHandle, Pict, pnt(I*cellImgSize, J*cellImgSize), rop_SrcInvert),
        !.
      drawLightTraffic(_I,_J,_WindowHandle).

class predicates
    trafficLightPict:(integer, picture) procedure (i,o).
clauses
    trafficLightPict(cityTrafficLights::lightGreen, Pict):-
        Pict = trafficLightGreen,!.
    trafficLightPict(cityTrafficLights::lightYellowRed, Pict):-
        Pict = trafficLightYellow,!.
    trafficLightPict(cityTrafficLights::lightYellowGreen, Pict):-
        Pict = trafficLightYellow,!.
    trafficLightPict(_, Pict):-
        Pict = trafficLightRed,!.
    
class predicates
    drawCar:(windowHandle WindowHandle,car Car) procedure (i, i).
clauses    
    drawCar(WindowHandle, Car) :-
        pnt(CarX,CarY) = Car:getPosition(),
        Dir = Car:getDirection(),
        loadCarMask(Dir,CarMask),        
        loadCarImg(Car,CarPict),
        vpi::pictDraw(WindowHandle, CarMask, pnt(CarX,CarY), rop_SrcAnd),
        vpi::pictDraw(WindowHandle, CarPict, pnt(CarX,CarY), rop_SrcInvert),
        %pnt(I,J) = Car:getCell(),
        %vpi::drawText(WindowHandle,CarX,CarY+20,string::format("%d,%d",I,J)),
        !.

class predicates
    loadCellImg:(integer Type,picture Pict) determ (i, o).
clauses                 
    loadCellImg(Type,Pict) :-
        Type = cityGenerator::cellEmpty, !,
        Pict= cityEmpty.
    loadCellImg(Type,Pict) :-
        Type = cityGenerator::cellBuilding, !,
        Pict= cityBuilding.           
    loadCellImg(Type, Pict) :-
        Type = cityGenerator::cellRoad, !,
        Pict= cityRoad.

class predicates
    loadCarMask:(integer Dir,picture Mask) procedure (i,o).
clauses     
    loadCarMask(Dir,Mask) :- 
        Dir = car::dirTop, !,
        Mask= carTopMask.
    loadCarMask(Dir,Mask) :- 
        Dir = car::dirLeft, !,
        Mask= carLeftMask.
    loadCarMask(Dir,Mask) :- 
        Dir = car::dirRight, !,
        Mask= carRightMask.
    loadCarMask(Dir,Mask) :- 
        Dir = car::dirBottom, !,
        Mask= carDownMask.
    loadCarMask(_Dir, erroneousPict).
        
class predicates
    loadCarImg:(car Car, picture Pict) procedure (i,o).
clauses
    loadCarImg(Car, Pict):-
        ClassName = Car:getClassName(),
        ClassName = carUser::className,
        Dir = Car:getDirection(),
        loadCarUserImg(Dir,Pict),!.
    loadCarImg(Car, Pict):-
        Dir = Car:getDirection(),
        loadCarOtherImg(Dir,Pict),!.
        
class predicates
    loadCarOtherImg:(integer Dir,picture Pict) procedure (i,o).
clauses
    loadCarOtherImg(Dir,Pict) :- 
        Dir = car::dirTop, !,
        Pict= carTop.
    loadCarOtherImg(Dir,Pict) :- 
        Dir = car::dirLeft, !,
        Pict= carLeft.
    loadCarOtherImg(Dir,Pict) :- 
        Dir = car::dirRight, !,
        Pict= carRight.
    loadCarOtherImg(Dir,Pict) :- 
        Dir = car::dirBottom, !,
        Pict= carDown.
    loadCarOtherImg(_, erroneousPict).

class predicates
    loadCarUserImg:(integer Dir,picture Pict) procedure (i,o).
clauses
    loadCarUserImg(Dir,Pict) :- 
        Dir = car::dirTop,
        Pict= carUserTop,!.
    loadCarUserImg(Dir,Pict) :- 
        Dir = car::dirLeft,
        Pict= carUserLeft,!.
    loadCarUserImg(Dir,Pict) :- 
        Dir = car::dirRight,
        Pict= carUserRight,!.
    loadCarUserImg(Dir,Pict) :- 
        Dir = car::dirBottom,
        Pict= carUserDown,!.
    loadCarUserImg(_, erroneousPict).        
                 
end implement draw
