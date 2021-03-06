/*****************************************************************************

                        Copyright © 

******************************************************************************/

implement draw
   open core, vpiDomains, vpi, carDomains, drawDomains
   
   domains
    car_list = car*.

    
   constants
       cBOARD_WIDTH:positive = 672.
       cBOARD_HEIGHT:positive = 512.
       cMARGIN_LEFT:positive = 10.
       cMARGIN_TOP:positive = 10.
       
       cMENU_ITEM_HEIGHT:positive = 25.
       cMENU_ITEM1:rct = rct(250,225,450,225+cMENU_ITEM_HEIGHT).
       cMENU_ITEM2:rct = rct(250,250,450,250+cMENU_ITEM_HEIGHT).
       cMENU_ITEM1_SHADOW:rct = rct(251,226,451,226+cMENU_ITEM_HEIGHT).
       cMENU_ITEM2_SHADOW:rct = rct(251,251,451,251+cMENU_ITEM_HEIGHT).
       
       cMENU_TITLE:rct = rct(190,125,510,225).
       cMENU_TITLE_SHADOW:rct = rct(191,126,511,226).
       
       cMENU_SELECTOR:rct = rct(280,225,420,225+cMENU_ITEM_HEIGHT).
       
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
       
       destPoint: picture := erroneous.
       destPointMask: picture := erroneous.
              
       erroneousPict:picture := erroneous.
       
       timeFont:vpiDomains::font := erroneous.
       menuItemFont:vpiDomains::font := erroneous.
       menuTitleFont:vpiDomains::font := erroneous.
       topIdx:integer := 0.

   clauses
      classInfo("playground/draw/draw",  "1.0").

      load():-
% pre-load images and fonts
% for better performance
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
        trafficLightMask := vpi::pictLoad("graphics\\traffic_light_mask.bmp"),
        
        destPoint := vpi::pictLoad("graphics\\dest_point.bmp"),
        destPointMask := vpi::pictLoad("graphics\\dest_point_mask.bmp"),
        
        timeFont:=vpi::fontCreate(vpiDomains::ff_Helvetica,[vpiDomains::fs_Bold],10),
        menuItemFont:=vpi::fontCreate(vpiDomains::ff_Helvetica,[vpiDomains::fs_Bold],16),
        menuTitleFont:=vpi::fontCreate(vpiDomains::ff_Helvetica,[vpiDomains::fs_Bold],46).
            
      drawGame(WindowGDI, _Rect, TimeCount, ViolationTime) :-!,
%  Draw game screen:
%   - city as background
%   - draw cars
%   - draw timer
        UserCar = carManager::getUserCar(),
        CarsAI = carManager::getCarsAI(),

        WndRect = rct(0, 0, cBOARD_WIDTH, cBOARD_HEIGHT),
        BackWH = pictOpen(WndRect),

        drawCity(BackWH, cityGenerator::maxCol,cityGenerator::maxRow),
        drawCars(CarsAI,BackWH),
        drawUserCar(UserCar,ViolationTime,BackWH),
        drawTime(TimeCount,BackWH),
        
        Pict = pictClose(BackWH),
        WindowGDI:pictDraw(Pict, pnt(cMARGIN_LEFT, cMARGIN_TOP), rop_SrcCopy),!.

    drawMainMenu(WindowGDI, MenuItemSelected) :-
%  Draw game main menu screen:
%   - city as background
%   - header
%   - 2 menu items
%   - current menu item selection
        WndRect = rct(0, 0, cBOARD_WIDTH, cBOARD_HEIGHT),
        BackWH = pictOpen(WndRect),
    
        drawCity(BackWH, cityGenerator::maxCol,cityGenerator::maxRow),
    
        drawMenuTitle(BackWH),
        vpi::winSetFont(BackWH, menuItemFont),           
        vpi::winSetBackMode(BackWH, vpiDomains::bk_Transparent),
    
        vpi::winsetForeColor(BackWH,color_Black),
    
        vpi::drawTextInRect(BackWH,cMENU_ITEM1_SHADOW, "Start Game", [vpiDomains::dtext_center] ),
        vpi::drawTextInRect(BackWH,cMENU_ITEM2_SHADOW, "Top Ten", [vpiDomains::dtext_center] ),        
    
        vpi::winsetForeColor(BackWH,color_Orange),
        
        vpi::drawTextInRect(BackWH,cMENU_ITEM1, "Start Game", [vpiDomains::dtext_center] ),
        vpi::drawTextInRect(BackWH,cMENU_ITEM2, "Top Ten", [vpiDomains::dtext_center] ),        
    
        vpi::winsetPen(BackWH,pen(1, ps_solid, color_DarkOrange)),
        vpi::winSetBrush(BackWH,brush(pat_Hollow, 0)),
        
        rct(LX,LT,RX,RB) = cMENU_SELECTOR,
        vpi::drawRect(BackWH, rct(LX,LT+MenuItemSelected*cMENU_ITEM_HEIGHT,RX,RB+MenuItemSelected*cMENU_ITEM_HEIGHT)),
        
        Pict = pictClose(BackWH),           
        WindowGDI:pictDraw(Pict, pnt(cMARGIN_LEFT, cMARGIN_TOP), rop_SrcCopy),!.

    drawTopTen(WindowGDI):-
%  Draw Top10 screen:
%   - city as background
%   - header
%   - 10 items with scores
        WndRect = rct(0, 0, cBOARD_WIDTH, cBOARD_HEIGHT),
        BackWH = pictOpen(WndRect),

        drawCity(BackWH, cityGenerator::maxCol,cityGenerator::maxRow),
        
        vpi::winSetBackMode(BackWH, vpiDomains::bk_Transparent),
        
        List = topTenManager::getTopTen(),
        topIdx:=0,
        foreach Value = list::getMember_nd(List) do
            drawTopPos(topIdx, Value,BackWH),
            topIdx:=topIdx+1
        end foreach,

        drawMenuTitle(BackWH),
                   
        Pict = pictClose(BackWH),           
        WindowGDI:pictDraw(Pict, pnt(cMARGIN_LEFT, cMARGIN_TOP), rop_SrcCopy),!.


    drawFinish(WindowGDI, Score):-
%  Draw game finish screen:
%   - city as background
%   - header
%   - game finished message
%   - reached score
        WndRect = rct(0, 0, cBOARD_WIDTH, cBOARD_HEIGHT),
        BackWH = pictOpen(WndRect),

        drawCity(BackWH, cityGenerator::maxCol,cityGenerator::maxRow),
        vpi::winSetBackMode(BackWH, vpiDomains::bk_Transparent),

        vpi::winsetForeColor(BackWH,color_Black),
        vpi::drawTextInRect(BackWH,cMENU_ITEM1_SHADOW, "Game Finished.", [vpiDomains::dtext_center] ),
        vpi::drawTextInRect(BackWH,cMENU_ITEM2_SHADOW, string::format("Your Score: %d",Score), [vpiDomains::dtext_center] ),
        
        vpi::winsetForeColor(BackWH,color_Orange),
        vpi::drawTextInRect(BackWH,cMENU_ITEM1, "Game Finished.", [vpiDomains::dtext_center] ),
        vpi::drawTextInRect(BackWH,cMENU_ITEM2, string::format("Your Score: %d",Score), [vpiDomains::dtext_center] ),

        drawMenuTitle(BackWH),
        
        Pict = pictClose(BackWH),           
        WindowGDI:pictDraw(Pict, pnt(cMARGIN_LEFT, cMARGIN_TOP), rop_SrcCopy),!.   

class predicates
    drawTopPos:(integer Idx, integer Value, windowHandle WindowHandle).
clauses
    drawTopPos(Idx,Value,WindowHandle):-
        rct(LXS,LTS,RXS,RBS) = cMENU_ITEM1_SHADOW,
        rct(LX,LT,RX,RB) = cMENU_ITEM1,
        vpi::winsetForeColor(WindowHandle,color_Black),
        vpi::drawTextInRect(WindowHandle,rct(LXS,LTS+Idx*cMENU_ITEM_HEIGHT,RXS,RBS+Idx*cMENU_ITEM_HEIGHT), string::format("%2d. %d",Idx+1,Value), [vpiDomains::dtext_left] ),
        vpi::winsetForeColor(WindowHandle,color_Orange),
        vpi::drawTextInRect(WindowHandle,rct(LX,LT+Idx*cMENU_ITEM_HEIGHT,RX,RB+Idx*cMENU_ITEM_HEIGHT), string::format("%2d. %d",Idx+1,Value), [vpiDomains::dtext_left] ),!.
        
        
class predicates
    drawMenuTitle:(windowHandle WindowHandle).
clauses
    drawMenuTitle(WindowHandle):-
        vpi::winSetFont(WindowHandle, menuTitleFont),
        vpi::winSetBackMode(WindowHandle, vpiDomains::bk_Transparent),
        vpi::winsetForeColor(WindowHandle,color_Black),
        vpi::drawTextInRect(WindowHandle,cMENU_TITLE_SHADOW, "The Cars", [vpiDomains::dtext_center] ),        
        vpi::winsetForeColor(WindowHandle,color_Orange),
        vpi::drawTextInRect(WindowHandle,cMENU_TITLE, "The Cars", [vpiDomains::dtext_center] ),!.
        
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
    drawCars:(car_list Cars,windowHandle WindowHandle) procedure (i, i).
clauses
      drawCars([],_).
      drawCars([HeadCar|TailCars],BackWH):-
         drawCar(HeadCar,BackWH),
         drawCars(TailCars,BackWH).
        
class predicates
    drawUserCar:(car Car,integer ViolationTime, windowHandle WindowHandle) procedure (i,i,i).
clauses
    drawUserCar(Car,ViolationTime,WindowHandle):-
        drawCar(Car,WindowHandle),
        drawUserViolations(Car,ViolationTime,WindowHandle),
        drawCarDest(Car,WindowHandle).
        
class facts
    userViolations:violation_list := [].
    tmpTime:integer:=0.
    tmpList:violation_list := [].
class predicates
    drawUserViolations:(car UserCar,integer ViolationTime, windowHandle WindowHandle) procedure (i,i,i). 
clauses
    drawUserViolations(UserCar,ViolationTime, WindowHandle):-
        if ViolationTime > 0,! then
            Pos = UserCar:getPosition(),
            userViolations := list::append([violation(Pos,ViolationTime,0)],userViolations)
        end if,
        
        vpi::winSetBackMode(WindowHandle, vpiDomains::bk_Transparent),

        tmpList := [],       
        foreach Vio = list::getMember_nd(userViolations) do
            violation(pnt(X,Y),Value,Timeout) = Vio,
            tmpTime:=Timeout,
            
            vpi::winsetForeColor(WindowHandle,color_Black),
            vpi::drawText(WindowHandle,X+1,Y+cellImgSize-Timeout+1,string::format("+%d",Value)),
            vpi::winsetForeColor(WindowHandle,color_Red),
            vpi::drawText(WindowHandle,X,Y+cellImgSize-Timeout,string::format("+%d",Value)),
            
            tmpTime := tmpTime+1,
            if tmpTime < 100,! then
                tmpList := list::append([violation(pnt(X,Y),Value,tmpTime)],tmpList)
            end if
            
        end foreach,
        
        userViolations:=tmpList,!.
    
        
class predicates
    drawTime:(integer TimeCount,windowHandle WindowHandle) procedure (i,i).
clauses
    drawTime(TimeCount,WindowHandle):-
        TimeStr = string::format("Time: %.2f s.",TimeCount / 1000),
        vpi::winsetForeColor(WindowHandle,color_White),
        vpi::winSetBackMode(WindowHandle, vpiDomains::bk_Transparent),

      %  vpi::winSetFont(WindowHandle, timeFont),
        vpi::drawText(WindowHandle,cMARGIN_LEFT+10,cMARGIN_TOP+10,TimeStr).


        
class predicates
    drawCar:(car Car,windowHandle WindowHandle) procedure (i, i).
clauses    
    drawCar(Car, WindowHandle) :-
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
    drawCarDest:(car Car, windowHandle WindowHandle) procedure (i, i).
clauses    
    drawCarDest(Car, WindowHandle) :-
        pnt(I,J) = Car:getDestCell(),
        vpi::pictDraw(WindowHandle, destPointMask, pnt(I*cellImgSize,J*cellImgSize), rop_SrcAnd),
        vpi::pictDraw(WindowHandle, destPoint, pnt(I*cellImgSize,J*cellImgSize), rop_SrcInvert),!.    

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
