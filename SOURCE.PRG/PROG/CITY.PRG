STATIC InAppend

FUNCTION City
PRIVATE k,filename,str,flag
  filename=IDPath+"city.dbf"
  InAppend=.F.
  *-------------------------------------------------
  SET COLOR TO +W/B
  @ 12,00,23,79 BOX "┌─┐│┘─└│ "
  @ 12,25 SAY "┬"
  @ 12,53 SAY "┬"
  @ 12,66 SAY "┬"
  @ 23,01 SAY "[                      ]┴"
  @ 23,53 SAY "┴[          ]┴"
  @ 13,25 SAY "│"+space(27)+"│            │"
  @ 14,25 SAY "│"+space(27)+"│            │"
  @ 15,25 SAY "│"+space(27)+"│            │"
  @ 16,25 SAY "│"+space(27)+"│            │"
  @ 17,25 SAY "│"+space(27)+"│            │"
  @ 18,25 SAY "│"+space(27)+"│            │"
  @ 19,25 SAY "│"+space(27)+"│            │"
  @ 20,25 SAY "│"+space(27)+"│            │"
  @ 21,25 SAY "│"+space(27)+"│            │"
  @ 22,25 SAY "│"+space(27)+"│            │"
  SET COLOR TO N/BG
  @ 23,02 SAY space(22)
  @ 23,55 SAY space(10)
  SET COLOR TO +W/BR
  SET COLOR TO +W/BR
  @ 24,04 SAY "помощь   "
  @ 24,15 SAY "встречи  "
  @ 24,26 SAY "дела     "
  @ 24,37 SAY "тел.спр. "
  @ 24,48 SAY "блокнот  "
  @ 24,59 SAY "добавить "
  @ 24,71 SAY "выход   "
  SET COLOR TO +W/N
  @ 24,02 SAY "F1"
  @ 24,13 SAY "F2"
  @ 24,24 SAY "F3"
  @ 24,35 SAY "F4"
  @ 24,46 SAY "F5"
  @ 24,57 SAY "F7"
  @ 24,68 SAY "Esc"
  flag=IDCalendarON
  if flag
     SET COLOR TO W/N
     @ 09,00 SAY "▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█"
     SET COLOR TO +W/N
     @ 11,00 SAY "▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█"
     IDCalendarON=.F.
  endif
  SET COLOR TO +W/B,N/W
  *-------------------------------------------------
  if file(filename)
  SELECT 6
  USE &filename
  SET EXACT OFF
  *-------------------------------------------------
  str=""
  k=0
  do while .T.
    dbedit(13,01,22,78,"","InCity","","","")
    k=lastkey()
    if k==27     && сбpасываем все что было
       if TheEnd()==0
         k=0
         EXIT
       endif
    endif
    if k==-1 .or. k==-2 .or. k==-3 .or. k==-4
       EXIT
    endif
  enddo
  SET EXACT ON
  USE
  else
   SET COLOR TO N/W
   @ 13,15,21,64 BOX "┌─┐│┘─└│ "
   @ 14,17 SAY '   В настоящий момент к персональной информа-'
   @ 15,17 SAY 'ционной  системе не подключена справочная ин-'
   @ 16,17 SAY 'формация о междугородних телефонных кодах.   '
   @ 17,17 SAY '   Данная информация  хранится в файле с име-'
   @ 18,17 SAY 'нем CITY.DBF.  Обратитесь к оператору  или  к'
   @ 19,17 SAY 'руководству оператора  для  устранения причин'
   @ 20,17 SAY 'недоступности данной информации.             '
   do while .T.
      k=GetKey()
      if k==27
         if TheEnd()==0
           k=0
           EXIT
         endif
      endif
      if k==-1 .or. k==-2 .or. k==-3 .or. k==-4
         EXIT
      endif
   enddo
  endif
  if flag
     SET COLOR TO W/N
     @ 11,00 SAY "▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█▄█"
     SET COLOR TO +W/N
     @ 09,00 SAY "▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█▀█"
     IDCalendarON=.T.
  endif
RETURN k


FUNCTION InCity
PARAMETERS status, fld_ptr
PRIVATE request,oldc,fld_name,key,oldr
request=1
oldc=setcolor("N/BG")
key=lastkey()
fld_name=field(fld_ptr)
  DO CASE
     CASE status=0
          if(!empty(str) .and. (key<32 .or. key>255) .and. key!=13 )
            str=""
            @ 23,02 SAY space(22)
            @ 23,55 SAY space(10)
          endif
          if InAppend
             InAppend=.F.
             AppendCity()
             request=2
          endif
     CASE status=3   && no records
     CASE status=4
          if key=7           && удаление информации
            if YesDeleted()
               if .not.deleted()
                 request=2
                 DELETE
                 PACK
               endif
            endif
          endif
          if key==-6   && добавить запись
             request=3
             InAppend=.T.
          endif
          if key==-7   && editing record
             EditCity()
          endif
          if key==-1 .or. key==-2 .or. key==-3 .or. key==-4
             request=0
          endif
          if key==27
             request=0
          endif
          if( fld_name=="CITY" .or. fld_name=="ID")
             if key==8 .and. !empty(str)  && стереть последний символ
                str=substr(str,1,len(str)-1)
             endif
             if key==13 .and. !empty(str)  && найти следующее
                oldr=recno()
                CONTINUE
                if !eof()
                  request=2
                else
                  goto oldr
                endif
             endif
             if( key>31 .and. key<255 )
                 str=str+chr(key)
                 if(fld_name=="CITY")
                   @ 23,02 SAY str+space(22-len(str))
                 else
                   @ 23,55 SAY str+space(10-len(str))
                 endif
                 oldr=recno()
                 go top
                 LOCATE FOR &fld_name =str
                 if !eof()
                   request=2
                 else
                   goto oldr
                   str=substr(str,1,len(str)-1)
                 endif
             endif

             if(fld_name=="CITY")
               @ 23,02 SAY str+space(22-len(str))
             else
               @ 23,55 SAY str+space(10-len(str))
             endif
          endif
  ENDCASE
setcolor(oldc)
RETURN request


FUNCTION AppendCity
PARAMETERS request,oldr,mCITY,mCOUNTRY,mID,mTELEPHON
request =.F.
oldr=recno()
mCITY    =space(22)
mCOUNTRY =space(25)
mID      =space(10)
mTELEPHON=space(10)
  SET CURSOR ON
  CursorON=.T.
  @ row(),02 GET mCITY
  @ row(),27 GET mCOUNTRY
  @ row(),55 GET mID
  @ row(),68 GET mTELEPHON
  READ
  SET CURSOR OFF
  CursorON=.F.
  if !empty(mCITY) .and. !empty(mID)
     APPEND BLANK
     REPLACE CITY     WITH mCITY
     REPLACE COUNTRY  WITH mCOUNTRY
     REPLACE ID       WITH mID
     REPLACE TELEPHON WITH mTELEPHON
     request=.T.
  endif
RETURN request


FUNCTION EditCity
PARAMETERS request,mCITY,mCOUNTRY,mID,mTELEPHON
request =.F.
mCITY    =CITY
mCOUNTRY =COUNTRY
mID      =ID
mTELEPHON=TELEPHON
  SET CURSOR ON
  CursorON=.T.
  @ row(),02 GET mCITY
  @ row(),27 GET mCOUNTRY
  @ row(),55 GET mID
  @ row(),68 GET mTELEPHON
  READ
  SET CURSOR OFF
  CursorON=.F.
  if !empty(mCITY) .and. !empty(mID)
     if mCITY !=CITY .or. mCOUNTRY!=COUNTRY .or. mID!=ID .or. mTELEPHON!=TELEPHON
     REPLACE CITY     WITH mCITY
     REPLACE COUNTRY  WITH mCOUNTRY
     REPLACE ID       WITH mID
     REPLACE TELEPHON WITH mTELEPHON
     COMMIT
     request=.T.
     endif
  endif
RETURN request
