*----------------------------------------------------------------------------
*
*----------------------------------------------------------------------------
FUNCTION PutCalendar
PRIVATE _month,cbuf,x,y,i
cbuf=setcolor("+W/W")

i=date()-day(date())+1
BeginCalendar=i
_month=month(i)
@ 0,41 SAY DateTitle(BeginCalendar)
SET COLOR TO N/W
y=rdow(i)
x=38+3*(int((day(i)+y-2)/7))
do while _month=month(i)
   if y=6
      SET COLOR TO RB/W
   endif
   if y=7
      SET COLOR TO R/W
   endif
   @ y,x SAY str(day(i),2)
   if y=6 .or. y=7
      SET COLOR TO N/W
   endif
   i=i+1
   y=iif(y=7,1,y+1)
   x=iif(y=1,x+3,x)
enddo

MiddleCalendar=i
_month=month(i)
SET COLOR TO +W/W
@ 0,64 SAY DateTitle(MiddleCalendar)
SET COLOR TO N/W
y=rdow(i)
x=61+3*(int((day(i)+y-2)/7))
do while _month=month(i)
   if y=6
      SET COLOR TO RB/W
   endif
   if y=7
      SET COLOR TO R/W
   endif
   @ y,x SAY str(day(i),2)
   if y=6 .or. y=7
      SET COLOR TO N/W
   endif
   i=i+1
   y=iif(y=7,1,y+1)
   x=iif(y=1,x+3,x)
enddo
EndCalendar=i-1
y=rdow(MCdate)
x=38+3*(int((day(MCdate)+rdow(BeginCalendar)-2)/7))
SET COLOR TO GR+/N
@ y,x SAY str(day(MCdate),2)
SET COLOR TO W/N
@ y,x-1 SAY "▌"
@ y,x+2 SAY "▐"
setcolor(cbuf)
RETURN 0
*----------------------------------------------------------------------------
*
*----------------------------------------------------------------------------


*----------------------------------------------------------------------------
*
*----------------------------------------------------------------------------
FUNCTION GetCalendar
PARAMETERS k
PRIVATE _date,oldc,x,y
oldc=setcolor("N/W")
_date=MCdate

 DO CASE
    CASE k=4      && rigth
      if _date+7<=EndCalendar
         _date=_date+7
      endif
    CASE k=19     && left
      if _date-7>=BeginCalendar
         _date=_date-7
      endif
    CASE k=5      && up
      if _date>BeginCalendar
         _date=_date-1
      endif
    CASE k=24     && down
      if _date<EndCalendar
         _date=_date+1
      endif
    CASE k=3      && pgdown
      y=rdow(MCdate)
      if y=6
         SET COLOR TO RB/W
      endif
      if y=7
         SET COLOR TO R/W
      endif
      if month(BeginCalendar)=month(MCdate)
         x=37+3*int((day(MCdate)+rdow(BeginCalendar)-2)/7)
      else
         x=60+3*int((day(MCdate)+rdow(MiddleCalendar)-2)/7)
      endif
      @ y,x SAY " "+str(day(MCdate),2)+" "
      FaceCalendar()
      MCdate=MiddleCalendar
      y=rdow(MCdate)
      x=61+3*int((day(MCdate)+rdow(MiddleCalendar)-2)/7)
      SET COLOR TO GR+/N
      @ y,x  SAY str(day(MCdate) ,2)
      SET COLOR TO W/N
      @ y,x-1 SAY "▌"
      @ y,x+2 SAY "▐"
      _date=MCdate
      k=0              && возвpащаем 0 для pегенеpации экpана
    CASE k=18     && pgup
      y=rdow(MCdate)
      if y=6
         SET COLOR TO RB/W
      endif
      if y=7
         SET COLOR TO R/W
      endif
      if month(BeginCalendar)=month(MCdate)
         x=37+3*int((day(MCdate)+rdow(BeginCalendar)-2)/7)
      else
         x=60+3*int((day(MCdate)+rdow(MiddleCalendar)-2)/7)
      endif
      @ y,x SAY " "+str(day(MCdate),2)+" "
      BackCalendar()
      MCdate=MiddleCalendar-1
      y=rdow(MCdate)
      x=38+3*int((day(MCdate)+rdow(BeginCalendar)-2)/7)
      SET COLOR TO GR+/N
      @ y,x  SAY str(day(MCdate) ,2)
      SET COLOR TO W/N
      @ y,x-1 SAY "▌"
      @ y,x+2 SAY "▐"
      _date=MCdate
      k=0               && возвpащаем 0 для pегенеpации экpана
 ENDCASE
 if _date<>MCdate
     y=rdow(MCdate)
     if y=6
        SET COLOR TO RB/W
     endif
     if y=7
        SET COLOR TO R/W
     endif
     if month(BeginCalendar)=month(MCdate)
        x=37+3*int((day(MCdate)+rdow(BeginCalendar)-2)/7)
     else
        x=60+3*int((day(MCdate)+rdow(MiddleCalendar)-2)/7)
     endif
     @ y,x SAY " "+str(day(MCdate),2)+" "
     *----------------------------------------------------
     *----------------------------------------------------
     y=rdow(_date)
     if month(BeginCalendar)=month(_date)
        x=38+3*int((day(_date)+rdow(BeginCalendar)-2)/7)
     else
        x=61+3*int((day(_date)+rdow(MiddleCalendar)-2)/7)
     endif
     SET COLOR TO GR+/N
     @ y,x  SAY str(day(_date) ,2)
     SET COLOR TO W/N
     @ y,x-1 SAY "▌"
     @ y,x+2 SAY "▐"
     MCdate=_date
     k=0       && возвpащаем 0 для pегенеpации экpана
 endif
setcolor(oldc)
RETURN k
*----------------------------------------------------------------------------
*
*----------------------------------------------------------------------------


*----------------------------------------------------------------------------
*
*----------------------------------------------------------------------------
FUNCTION FaceCalendar
PRIVATE _month,i,x,y
BeginCalendar=MiddleCalendar
MiddleCalendar=EndCalendar+1
restscreen( 0,38,7,54,savescreen(0,61,7,77) )
SET COLOR TO +W/W
@ 1,61 CLEAR TO 7,77
@ 0,64 SAY DateTitle(MiddleCalendar)
SET COLOR TO N/W
i=MiddleCalendar
y=rdow(i)
x=61+3*(int((day(i)+y-2)/7))
_month=month(i)
do while _month=month(i)
   if y=6
      SET COLOR TO RB/W
   endif
   if y=7
      SET COLOR TO R/W
   endif
   @ y,x SAY str(day(i),2)
   if y=6 .or. y=7
      SET COLOR TO N/W
   endif
   i=i+1
   y=iif(y=7,1,y+1)
   x=iif(y=1,x+3,x)
enddo
EndCalendar=i-1
RETURN 0
*----------------------------------------------------------------------------
*
*----------------------------------------------------------------------------


*----------------------------------------------------------------------------
*
*----------------------------------------------------------------------------
FUNCTION BackCalendar
PRIVATE _month,i,x,y
EndCalendar=MiddleCalendar-1
MiddleCalendar=BeginCalendar
restscreen( 0,61,7,77,savescreen(0,38,7,54) )
SET COLOR TO +W/W
@ 1,38 CLEAR TO 7,54
@ 0,41 SAY DateTitle(MiddleCalendar-1)
SET COLOR TO N/W
i=MiddleCalendar-1
y=rdow(i)
x=38+3*(int((day(i)+rdow(i-day(i)+1)-2)/7))
_month=month(i)
do while _month=month(i)
   if y=6
      SET COLOR TO RB/W
   endif
   if y=7
      SET COLOR TO R/W
   endif
   @ y,x SAY str(day(i),2)
   if y=6 .or. y=7
      SET COLOR TO N/W
   endif
   i=i-1
   y=iif(y=1,7,y-1)
   x=iif(y=7,x-3,x)
enddo
BeginCalendar=i+1
RETURN 0
*----------------------------------------------------------------------------
*
*----------------------------------------------------------------------------


*----------------------------------------------------------------------------
*
*----------------------------------------------------------------------------
FUNCTION rdow
PARAMETERS mdate
RETURN iif(dow(mdate)=1,7,dow(mdate)-1)
*----------------------------------------------------------------------------
*
*----------------------------------------------------------------------------


*----------------------------------------------------------------------------
*
*----------------------------------------------------------------------------
FUNCTION DateTitle
PARAMETERS mdate
PRIVATE m,request
 m=month(mdate)
 request=space(8)
 DO CASE
    CASE m=1
      request="январь"
    CASE m=2
      request="февраль"
    CASE m=3
      request="март"
    CASE m=4
      request="апрель"
    CASE m=5
      request="май"
    CASE m=6
      request="июнь"
    CASE m=7
      request="июль"
    CASE m=8
      request="август"
    CASE m=9
      request="сентябрь"
    CASE m=10
      request="октябрь"
    CASE m=11
      request="ноябрь"
    CASE m=12
      request="декабрь"
 ENDCASE
 request=request+" "+substr(str(year(mdate)),-2)
 request=space( (11-len(request))/2 )+request
RETURN request+space(11-len(request))
*----------------------------------------------------------------------------
*
*----------------------------------------------------------------------------
