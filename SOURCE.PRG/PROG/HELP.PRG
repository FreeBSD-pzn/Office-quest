// Пеpеменные котоpые локальны для Help()
STATIC InCountStart:=0

FUNCTION Help
PARAMETERS Name,progline,Input
PRIVATE buf,oldc,in,len,x,y,line
if InHelp
  RETURN
else
  InHelp=.T.
endif
len=0
buf=savescreen( 12,0,24,79 )
oldc=setcolor("+BG/BG")
x=col()
y=row()
line=1
@ 12,00,23,79 BOX "█▀███▄██ "
SET COLOR TO +W/BR
@ 24,0 SAY space(80)
if CursorON
   SET CURSOR OFF
endif
       @ 24,0 SAY "  Esc-выход  PgUp,PgDn-на стpаницу назад/вперед"+;
                  "  "+chr(24)+","+chr(25)+"-на строку назад/впеpед"
       SET COLOR TO N/BG
       DO CASE
          CASE IDHelp="Meeting"
               line=300
          CASE IDHelp="Business"
               line=175
          CASE IDHelp="Telephone"
               line=414
          CASE IDHelp="Notepad"
               line=581
          CASE IDHelp="City"
               line=638
       ENDCASE
       if IDCalendarON
             line=40
       endif
       InHelp(line)
restscreen( 12,0,24,79,buf )
setcolor(oldc)
@ y,x SAY ""       && установить куpсоp на место
if CursorON
   SET CURSOR ON
endif
InHelp=.F.
RETURN 0

FUNCTION InHelp
PARAMETERS line
PRIVATE    k,start
  start=line
  DispHelp(start)
  DO WHILE .T.
    k=GetKey()
    DO CASE
       CASE k= 5
            start=iif(start>1,start-1,1)
       CASE k=24
            start=iif(start+10<716,start+1,707)
       CASE k=18
            start=iif(start-9<1,1,start-9)
       CASE k= 3
            start=iif(start+19>716,707,start+9)
       CASE k=31
            start=1
       CASE k=30
            start=707
       CASE k=27
         RETURN 0
    ENDCASE
  DispHelp(start)
  ENDDO
*RETURN 0

FUNCTION DispHelp
PARAMETERS start
PRIVATE y,i
  FOR i=1 TO 10
    @ 12+i,03 SAY sHelp[start+i-1]
  NEXT
RETURN 0

FUNCTION StrDosErr
PARAMETERS err
RETURN "Смотри руководство по операционной системе."
