FUNCTION first
  *--------------------------------------------------
  * Формирование экрана
  *
  SET COLOR TO W/N
  CLEAR
  @ 24,00 SAY "Copyright            1995"
  @ 00,00,23,79 BOX "┌─┐│┘─└│"
  SET COLOR TO +W/N
  *@ 01,01,22,78 BOX "         "
  *@ 02,48,13,73 BOX "         "
  @ 02,49 SAY  "┌──────────────────────┐"
  @ 03,49 SAY  "│             ▄▄▄▄▄▄▄▄▄▄▄"
  @ 04,49 SAY  "│           ▄▀ ▄▄▄▄▄▄▄▄▄▄"
  @ 05,49 SAY  "│         ▄▀ ▄▀ ▄▄▄▄▄▄▄▄▄"
  @ 06,49 SAY  "│       ▄▀ ▄▀ ▄▀       │"
  @ 07,49 SAY  "│     ▄▀ ▄▀ ▄▀ ▄▀      │"
  @ 08,49 SAY  "│      ▄▀ ▄▀ ▄▀ ▄▀     │"
  @ 09,49 SAY  "│       ▄▀ ▄▀ ▄▀       │"
  @ 10,48 SAY "▀▀▀▀▀▀▀▀▀ ▄▀ ▄▀         │"
  @ 11,48 SAY "▀▀▀▀▀▀▀▀▀▀ ▄▀           │"
  @ 12,48 SAY "▀▀▀▀▀▀▀▀▀▀▀             │"
  @ 13,49 SAY  "│                      │"
  @ 14,49 SAY  "│                      │"
  @ 15,49 SAY  "└──────────────────────┘"
  @ 15,08 SAY "▄▄▄▄ ПЕРСОHАЛЬHАЯ   ▄▄▄▄"
  @ 17,11 SAY "▄▄▄▄ ИHФОРМАЦИОHHАЯ ▄▄▄▄"
  @ 19,14 SAY "▄▄▄▄ СИСТЕМА        ▄▄▄▄"
  @ 24,10 SAY "Олег Пызин"
  SET COLOR TO +GR/N
  *@ 12,04,13,28 BOX "         "
  @ 13,05 SAY '▄▄▄▄ "OFFICE-QUEST" ▄▄▄▄'

  *
  * Конец формирования экрана
  *--------------------------------------------------
  InitHelp()
  PathOffice=alltrim(gete("OFFICE"))
  IDPath=PathOffice
  IDName="Олег Пызин"
  IDNumber=0
  InitConfig()
  inkey(1)
RETURN .T.
***
*  Конец функции first()
***

*--
*
*--
FUNCTION InpPassword
PARAMETERS str,y,x,len
PRIVATE i,key
  key =0
  i=0
  @ y,x SAY ""
  do while i<len(str)
    @ y,x+i SAY "*"
    i++
  enddo
  i   =len(str)
  do while key<>13
     key=0
     do while key=0
        key=inkey()
     enddo
     if key=27
        RETURN .F.
     endif
     if key>32 .and. key<255 .and. i<len-1
        str=str+chr(key)
        @ y,x+i SAY "*"
        i=i+1
     else
        if key=8 .and. i>0
           i=i-1
           @ y,x+i SAY " "
           str=substr(str,1,i)
           @ y,x+i SAY ""
        else
        endif
     endif
  enddo
RETURN .T.
***
*  Конец функции InpPassword()
***

*--
*
*--
FUNCTION InpName
PARAMETERS str,y,x,len
PRIVATE i,key
  key =0
  @ y,x SAY str
  i   =len(str)
  do while key<>13
     key=0
     do while key=0
        key=inkey()
     enddo
     if key=27
        RETURN .F.
     endif
     if key>=32 .and. key<255 .and. i<len-1
        str=str+chr(key)
        @ y,x SAY str
        i=i+1
     else
        if key=8 .and. i>0
           i=i-1
           @ y,x+i SAY " "
           str=substr(str,1,i)
           @ y,x SAY str
        else
        endif
     endif
  enddo
RETURN .T.
***
*  Конец функции InpName()
***

FUNCTION InitConfig
PRIVATE sCgf,line,sparam,i,swhat,svalue,equal,comment

* Значения по умолчанию
ModemDevice = "COM2"
ModemDial   = "ATDP"
choice      = -1

if file(PathOffice+"office.cfg")
  sCgf=memoread(PathOffice+"office.cfg")
  line=mlcount(sCgf)
  FOR i=1 TO line
    sparam = memoline(sCgf,79,i,8)
    sparam = alltrim(sparam)
    if at(";",sparam) != 1
    equal   = at("=",sparam)
    comment = at(";",sparam)
    comment = iif(comment=0, len(sparam), comment-1 )
    if equal > 0
      swhat  = upper(alltrim(substr( sparam, 1, equal-1 )))
      svalue = upper(alltrim(substr( sparam, equal+1, comment-equal )))
      if !empty(swhat) .and. !empty(svalue)
      DO CASE
         CASE swhat = "MODEM"
              ModemDevice = svalue
         CASE swhat = "DIAL"
              ModemDial = svalue
         CASE swhat = "CHOICE"
              choice = int(val(svalue))
              if choice >= 0
                 choice = -1
              else
                if choice < -5
                   choice = -1
                endif
              endif
      ENDCASE
      endif
    endif
    endif
  NEXT
endif

RETURN 0
