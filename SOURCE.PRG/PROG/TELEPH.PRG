*----------------------------------------------------------------------------
*  Телефонный справочник
*----------------------------------------------------------------------------
#include "office.ch"

FUNCTION Telephone
PRIVATE request,filename
request=0
***-------------------------------------
*  Подготовка базы данных к работе
filename=IDPath+"telephon.dbf"
SELECT 4
USE &filename
filename=IDPath+"telephon.ntx"
INDEX ON Fio TO &filename
go top
*  Конец подготовки базы данных к работе
***-------------------------------------
request=_Telephone()
USE
RETURN request

*----------------------------------------------------------------------------
*  Подпрограмма работы со списком
*----------------------------------------------------------------------------
FUNCTION _Telephone
PRIVATE choice,cnt,YouKey,key,i,cnt_f,max_f,y,old_y,delta

choice="*?АБВГДЕЖЗИКЛМНОПРСТУФХЦЧШЩЭЮЯABCDEFGHIJKLMNOPQRSTUVWXYZ"
cnt=0
YouKey='*'
cnt_f =1
y     =0
old_y =0
i=1
max_f=0
delta=0
*---------------------------------
SET COLOR TO +W/W
@ 12,00,23,67 BOX "╔═╗║╝═╚║ "
@ 12,41 SAY "╤"
@ 13,41 SAY "│"
@ 14,41 SAY "│"
@ 15,41 SAY "│"
@ 16,41 SAY "│"
@ 17,41 SAY "│"
@ 18,41 SAY "│"
@ 19,41 SAY "│"
@ 20,41 SAY "│"
@ 21,41 SAY "│"
@ 22,41 SAY "│"
@ 23,41 SAY "╧"
@ 12,68,23,68 BOX "         "
@ 12,69,23,79 BOX "╔═╗║╝═╚║ "
@ 13,71 SAY "*  И  У"
@ 14,71 SAY "?  К  Ф"
@ 15,71 SAY "А  Л  Х"
@ 16,71 SAY "Б  М  Ц"
@ 17,71 SAY "В  Н  Ч"
@ 18,71 SAY "Г  О  Ш"
@ 19,71 SAY "Д  П  Щ"
@ 20,71 SAY "Е  Р  Э"
@ 21,71 SAY "Ж  С  Ю"
@ 22,71 SAY "З  Т  Я"
SET COLOR TO +GR/N
@ 13,71 SAY "*"
SET COLOR TO W/N
@ 13,70 SAY "▌"
@ 13,72 SAY "▐"
SET COLOR TO +W/BR
@ 24,04 SAY "помощь   "
@ 24,15 SAY "встречи  "
@ 24,26 SAY "дела     "
@ 24,37 SAY "блокнот  "
@ 24,48 SAY "межгоpод "
@ 24,59 SAY "добавить "
@ 24,71 SAY "выход   "
SET COLOR TO +W/N
@ 24,02 SAY "F1"
@ 24,13 SAY "F2"
@ 24,24 SAY "F3"
@ 24,35 SAY "F5"
@ 24,46 SAY "F6"
@ 24,57 SAY "F7"
@ 24,68 SAY "Esc"
*---------------------------------
max_f =MaxFields()
delta =iif(max_f>1,19.99999/(max_f-1),19.99999)
*---------------------------------------------
*  рисуем движок положения указателя на записи
*---------------------------------------------
SET COLOR TO +W/N
@ 13,68,22,68 BOX "         "
@ 13+int(y/2),68 SAY iif(y%2>0,"▄","▀")
*---------------------------------------------
i=PutTelephone()
DO WHILE .T.
   key=GetKey()
   SET COLOR TO +W/W
   DO CASE
      CASE key=27       && Выход по Esc
           if TheEnd()==0
              RETURN 0
           endif
      CASE key=-1       && переход на встречи
           RETURN key
      CASE key=-2       && переход на дела
           RETURN key
      CASE key=-3       && набpать номеp
           DialTelephon(alltrim(GetTelephon()))
      CASE key=-4       && переход на блокнот
           RETURN key
      CASE key=-5       && переход на межгоpод
           RETURN key
      CASE key=-6       && добавить новую запись
           AppendTelephone()
      CASE key=-7       && редактировать запись
           EditTelephone()
           y     =0        && движок в верхнее положение
           cnt_f =1        && указатель на пеpвую запись
           i=PutTelephone()
      CASE key=-8       && распечатать содержимое справочника
           if !(eof().and.bof())
             PrintTelephone()
           endif
      CASE key=19    && Курсор влево
           if What>1 .and. !(bof().and.eof())
             REPLACE What WITH What-1
             COMMIT
             SET COLOR TO +W/B
             SPutTelephone(i)
           endif
      CASE key=4     && Курсор впpаво
           if What<9 .and. !(bof().and.eof())
             REPLACE What WITH What+1
             COMMIT
             SET COLOR TO +W/B
             SPutTelephone(i)
           endif
      CASE key=0           && для регенирации из Calendar()
           i=PutTelephone()
      CASE key=13          && выведем данные из справочника по выбору
           max_f=ChoiceFields(YouKey)
           delta =iif(max_f>1,19.99999/(max_f-1),19.99999)
           y     =0        && движок в верхнее положение
           cnt_f =1        && указатель на пеpвую запись
           i=PutTelephone()
      CASE key=7           && удаление информации
        if max_f>0       && если есть что удалять
          if YesDeleted()
             if .not.deleted()
               DELETE
               PACK
               REINDEX
               COMMIT
             endif
             max_f=max_f-1
             delta =iif(max_f>1,19.99999/(max_f-1),19.99999)
             y     =0  && движок в верхнее положение
             cnt_f =1  && указатель на пеpвую запись
             i=PutTelephone()
          endif
        endif
      CASE key=303      && нажата Alt + V
           ViewTelephone()
      CASE key=294      && нажата Alt + L или русская Д (досье)
           ViewAbout()
      CASE key=5
        @ 23,68 SAY " "
        if i>1
           SPutTelephone(i)
           skip -1
           i=i-1
           cnt_f=cnt_f-1
           y=(cnt_f-1)*delta
           SET COLOR TO +W/B
           SPutTelephone(i)
        else
           if .not.bof()
              SPutTelephone(i)
              skip -1
              if .not.bof()
                 scroll( 13,01,22,66,-1 )
                 cnt_f=cnt_f-1
                 y=(cnt_f-1)*delta
              else
                 @ 12,68 SAY chr(25)
                 go top
              endif
              SET COLOR TO +W/B
              SPutTelephone(i)
           endif
        endif
      CASE key=24
        @ 12,68 SAY " "
        if .not.eof() .and. i<10
           SPutTelephone(i)
           skip
           if .not.eof()
              i=i+1
              cnt_f=cnt_f+1
              y=(cnt_f-1)*delta
           else
              @ 23,68 SAY chr(24)
              go bottom
           endif
           SET COLOR TO +W/B
           SPutTelephone(i)
        else
           if .not.eof()
              SPutTelephone(i)
              skip
              if .not.eof()
                 scroll( 13,01,22,66,1 )
                 cnt_f=cnt_f+1
                 y=(cnt_f-1)*delta
              else
                 @ 23,68 SAY chr(24)
                 go bottom
              endif
              SET COLOR TO +W/B
              SPutTelephone(i)
           endif
        endif
      OTHERWISE
         cnt=at( chr(rupper(key)),choice )
         if cnt>0
            YouKey=chr(rupper(key))
         endif
         if cnt>30
            cnt=cnt-31
            SET COLOR TO +W/W
            @ 13,70 SAY " A  K  U "
            @ 14,70 SAY " B  L  V "
            @ 15,70 SAY " C  M  W "
            @ 16,70 SAY " D  N  X "
            @ 17,70 SAY " E  O  Y "
            @ 18,70 SAY " F  P  Z "
            @ 19,70 SAY " G  Q    "
            @ 20,70 SAY " H  R    "
            @ 21,70 SAY " I  S    "
            @ 22,70 SAY " J  T    "
            *--------------------
            * выделение буквы
            *--------------------
            SET COLOR TO N/W
            @ 13+cnt%10,72+3*int(cnt/10) SAY "▌"
            @ 13+cnt%10,70+3*int(cnt/10) SAY "▐"
            SET COLOR TO +GR/N
            @ 13+cnt%10,71+3*int(cnt/10) SAY YouKey
         else
            if cnt>0
               cnt=cnt-1
               SET COLOR TO +W/W
               @ 13,70 SAY " *  И  У "
               @ 14,70 SAY " ?  К  Ф "
               @ 15,70 SAY " А  Л  Х "
               @ 16,70 SAY " Б  М  Ц "
               @ 17,70 SAY " В  Н  Ч "
               @ 18,70 SAY " Г  О  Ш "
               @ 19,70 SAY " Д  П  Щ "
               @ 20,70 SAY " Е  Р  Э "
               @ 21,70 SAY " Ж  С  Ю "
               @ 22,70 SAY " З  Т  Я "
               *--------------------
               * выделение буквы
               *--------------------
               SET COLOR TO N/W
               @ 13+cnt%10,72+3*int(cnt/10) SAY "▌"
               @ 13+cnt%10,70+3*int(cnt/10) SAY "▐"
               SET COLOR TO +GR/N
               @ 13+cnt%10,71+3*int(cnt/10) SAY YouKey
            endif
         endif
   ENDCASE
   *---------------------------------------------
   *  рисуем движок положения указателя на записи
   *---------------------------------------------
   if int(old_y)!=int(y)
      SET COLOR TO +W/N
      @ 13+int(old_y/2),68 SAY " "
      @ 13+int(y/2),68 SAY iif(int(y)%2>0,"▄","▀")
      old_y=y
   endif
ENDDO
*----------------------------------------------------------------------------
*  Конец подпрограммы _Telephone
*----------------------------------------------------------------------------

FUNCTION PutTelephone
PRIVATE i,oldc
  oldc=setcolor("+W/W")
  @ 12,68 SAY " "
  @ 23,68 SAY " "
  @ 12,00,23,67 BOX "╔═╗║╝═╚║ "
  @ 12,41 SAY "╤"
  @ 13,41 SAY "│"
  @ 14,41 SAY "│"
  @ 15,41 SAY "│"
  @ 16,41 SAY "│"
  @ 17,41 SAY "│"
  @ 18,41 SAY "│"
  @ 19,41 SAY "│"
  @ 20,41 SAY "│"
  @ 21,41 SAY "│"
  @ 22,41 SAY "│"
  @ 23,41 SAY "╧"
  go top
  i=1
  if !( eof() .and. bof() )
     DO WHILE .not.eof() .and. i<11
        SPutTelephone(i)
        skip
        i=i+1
     ENDDO
     go top
     i=1
     SET COLOR TO +W/B
     SPutTelephone(i)
  endif
  setcolor(oldc)
RETURN 1
***
* Конец подпрограммы
***

FUNCTION SPutTelephone
PARAMETERS y,s
     s=Fio
#ifdef PWD_TELE
     decrypt_cl( @s,@s,40 )
#endif
     @ 12+y,1  SAY s+"│ "+GetTelephon()
RETURN 1
***
* Конец подпрограммы SPutTelephone()
***

FUNCTION GetTelephon
PRIVATE s
  s=space(24)
  DO CASE
     CASE What=1
        s=Number01
     CASE What=2
        s=Number02
     CASE What=3
        s=Number03
     CASE What=4
        s=Number04
     CASE What=5
        s=Number05
     CASE What=6
        s=Number06
     CASE What=7
        s=Number07
     CASE What=8
        s=Number08
     CASE What=9
        s=Number09
  ENDCASE
#ifdef PWD_TELE
  decrypt_cl( @s,@s,24 )
#endif
RETURN s

*------
*
*------
FUNCTION rupper
PARAMETERS ii
RETURN iif( ii>127,iif(ii>=160.and.ii<=175,ii-32,;
                   iif(ii>=224.and.ii<=239,ii-80,ii)),;
                   iif(ii>=97 .and.ii<=122,ii-32,ii))
***
*  Конец функции rupper()
***

FUNCTION ChoiceFields
PARAMETERS Choice
PRIVATE i,_search,oldc,buf,s
i=0
_search=space(40)
oldc=setcolor("+GR/BR,+GR/BR")
buf =space(352)
SET FILTER TO             && отмена выбора
go top
  if Choice='*'
     do while .not.eof()
        REPLACE Yes WITH 'Y'
        skip
        i=i+1
     enddo
  else
    if Choice='?'
       buf=savescreen( 16,23,19,66 )
       @ 16,23,19,66 BOX "┌─┐│┘─└│ "
       @ 17,25 SAY "Что Вы хотите найти ?"
       @ 18,24 SAY "->"
       SET CURSOR ON
       CursorON=.T.
       @ 18,26 GET _search
       READ
       SET CURSOR OFF
       CursorON=.F.
       restscreen( 16,23,19,66,buf )
       if .not.empty(_search)
       do while .not.eof()
          s=Fio
#ifdef PWD_TELE
          decrypt_cl( @s,@s,40 )
#endif
          if at( alltrim(_search),s )>0
             REPLACE Yes WITH 'Y'
             i=i+1
          else
             REPLACE Yes WITH ' '
          endif
          skip
       enddo
       else
         i=MaxFields()
       endif
    else
       do while .not.eof()
          s=Fio
#ifdef PWD_TELE
          decrypt_cl( @s,@s,40 )
#endif
          if( substr(s,1,1)==Choice )
             REPLACE Yes WITH 'Y'
             i=i+1
          else
             REPLACE Yes WITH ' '
          endif
          skip
       enddo
    endif
  endif
COMMIT
SET FILTER TO Yes='Y'     && устанавливаем фильтр
go top                    && активизируем выбранный фильтр
setcolor(oldc)
RETURN i
***
*  Конец функции ChoiceFields()
***

FUNCTION MaxFields
PRIVATE i
i=0
SET FILTER TO Yes='Y'
GO TOP
DO WHILE .not.eof()
   skip
   i=i+1
ENDDO
RETURN i
***
*  End of MaxFields()
***

FUNCTION ViewTelephone
PRIVATE buf,oldc,s
  oldc=setcolor("+W/W")
  buf=savescreen( 12,00,24,79 )
  @ 13,01 CLEAR TO 22,66
  SET COLOR TO +BG/B
  @ 13,01 SAY "          Фамилия Имя Отчество          "
  @ 13,42 SAY "        Телефоны         "
  @ 16,01 SAY "               Реквизиты                "
  SET COLOR TO +W/BR
  @ 24,00 SAY space(80)
  @ 24,02 SAY "Esc-выйти из просмотра карточки"
  SET COLOR TO +W/W
  @ 12,41 SAY "╦"
  @ 13,41 SAY "║"
  @ 14,41 SAY "║ "
  @ 15,00 SAY "╠════════════════════════════════════════╣ "
  @ 16,41 SAY "║ "
  @ 17,41 SAY "║ "
  @ 18,41 SAY "║ "
  @ 19,41 SAY "║ "
  @ 20,41 SAY "║ "
  @ 21,41 SAY "║ "
  @ 22,41 SAY "║ "
  @ 23,41 SAY "╩"
  s=Fio
#ifdef PWD_TELE
  decrypt_cl( @s,@s,40 )
#endif
  @ 14,01 SAY s
  s=Label
#ifdef PWD_TELE
  decrypt_cl( @s,@s,240 )
#endif
  @ 17,01 SAY substr(s, 01,40)
  @ 18,01 SAY substr(s, 41,40)
  @ 19,01 SAY substr(s, 81,40)
  @ 20,01 SAY substr(s,121,40)
  @ 21,01 SAY substr(s,161,40)
  @ 22,01 SAY substr(s,201,40)
  @ 23,41 SAY "╩"
  s=Number01
#ifdef PWD_TELE
  decrypt_cl( @s,@s,24 )
#endif
  @ 14,43 SAY s
  s=Number02
#ifdef PWD_TELE
  decrypt_cl( @s,@s,24 )
#endif
  @ 15,43 SAY s
  s=Number03
#ifdef PWD_TELE
  decrypt_cl( @s,@s,24 )
#endif
  @ 16,43 SAY s
  s=Number04
#ifdef PWD_TELE
  decrypt_cl( @s,@s,24 )
#endif
  @ 17,43 SAY s
  s=Number05
#ifdef PWD_TELE
  decrypt_cl( @s,@s,24 )
#endif
  @ 18,43 SAY s
  s=Number06
#ifdef PWD_TELE
  decrypt_cl( @s,@s,24 )
#endif
  @ 19,43 SAY s
  s=Number07
#ifdef PWD_TELE
  decrypt_cl( @s,@s,24 )
#endif
  @ 20,43 SAY s
  s=Number08
#ifdef PWD_TELE
  decrypt_cl( @s,@s,24 )
#endif
  @ 21,43 SAY s
  s=Number09
#ifdef PWD_TELE
  decrypt_cl( @s,@s,24 )
#endif
  @ 22,43 SAY s
  do while GetKey()!=27
  enddo
  *-----------------------------
  * Восстановим экpан
  *-----------------------------
  restscreen( 12,00,24,79,buf )
  setcolor(oldc)
RETURN 0
***
*  End of ViewTelephone()
***


FUNCTION EditTelephone
PRIVATE buf,oldc,mFio,s,Label01,Label02,Label03,Label04,Label05
PRIVATE Label06,mNumber01,mNumber02,mNumber03,mNumber04,mNumber05
PRIVATE mNumber06,mNumber07,mNumber08,mNumber09
mFio      =Fio
s=Label
#ifdef PWD_TELE
  decrypt_cl( @mFio,@mFio,40 )
  decrypt_cl( @s,@s,240 )
#endif
Label01   =substr(s,  1,40)
Label02   =substr(s, 41,40)
Label03   =substr(s, 81,40)
Label04   =substr(s,121,40)
Label05   =substr(s,161,40)
Label06   =substr(s,201,40)
mNumber01 =Number01
mNumber02 =Number02
mNumber03 =Number03
mNumber04 =Number04
mNumber05 =Number05
mNumber06 =Number06
mNumber07 =Number07
mNumber08 =Number08
mNumber09 =Number09
#ifdef PWD_TELE
  decrypt_cl( @mNumber01,@mNumber01,24 )
  decrypt_cl( @mNumber02,@mNumber02,24 )
  decrypt_cl( @mNumber03,@mNumber03,24 )
  decrypt_cl( @mNumber04,@mNumber04,24 )
  decrypt_cl( @mNumber05,@mNumber05,24 )
  decrypt_cl( @mNumber06,@mNumber06,24 )
  decrypt_cl( @mNumber07,@mNumber07,24 )
  decrypt_cl( @mNumber08,@mNumber08,24 )
  decrypt_cl( @mNumber09,@mNumber09,24 )
#endif
  oldc=setcolor("+W/W")
  buf=savescreen( 12,00,24,79 )
  @ 13,01 CLEAR TO 22,66
  @ 12,41 SAY "╦"
  @ 13,41 SAY "║ "
  @ 14,41 SAY "║ "
  @ 15,00 SAY "╠════════════════════════════════════════╣ "
  @ 16,41 SAY "║ "
  @ 17,41 SAY "║ "
  @ 18,41 SAY "║ "
  @ 19,41 SAY "║ "
  @ 20,41 SAY "║ "
  @ 21,41 SAY "║ "
  @ 22,41 SAY "║ "
  @ 23,41 SAY "╩"
  SET COLOR TO +BG/B
  @ 13,01 SAY "          Фамилия Имя Отчество          "
  @ 13,42 SAY "        Телефоны         "
  @ 16,01 SAY "               Реквизиты                "
  SET COLOR TO +W/BR
  @ 24,00 SAY space(80)
  @ 24,02 SAY ""
  *----------------------------------------------
  SET COLOR TO +W/W
  do while .T.
     SET CURSOR ON
     CursorON=.T.
     @ 14,01 GET mFio
     @ 14,43 GET mNumber01
     @ 15,43 GET mNumber02
     @ 16,43 GET mNumber03
     @ 17,43 GET mNumber04
     @ 18,43 GET mNumber05
     @ 19,43 GET mNumber06
     @ 20,43 GET mNumber07
     @ 21,43 GET mNumber08
     @ 22,43 GET mNumber09
     @ 17,01 GET Label01
     @ 18,01 GET Label02
     @ 19,01 GET Label03
     @ 20,01 GET Label04
     @ 21,01 GET Label05
     @ 22,01 GET Label06
     READ
     SET CURSOR OFF
     CursorON=.F.
     if .not.empty(mFio)
       s=Label01+Label02+Label03+Label04+Label05+Label06
#ifdef PWD_TELE
       encrypt_cl( @mFio,@mFio,40 )
       encrypt_cl( @s,@s,240 )
       encrypt_cl( @mNumber01,@mNumber01,24 )
       encrypt_cl( @mNumber02,@mNumber02,24 )
       encrypt_cl( @mNumber03,@mNumber03,24 )
       encrypt_cl( @mNumber04,@mNumber04,24 )
       encrypt_cl( @mNumber05,@mNumber05,24 )
       encrypt_cl( @mNumber06,@mNumber06,24 )
       encrypt_cl( @mNumber07,@mNumber07,24 )
       encrypt_cl( @mNumber08,@mNumber08,24 )
       encrypt_cl( @mNumber09,@mNumber09,24 )
#endif
       REPLACE  Fio      WITH mFio
       REPLACE  Label    WITH s
       REPLACE  Number01 WITH mNumber01
       REPLACE  Number02 WITH mNumber02
       REPLACE  Number03 WITH mNumber03
       REPLACE  Number04 WITH mNumber04
       REPLACE  Number05 WITH mNumber05
       REPLACE  Number06 WITH mNumber06
       REPLACE  Number07 WITH mNumber07
       REPLACE  Number08 WITH mNumber08
       REPLACE  Number09 WITH mNumber09
       REINDEX
       COMMIT
       EXIT
     else
       MustBeInformation()
       mFio      =Fio
       s=Label
       #ifdef PWD_TELE
         decrypt_cl( @mFio,@mFio,40 )
         decrypt_cl( @s,@s,240 )
       #endif
       Label01   =substr(s,  1,40)
       Label02   =substr(s, 41,40)
       Label03   =substr(s, 81,40)
       Label04   =substr(s,121,40)
       Label05   =substr(s,161,40)
       Label06   =substr(s,201,40)
       mNumber01 =Number01
       mNumber02 =Number02
       mNumber03 =Number03
       mNumber04 =Number04
       mNumber05 =Number05
       mNumber06 =Number06
       mNumber07 =Number07
       mNumber08 =Number08
       mNumber09 =Number09
#ifdef PWD_TELE
       decrypt_cl( @mNumber01,@mNumber01,24 )
       decrypt_cl( @mNumber02,@mNumber02,24 )
       decrypt_cl( @mNumber03,@mNumber03,24 )
       decrypt_cl( @mNumber04,@mNumber04,24 )
       decrypt_cl( @mNumber05,@mNumber05,24 )
       decrypt_cl( @mNumber06,@mNumber06,24 )
       decrypt_cl( @mNumber07,@mNumber07,24 )
       decrypt_cl( @mNumber08,@mNumber08,24 )
       decrypt_cl( @mNumber09,@mNumber09,24 )
#endif
     endif
  enddo
  *-----------------------------
  * Восстановим экpан
  *-----------------------------
  restscreen( 12,00,24,79,buf )
  setcolor(oldc)
RETURN 0
***
*  End of EditTelephone()
***


FUNCTION AppendTelephone
PRIVATE buf,oldc,oldf,mFio,s,Label01,Label02,Label03,Label04,Label05
PRIVATE Label06,mNumber01,mNumber02,mNumber03,mNumber04,mNumber05
PRIVATE mNumber06,mNumber07,mNumber08,mNumber09
mFio      =space(40)
Label01   =space(40)
Label02   =space(40)
Label03   =space(40)
Label04   =space(40)
Label05   =space(40)
Label06   =space(40)
mNumber01 =space(24)
mNumber02 =space(24)
mNumber03 =space(24)
mNumber04 =space(24)
mNumber05 =space(24)
mNumber06 =space(24)
mNumber07 =space(24)
mNumber08 =space(24)
mNumber09 =space(24)
  oldc=setcolor("+W/W")
  if diskspace()>recsize()
      oldf=recno()
      buf=savescreen( 12,00,24,79 )
      @ 13,01 CLEAR TO 22,66
      @ 12,41 SAY "╦"
      @ 13,41 SAY "║ "
      @ 14,41 SAY "║ "
      @ 15,00 SAY "╠════════════════════════════════════════╣ "
      @ 16,41 SAY "║ "
      @ 17,41 SAY "║ "
      @ 18,41 SAY "║ "
      @ 19,41 SAY "║ "
      @ 20,41 SAY "║ "
      @ 21,41 SAY "║ "
      @ 22,41 SAY "║ "
      @ 23,41 SAY "╩"
      SET COLOR TO +BG/B
      @ 13,01 SAY "          Фамилия Имя Отчество          "
      @ 13,42 SAY "        Телефоны         "
      @ 16,01 SAY "               Реквизиты                "
      SET COLOR TO +W/BR
      @ 24,00 SAY space(80)
      @ 24,02 SAY ""
      *----------------------------------------------
      SET CURSOR ON
      CursorON=.T.
      SET COLOR TO +W/W,+W/W
      *----------------------------------------------
         @ 14,01 GET mFio
         @ 14,43 GET mNumber01
         @ 15,43 GET mNumber02
         @ 16,43 GET mNumber03
         @ 17,43 GET mNumber04
         @ 18,43 GET mNumber05
         @ 19,43 GET mNumber06
         @ 20,43 GET mNumber07
         @ 21,43 GET mNumber08
         @ 22,43 GET mNumber09
         @ 17,01 GET Label01
         @ 18,01 GET Label02
         @ 19,01 GET Label03
         @ 20,01 GET Label04
         @ 21,01 GET Label05
         @ 22,01 GET Label06
         READ
      SET CURSOR OFF
      CursorON=.F.
      if .not.empty(mFio)
         APPEND BLANK
         s=Label01+Label02+Label03+Label04+Label05+Label06
#ifdef PWD_TELE
         encrypt_cl( @mFio,@mFio,40 )
         encrypt_cl( @s,@s,240 )
         encrypt_cl( @mNumber01,@mNumber01,24 )
         encrypt_cl( @mNumber02,@mNumber02,24 )
         encrypt_cl( @mNumber03,@mNumber03,24 )
         encrypt_cl( @mNumber04,@mNumber04,24 )
         encrypt_cl( @mNumber05,@mNumber05,24 )
         encrypt_cl( @mNumber06,@mNumber06,24 )
         encrypt_cl( @mNumber07,@mNumber07,24 )
         encrypt_cl( @mNumber08,@mNumber08,24 )
         encrypt_cl( @mNumber09,@mNumber09,24 )
#endif
         REPLACE  Fio      WITH mFio
         REPLACE  Label    WITH s
         REPLACE  Number01 WITH mNumber01
         REPLACE  Number02 WITH mNumber02
         REPLACE  Number03 WITH mNumber03
         REPLACE  Number04 WITH mNumber04
         REPLACE  Number05 WITH mNumber05
         REPLACE  Number06 WITH mNumber06
         REPLACE  Number07 WITH mNumber07
         REPLACE  Number08 WITH mNumber08
         REPLACE  Number09 WITH mNumber09
         REPLACE  What     WITH 1
         REINDEX
         COMMIT   && сбросим буфера на диск
         goto oldf
      endif
      *-----------------------------
      * Восстановим экpан
      *-----------------------------
      restscreen( 12,00,24,79,buf )
  else
     NotDiskSpace()
  endif
  setcolor(oldc)
RETURN 0
***
*  End of AppendTelephone()
***

FUNCTION ViewAbout
PRIVATE oldc,buf,s,k
  oldc=setcolor("+BG/B")
  buf =savescreen( 12,13,24,79 )
  @ 12,13,24,79 BOX "╔═╗║╝═╚║ "
  @ 12,16 SAY "╛ ДОСЬЕ ╘"
  *@ 13,15,22,77 BOX "         "
  SET COLOR TO +W/BR
  @ 13,14 SAY "     │    │         │ Esc-выйти  F2-выйти и сохранить F1-помощь  "
  SET COLOR TO +BG/B
  SET CURSOR ON
  CursorON=.T.
  @ 14,15 SAY ""
  readinsert(.T.)
  k=-8
  s=About
  do while k==-8
    s=memoedit( s,14,15,23,77,.T.,"AboutEdit",70 )
    k=lastkey()
    if k==-8
       IDPrint(s)
    endif
  enddo
  SET CURSOR OFF
  CursorON=.F.
  if lastkey()!=27
     REPLACE About WITH s
     COMMIT
  endif
  restscreen( 12,13,24,79,buf  )
  setcolor(oldc)
RETURN 0
***
*  End of ViewAbout()
***

FUNCTION AboutEdit
PARAMETERS status,line,col
PRIVATE request,oldc,x,y,key
  request=0
  x=col()
  y=row()
  key=lastkey()
  if CursorON
     SET CURSOR OFF
  endif
  oldc=setcolor("+W/BR")
  DO CASE
     CASE status=3
        if readinsert()
          @ 13,26 SAY "Вставка"
        else
          @ 13,26 SAY "Замена "
        endif
     CASE status=0
        @ 13,15 SAY str( line,4 )
        @ 13,20 SAY str( col ,4 )
  ENDCASE
  if key==-1 .or. key==-8   && Hажата F2-выход с сохpанением или F9-pаспечатать
     request=23
  endif
  if key==22    && Если нажата клавиша Insert
  if status==1 .or. status==2
     if !readinsert()
        @ 13,26 SAY "Вставка"
     else
        @ 13,26 SAY "Замена "
     endif
  endif
  endif
  setcolor(oldc)
  @ y,x SAY ""          && установить куpсоp на место
  if CursorON
     SET CURSOR ON
  endif
RETURN request
***
*  End of AboutEdit()
***

FUNCTION DialTelephon
PARAMETERS s
 PRIVATE i,Ok,bLastHandler,objErr
 i=1
 do while (asc(substr(s,i,1))>asc("9") .or. asc(substr(s,i,1))<asc("0")) .and. i<=len(s)
    i=i+1
 enddo
 if !empty(substr(s,i))
    SET CONSOLE OFF
    SET PRINT ON
    SET PRINTER TO &ModemDevice
    Ok=.T.
    bLastHandler :=ERRORBLOCK( { |objErr| PrintError( objErr ) } )
    do while Ok
       BEGIN SEQUENCE
         ?? ModemDial+substr(s,i)+chr(13)
       RECOVER
         Ok=ModemRetry()
       END
       if ErrorState
          ErrorState=.F.
       else
          Ok=.F.
       endif
    enddo
    ERRORBLOCK(bLastHandler)
    SET PRINTER TO
    SET PRINT OFF
    SET CONSOLE ON
 endif
RETURN 0

FUNCTION ModemRetry
PRIVATE request,key,oldc,buf
    request=.T.
    key=0
    buf=savescreen( 13,18,18,63 )
    oldc=setcolor("+W/B")
    @ 13,18,18,63 BOX "┌─┐│┘─└│ "
    @ 14,21 SAY "Ваш модем не готов к работе и Вы можете:"
    tone(262,9)
    do while key!=13
       if request
          SET COLOR TO BR/B
          @ 15,22 SAY "▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄"
          @ 17,22 SAY "▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀"
          SET COLOR TO W/B
          @ 15,44 TO 17,59
          SET COLOR TO +W/BR
          @ 16,22 SAY " Повторить набор "
          SET COLOR TO +W/B
          @ 16,45 SAY "Отменить набор"
       else
          SET COLOR TO BR/B
          @ 15,44 SAY "▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄"
          @ 17,44 SAY "▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀"
          SET COLOR TO W/B
          @ 15,22 TO 17,38
          SET COLOR TO +W/B
          @ 16,23 SAY "Повторить набор"
          SET COLOR TO +W/BR
          @ 16,44 SAY " Отменить набор "
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

FUNCTION PrintTelephone
PRIVATE oldp,sp
oldp=recno()
sp=chr(13)+chr(10)
go top
do while !eof()
  sp=sp+Fio+chr(13)+chr(10)
  if !empty(Number01)
    sp=sp+space(8)+Number01+chr(13)+chr(10)
  endif
  if !empty(Number02)
    sp=sp+space(8)+Number02+chr(13)+chr(10)
  endif
  if !empty(Number03)
    sp=sp+space(8)+Number03+chr(13)+chr(10)
  endif
  if !empty(Number04)
    sp=sp+space(8)+Number04+chr(13)+chr(10)
  endif
  if !empty(Number05)
    sp=sp+space(8)+Number05+chr(13)+chr(10)
  endif
  if !empty(Number06)
    sp=sp+space(8)+Number06+chr(13)+chr(10)
  endif
  if !empty(Number07)
    sp=sp+space(8)+Number07+chr(13)+chr(10)
  endif
  if !empty(Number08)
    sp=sp+space(8)+Number08+chr(13)+chr(10)
  endif
  if !empty(Number09)
    sp=sp+space(8)+Number09+chr(13)+chr(10)
  endif
  skip
enddo
IDPrint(sp)
goto oldp
RETURN 0
