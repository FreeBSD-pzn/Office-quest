FUNCTION IDPrint
PARAMETERS s
PRIVATE sprn,i,j,k,line,strlen,margin,Ok,bLastHandler,objErr,buf,oldc,swhile
  swhile="|/-\"
  buf=savescreen( 24,00,24,01 )
  oldc=setcolor("+W/B")
  if CursorON
     SET CURSOR OFF
  endif
  GetDevPrint()
  line=mlcount(s)
  margin=int( PPLeft*iif(PPFont==2.or.PPFont==4,1.2,1)/iif(PPFont>2,0.6,1) )

  SET CONSOLE OFF
  SET PRINT ON
  SET PRINTER TO &PrinterDevice
  sprn=chr(13)   // Перед печатью устанавливаем в начало строки

  bLastHandler :=ERRORBLOCK( { |objErr| PrintError( objErr ) } )
  k=1
  @ 24,00 SAY " ]"
  FOR i=1 TO line
    sprn=sprn+space(margin)+rtrim(memoline(s,79,i,8))
    if i==line
      sprn=sprn+chr(13)+chr(10)
    endif
    strlen=len(sprn)
    j=1
    Ok=.T.
    do while Ok .and. j<=strlen
      BEGIN SEQUENCE
       ?? substr(sprn,j,1)
      RECOVER
         Ok=PrintRetry()
      END
      if ErrorState
         ErrorState=.F.
      else
         j=j+1
         k=iif(k=4,1,k+1)
         @ 24,00 SAY substr(swhile,k,1)
      endif
    enddo
    if !Ok
      EXIT
    endif
    if (i%PPPage)==0
      sprn=chr(12)
    else
      sprn=chr(13)+chr(10)
    endif
  NEXT
  ERRORBLOCK(bLastHandler)
  SET PRINTER TO
  SET PRINT OFF
  SET CONSOLE ON
  restscreen( 24,00,24,01,buf )
  setcolor(oldc)
  if CursorON
     SET CURSOR ON
  endif
RETURN 0

FUNCTION GetDevPrint
PRIVATE oldc,buf
    buf=savescreen( 13,18,18,63 )
    oldc=setcolor("+W/W")
    @ 13,18,18,63 BOX "┌─┐│┘─└│ "
    SET COLOR TO N/W
    @ 14,20 SAY "Введите имя устройства : [            ]"
    SET COLOR TO B/W,+W/B
    @ 15,23 SAY    "имя устройства для принтера может быть"
    @ 16,23 SAY    "либо PRN, LPT1, LPT2, COM1 и так далее"
    @ 17,23 SAY    "либо имя файла в формате DOS.         "
    tone(262,9)
    PrinterDevice=PrinterDevice+space(12-len(PrinterDevice))
    SET CURSOR ON
    @ 14,46 GET PrinterDevice PICTURE     "XXXXXXXXXXXX"
    READ
    SET CURSOR OFF
    PrinterDevice=alltrim( PrinterDevice )
    restscreen( 13,18,18,63,buf )
    setcolor(oldc)
RETURN 0

FUNCTION PrintRetry
PRIVATE request,key,oldc,buf
    request=.T.
    key=0
    buf=savescreen( 13,18,18,63 )
    oldc=setcolor("+W/W")
    @ 13,18,18,63 BOX "┌─┐│┘─└│ "
    @ 14,20 SAY "Ваш принтер не готов к работе и Вы можете:"
    tone(262,9)
    do while key!=13
       if request
          SET COLOR TO BR/W
          @ 15,22 SAY "▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄"
          @ 17,22 SAY "▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀"
          SET COLOR TO +W/W
          @ 15,43 TO 17,59
          SET COLOR TO +W/BR
          @ 16,22 SAY " Повторить печать "
          SET COLOR TO +W/W
          @ 16,44 SAY "Отменить печать"
       else
          SET COLOR TO BR/W
          @ 15,43 SAY "▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄"
          @ 17,43 SAY "▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀"
          SET COLOR TO +W/W
          @ 15,22 TO 17,39
          SET COLOR TO +W/W
          @ 16,23 SAY "Повторить печать"
          SET COLOR TO +W/BR
          @ 16,43 SAY " Отменить печать "
       endif
       key=0
       do while key==0
          key=inkey()
       enddo
       do case
          case key=4
               request=.F.
          case key=19
               request=.T.
       endcase
    enddo
restscreen( 13,18,18,63,buf )
setcolor(oldc)
RETURN request

FUNCTION PrintError( objError )
  ErrorState=.T.
  BREAK objError
RETURN 0
