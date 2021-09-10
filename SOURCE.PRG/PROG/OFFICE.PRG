#include "inkey.ch"
#include "office.ch"

PROCEDURE Office
SET SCOREBOARD OFF        && ОТКЛЮЧЕНИЕ СООБЩЕНИЙ В 0 СТРОКЕ ЭКРАНА
SET CONFIRM    ON         && НАЖАТЬ ENTER ПО ЗАВЕРШЕНИИ ВВОДА
SET DATE       GERMAN
SET ESCAPE     OFF
SET EXACT      ON
SET CURSOR     OFF
*---------------------------------------------------------------------------
*---------------------------------------------------------------------------
*           ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ
*---------------------------------------------------------------------------
PUBLIC ErrorState,ModemDevice,ModemDial,PrinterDevice,PPPage,PPLeft,PPFont,;
       PathOffice,IDmax,IDNumber,IDPassword,IDName,IDPath,IDHelp,;
       IDTelephonON,IDCalendarON,CursorON,InHelp,;
       Mdate,MCdate,BeginCalendar,MiddleCalendar,EndCalendar,Bday,Eday,;
       MeetingDay
*--------------------------------------------------
ErrorState=.F.        && возникла ли ошибка
***********************
ModemDevice=""
ModemDial  =""
***********************
PrinterDevice="LPT1"
PPPage=60
PPLeft=10
PPFont=2
***********************
PathOffice=""
IDmax=1               && максимальное количество пользователей системы
IDNumber=1
IDPassword=""
IDName  =""
IDPath  =""
IDHelp  =""
IDTelephonON =.F.
IDCalendarON =.T.
CursorON     =.F.     && везде где используем курсор устанавливать флаг
InHelp       =.F.
DECLARE sHelp[1000]
************************
***** Пеpеменные даты
Mdate         =date()   && дата внутpипpогpаммы, контpоль по системным часам
MCdate        =Mdate    && дата календаpя
BeginCalendar =Mdate
MiddleCalendar=Mdate
EndCalendar   =Mdate
Bday      =Mdate-ctod("1.1."+substr(dtoc(date()),-2) )
Eday      =ctod("31.12."+substr(dtoc(date()),-2) )-Mdate
*--------------------------------------------------
MeetingDay=.F.
choice=0
  *-----------------------------------------------
  * Сохраняем содержимое экрана
  *
  if diskspace()>4000
     handle=fcreate("screen.dat")
     fwrite( handle,savescreen(0,0,24,79),4000 )
     fclose( handle )
  endif
  x=col()
  y=row()
  *
  *-----------------------------------------------
  IF first()
      if HaveDatebase()
         PutScreen()
         MoveBusiness()
         do while .T.
#ifdef PWD
           setkey_cl("")
#endif
           do case
              case choice=0
                 EXIT
              case choice=-1
                 IDHelp="Meeting"
                 choice=MeetingDay()
              case choice=-2
                 IDHelp="Business"
                 choice=BusinessDay()
              case choice=-3
                 IDHelp="Telephone"
                 choice=Telephone()
              case choice=-4
                 IDHelp="Notepad"
                 choice=Notepad()
              case choice=-5
                 IDHelp="City"
                 choice=City()
              otherwise
                 choice=-1
           endcase
         enddo
      endif
  ENDIF
  *-----------------------------------------------
  * Восстанавливаем экран
  *
  if file("screen.dat")
     s=space(4000)
     handle=fopen("screen.dat")
     fread( handle,@s,4000 )
     fclose( handle )
     restscreen( 0,0,24,79,s )
  endif
  @ y,x SAY ""  && установить куpсоp на место
  *
  *-----------------------------------------------

CLOSE ALL
SET CURSOR ON
SET COLOR TO
RETURN
*===========================================================================
*                          END  PROGRAMM
*===========================================================================

*---------------------------------------------------------------------------
*  Подпрограмма вывода вида экрана календаря
*---------------------------------------------------------------------------
FUNCTION PutScreen
  SET COLOR TO W/N
  CLEAR
  @ 10,01 SAY "( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ("
  SET COLOR TO +W/W
  @ 00,00,08,79 BOX "         "
  @ 00,00 SAY "╔═══════╦═════════════════╦═════════╦═══╕           ╒═══╤══╤═══╕           ╒═══╗"
  @ 01,00 SAY "║"
  @ 01,79 SAY "║"
  @ 02,00 SAY "║"
  @ 02,79 SAY "║"
  @ 03,00 SAY "╠"
  @ 03,79 SAY "║"
  @ 04,00 SAY "║"
  @ 04,79 SAY "║"
  @ 05,00 SAY "║"
  @ 05,79 SAY "║"
  @ 06,00 SAY "║"
  @ 06,79 SAY "║"
  @ 07,00 SAY "║"
  @ 07,79 SAY "║"
  @ 08,00 SAY "╚═══════════════════════════════════╩═══════════════════╧══╧═══════════════════╝"
  @ 01,08 SAY "║                 ║    ┐    ║                   │  │"
  @ 02,08 SAY "║                 ║    └    ║                   │  │"
  @ 03,01 SAY "═══════╩═════════════════╩═════════╣                   │  │"
  @ 04,36 SAY "║                   │  │"
  @ 05,36 SAY "║                   │  │"
  @ 06,36 SAY "║                   │  │"
  @ 07,36 SAY "║                   │  │"

  SET COLOR TO +W/W
  PutDate(date())
  @ 01,02 SAY substr(time(),1,5)
  SET COLOR TO B/W
  @ 04,11 SAY '"OFFICE-QUEST"'
  @ 05,11 SAY "▀▀▀▀▀▀▀▀▀▀▀▀▀▀"
  @ 07,03 SAY "Copyright Олег Пызин Россия"
  SET COLOR TO N/W
  @ 12,00,24,79 BOX "         "
  if IDCalendarON
     SET COLOR TO W/N
     @ 11,00 SAY "▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█"
     SET COLOR TO +W/N
     @ 09,00 SAY "▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█"
  else
     SET COLOR TO W/N
     @ 09,00 SAY "▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█"
     SET COLOR TO +W/N
     @ 11,00 SAY "▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█"
  endif
  SET COLOR TO B/W
  @ 01,57 SAY "пн"
  @ 02,57 SAY "вт"
  @ 03,57 SAY "сp"
  @ 04,57 SAY "чт"
  @ 05,57 SAY "пт"
  SET COLOR TO BR/W
  @ 06,57 SAY "сб"
  SET COLOR TO R/W
  @ 07,57 SAY "вс"
  PutCalendar()
  SET COLOR TO +W/BR
  @ 24,0 SAY space(80)
RETURN 0
***
*  Конец подпрограммы put_screen()
***

FUNCTION GetKey
PRIVATE key,cbuf
  cbuf=setcolor("W/N")
  DO WHILE .T.
     key=_GetKey()
     if key=28    && вызов подсказки
        Help("",0,"")
     endif
#ifdef PWD
     if key==K_ALT_P
        GetPassword()
        key=0              // & возвpащаем 0 для pегенеpации
     endif
#endif
     if key=-9
       IDCalendarON=!IDCalendarON
       if IDCalendarON
          @ 11,00 SAY "▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█"
          SET COLOR TO +W/N
          @ 09,00 SAY "▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█"
       else
          @ 09,00 SAY "▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█"
          SET COLOR TO +W/N
          @ 11,00 SAY "▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█"
       endif
       setcolor(cbuf)
     endif
     if IDCalendarON
      if IDHelp != "Telephone"
        key=GetCalendar(key)
      endif
     endif
     if !IDCalendarON .or. key<=0 .or.key=27 .or. IDHelp = "Telephone"
      EXIT
     endif
  ENDDO
  setcolor(cbuf)
RETURN key
***
*  Конец функции получения кода нажатой клавиши GetKey()
***

FUNCTION _GetKey
PRIVATE key,cbuf,tic
  key=0
  cbuf=setcolor("W+/W")
  tic=space(5)
  if CursorON
     SET CURSOR OFF
  endif
  do while key=0
    tic=substr( time(),1,5 )
    @ 01,02 SAY tic
    if Mdate<>date()
       RETURN ChangeDate()  && возвpащаем 0 для pегенеpации экpана
    endif
    key=inkey()
  enddo
  if CursorON
     SET CURSOR ON
  endif
  setcolor(cbuf)
RETURN key
***
*  Конец функции получения кода нажатой клавиши _GetKey()
***

FUNCTION ChangeDate
  Mdate =date()
  Bday  =Mdate-ctod("1.1."+substr(dtoc(date()),-2) )
  Eday  =ctod("31.12."+substr(dtoc(date()),-2) )-Mdate
  PutDate()
  MoveBusiness()   && при смене даты менять и текущие дела
RETURN 0

FUNCTION PutDate
PRIVATE Sdate,b,e
  Sdate=str( day(Mdate),2 )+" "+ccmonth(month(Mdate))+str( year(Mdate),5 )
  b=int( (17-len(Sdate))/2 )
  e=17-len(Sdate)-b
  @ 01,09 SAY space(b)+Sdate+space(e)
  Sdate=ccdow( dow(Mdate) )
  b=int( (17-len(Sdate))/2 )
  e=17-len(Sdate)-b
  @ 02,09 SAY space(b)+Sdate+space(e)
  @ 01,28 SAY str(Bday,3)
  @ 02,32 SAY alltrim(str(Eday,3))
RETURN 0
***
*  Конец функции вывода новой даты PutDate()
***

FUNCTION ccmonth
PARAMETERS m
 DO CASE
    CASE m=1
         RETURN "января"
    CASE m=2
         RETURN "февраля"
    CASE m=3
         RETURN "марта"
    CASE m=4
         RETURN "апреля"
    CASE m=5
         RETURN "мая"
    CASE m=6
         RETURN "июня"
    CASE m=7
         RETURN "июля"
    CASE m=8
         RETURN "августа"
    CASE m=9
         RETURN "сентября"
    CASE m=10
         RETURN "октября"
    CASE m=11
         RETURN "ноября"
    CASE m=12
         RETURN "декабря"
 ENDCASE
***
*  Конец функции получения наименования месяца ccmonth()
***

FUNCTION ccdow
PARAMETERS w

 DO CASE
    CASE w=1
         RETURN "воскресенье"
    CASE w=2
         RETURN "понедельник"
    CASE w=3
         RETURN "вторник"
    CASE w=4
         RETURN "среда"
    CASE w=5
         RETURN "четверг"
    CASE w=6
         RETURN "пятница"
    CASE w=7
         RETURN "суббота"
 ENDCASE
***
*  Конец функции получения наименования недели ccdow()
***


FUNCTION TheEnd
PRIVATE i,key,oldc,buf
    i=1
    key=0
    buf=savescreen( 13,23,20,57 )
    oldc=setcolor("+BR/BR")
    @ 13,23,20,57 BOX "┌─┐│┘─└│ "
    SET COLOR TO +W/BR
    @ 14,26 SAY "ВЫ ДЕЙСТВИТЕЛЬНО ХОТИТЕ ВЫЙТИ"
    @ 15,34 SAY "ИЗ ПРОГРАММЫ ?"
    do while key!=13
       if i==0
         SET COLOR TO +BR/BR
         @ 17,28 SAY "█▀▀▀▀▀█"
         @ 18,28 SAY "█     █"
         @ 19,28 SAY "█▄▄▄▄▄█"
         SET COLOR TO +BR/G
         @ 17,46 SAY "█▀▀▀▀▀█"
         @ 18,46 SAY "█     █"
         @ 19,46 SAY "█▄▄▄▄▄█"
         SET COLOR TO +W/BR
         @ 18,29 SAY " НЕТ "
         SET COLOR TO +W/G
         @ 18,47 SAY " Д А "
       else
         SET COLOR TO +BR/G
         @ 17,28 SAY "█▀▀▀▀▀█"
         @ 18,28 SAY "█     █"
         @ 19,28 SAY "█▄▄▄▄▄█"
         SET COLOR TO +BR/BR
         @ 17,46 SAY "█▀▀▀▀▀█"
         @ 18,46 SAY "█     █"
         @ 19,46 SAY "█▄▄▄▄▄█"
         SET COLOR TO +W/G
         @ 18,29 SAY " НЕТ "
         SET COLOR TO +W/BR
         @ 18,47 SAY " Д А "
       endif
       key=0
       do while key==0
          key=inkey()
       enddo
       do case
          case key=4
               i=0
          case key=19
               i=1
       endcase
    enddo
restscreen( 13,23,20,57,buf )
setcolor(oldc)
RETURN i
***
*  Конец функции TheEnd()
***


FUNCTION YesDeleted
PRIVATE request,key,oldc,buf
    request=.F.
    key=0
    buf=savescreen( 13,23,20,57 )
    oldc=setcolor("+BR/BR")
    @ 13,23,20,57 BOX "┌─┐│┘─└│ "
    SET COLOR TO +W/BR
    @ 14,30 SAY "ВЫ ДЕЙСТВИТЕЛЬНО ХОТИТЕ"
    @ 15,32 SAY "удалить информацию ?"
    do while key!=13
       if request
         SET COLOR TO +BR/BR
         @ 17,28 SAY "█▀▀▀▀▀█"
         @ 18,28 SAY "█     █"
         @ 19,28 SAY "█▄▄▄▄▄█"
         SET COLOR TO +BR/G
         @ 17,46 SAY "█▀▀▀▀▀█"
         @ 18,46 SAY "█     █"
         @ 19,46 SAY "█▄▄▄▄▄█"
         SET COLOR TO +W/BR
         @ 18,29 SAY " НЕТ "
         SET COLOR TO +W/G
         @ 18,47 SAY " Д А "
       else
         SET COLOR TO +BR/G
         @ 17,28 SAY "█▀▀▀▀▀█"
         @ 18,28 SAY "█     █"
         @ 19,28 SAY "█▄▄▄▄▄█"
         SET COLOR TO +BR/BR
         @ 17,46 SAY "█▀▀▀▀▀█"
         @ 18,46 SAY "█     █"
         @ 19,46 SAY "█▄▄▄▄▄█"
         SET COLOR TO +W/G
         @ 18,29 SAY " НЕТ "
         SET COLOR TO +W/BR
         @ 18,47 SAY " Д А "
       endif
       key=0
       do while key==0
          key=inkey()
       enddo
       do case
          case key=4
               request=.T.
          case key=19
               request=.F.
       endcase
    enddo
restscreen( 13,23,20,57,buf )
setcolor(oldc)
RETURN request
***
*  End of YesDeleted()
***

#ifdef PWD
FUNCTION GetPassword
PRIVATE s,buf,oldc
 oldc=setcolor("CR/CR+")
 buf =savescreen( 14,24,18,57 )
 s=space(9)
 SET COLOR TO +R/BG
 @ 14,24 SAY "█▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀█"
 @ 15,24 SAY "█                                █"
 @ 16,24 SAY "█                                █"
 @ 17,24 SAY "█                                █"
 @ 18,24 SAY "█▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█"
 SET COLOR TO +W/BG
 @ 15,27 SAY "Введите пароль  [         ]"
 @ 17,27 SAY "Esc - отменить ввод пароля"
 s=""
 setkey_cl(s)        // сбросим ключи
 SET CURSOR ON
 CursorON=.T.
 if InpPassword( @s,15,44,9 )
    setkey_cl(s)     //установим ключи
 endif
 SET CURSOR OFF
 CursorON=.F.
 restscreen( 14,24,18,57,buf )
 setcolor( oldc )
RETURN 0
#endif
