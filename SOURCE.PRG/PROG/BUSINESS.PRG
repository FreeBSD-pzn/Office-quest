*--
*  Попрограмма вывода запланированных дел
*     параметры:
*                дата с которой оперировать
*--
#include "office.ch"

FUNCTION  BusinessDay
PRIVATE k,i,sprint,ptr

 SELECT 3                            && выбираем область дел
 SET FILTER TO  Begin<=MCdate.and.End>=MCdate
 GO TOP
 SET COLOR TO +W/BR
 @ 24,04 SAY "помощь   "
 @ 24,15 SAY "встречи  "
 @ 24,26 SAY "тел.спр. "
 @ 24,37 SAY "блокнот  "
 @ 24,48 SAY "межгород "
 @ 24,59 SAY "добавить "
 @ 24,71 SAY "выход   "
 SET COLOR TO +W/N
 @ 24,02 SAY "F1"
 @ 24,13 SAY "F2"
 @ 24,24 SAY "F4"
 @ 24,35 SAY "F5"
 @ 24,46 SAY "F6"
 @ 24,57 SAY "F7"
 @ 24,68 SAY "Esc"
 SET COLOR TO +W/W
 @ 12,00,23,79 BOX "╔═╗║╝═╚║ "
 @ 12,03 SAY "╤"
 @ 13,03 SAY "│"
 @ 14,03 SAY "│"
 @ 15,03 SAY "│"
 @ 16,03 SAY "│"
 @ 17,03 SAY "│"
 @ 18,03 SAY "│"
 @ 19,03 SAY "│"
 @ 20,03 SAY "│"
 @ 21,03 SAY "│"
 @ 22,03 SAY "│"
 @ 23,03 SAY "╧"
 i=PutBusiness()
 SET COLOR TO +W/W
 DO WHILE .T.
     k=GetKey()
     DO CASE
        CASE k=-1
          RETURN -1
        CASE k=-3
          RETURN -3
        CASE k=-4
          RETURN -4    && блокнот
        CASE k=-5
          RETURN -5    && межгоpод
        CASE k=27   && Нажата Esc
          if TheEnd()=0
             RETURN 0
          endif
        CASE k=0    && Если календарь и необходимо посмотреть
           SET FILTER TO  Begin<=MCdate.and.End>=MCdate
           GO TOP
           i=PutBusiness()
        CASE k=13
            if MCdate=End.and.date()=End  && выполнено только если даты совпадают
               REPLACE Yes WITH iif(empty(Yes),chr(251),chr(32) )
               COMMIT                && запишем на диск
               SET COLOR TO +W/B
               SPutBusiness(i)
               SET COLOR TO +W/W
            else
               NotDateEqual()
            endif
        CASE k=-6
          if date()<=MCdate
             @ 12,04 SAY chr(205)
             @ 23,04 SAY chr(205)
             AppendBusiness()
             i=PutBusiness()
          else
             NotAppendBusiness()
          endif
        CASE k=-7
          if !IDCalendarON .and. !(eof().and.bof())
            if End==Begin .and. Mdate<=End
               EditBusiness(i)
               SET COLOR TO +W/B
               SPutBusiness(i)
               SET COLOR TO +W/W
            else
               NotEditBusiness()
            endif
          endif
        CASE k=-8
          if !(eof().and.bof())
             ptr=recno()
             go top
             sprint=chr(13)+chr(10)+"     Дела на "+dtoc(MCdate)+chr(13)+chr(10)
             sprint=sprint+"┌──────────────────────────────────"+chr(13)+chr(10)
             do while !eof()
               sprint=sprint+"  "+alltrim(Business)+chr(13)+chr(10)
               skip
             enddo
             IDPrint(sprint)
             goto ptr
          endif
        CASE k=7
          if !IDCalendarON
            if End==Begin .and. Mdate<=End
               if .not.deleted()
                  DELETE
                  PACK
                  REINDEX
               endif
               i=PutBusiness()
            else
               NotDeleteBusiness()
            endif
          endif
        CASE k=5
          @ 23,04 SAY chr(205)
          if i>1
             SPutBusiness(i)
             skip -1
             i=i-1
             SET COLOR TO +W/B
             SPutBusiness(i)
          else
             if .not.bof()
                SPutBusiness(i)
                skip -1
                if .not.bof()
                   scroll( 13,02,22,77,-1 )
                else
                   @ 12,04 SAY chr(25)
                   go top
                endif
                SET COLOR TO +W/B
                SPutBusiness(i)
             endif
          endif
          SET COLOR TO +W/W
        CASE k=24
          @ 12,04 SAY chr(205)
          if .not.eof() .and. i<10
             SPutBusiness(i)
             skip
             if .not.eof()
                i=i+1
             else
                @ 23,04 SAY chr(24)
                go bottom
             endif
             SET COLOR TO +W/B
             SPutBusiness(i)
          else
             if .not.eof()
                SPutBusiness(i)
                skip
                if .not.eof()
                   scroll( 13,02,22,77,1 )
                else
                   @ 23,04 SAY chr(24)
                   go bottom
                endif
                SET COLOR TO +W/B
                SPutBusiness(i)
             endif
          endif
          SET COLOR TO +W/W
     ENDCASE
 ENDDO
 RETURN request
***
* Конец подпрограммы
***

FUNCTION PutBusiness
PRIVATE i,oldc
  oldc=setcolor("+W/W")
  GO TOP                              && делаем активный фильтр записей
  @ 13,01 CLEAR TO 22,02
  @ 13,04 CLEAR TO 22,78
  @ 13,03 SAY "│"
  @ 14,03 SAY "│"
  @ 15,03 SAY "│"
  @ 16,03 SAY "│"
  @ 17,03 SAY "│"
  @ 18,03 SAY "│"
  @ 19,03 SAY "│"
  @ 20,03 SAY "│"
  @ 21,03 SAY "│"
  @ 22,03 SAY "│"

  i=1
  @ 12,31 SAY chr(190)+" Дела на "+dtoc(MCdate)+" "+chr(212)
  if eof() .and. bof()
     @ 17,24 SAY "НА "+dtoc(MCdate)+" ДЕЛ НЕ ЗАПЛАНИРОВАНО"
  else
     DO WHILE .not.eof() .and. i<11
        SPutBusiness(i)
        skip
        i=i+1
     ENDDO
     go top
     i=1
     SET COLOR TO +W/B
     SPutBusiness(i)
  endif
  setcolor(oldc)
RETURN 1
***
* Конец подпрограммы
***

FUNCTION SPutBusiness
PARAMETERS y
PRIVATE s
     s=Business
#ifdef PWD_BUSI
     decrypt_cl(@s,@s,72)
#endif
     @ 12+y,1 SAY " "+iif(.not.empty(Yes),iif(MCdate<End,chr(7),Yes),Yes);
                  +chr(179)+" "+s+"  "
RETURN 1
***
* Конец подпрограммы SPutBusiness()
***

FUNCTION AppendBusiness
PRIVATE mbusiness,oldc
oldc=setcolor("N/BG,N/BG")
mbusiness=space(72)
  if diskspace()>recsize()+2048
     SET CURSOR ON
     CursorON=.T.
     @ 13,01 SAY "  ->"
     @ 13,77 SAY "  "
     @ 13,05 GET mbusiness
     READ
     SET CURSOR OFF
     CursorON=.F.
     mbusiness=mbusiness+space(72-len(mbusiness))
     if !empty(mbusiness)   && если ничего нет то не записывать
        APPEND BLANK
#ifdef PWD_BUSI
        encrypt_cl(@mbusiness,@mbusiness,72)
#endif
        REPLACE Business WITH mbusiness
        REPLACE Begin    WITH MCdate
        REPLACE End      WITH MCdate
        * в поле Yes ничего не пишем т.к. дело не выполнено
        REINDEX
        COMMIT   && сбросим буфера на диск
     endif
  else
     NotDiskSpace()
  endif
setcolor(oldc)
RETURN 0
***
* Конец подпрограммы
***

FUNCTION EditBusiness
PARAMETERS y
PRIVATE mbusiness,oldc
oldc=setcolor("N/BG,N/BG")
mbusiness=space(72)
  DO WHILE empty(mbusiness)
     mbusiness=Business
#ifdef PWD_BUSI
     decrypt_cl(@mbusiness,@mbusiness,72)
#endif
     SET CURSOR ON
     CursorON=.T.
     @ 12+y,01 SAY "  ->"
     @ 12+y,77 SAY "  "
     @ 12+y,05 GET mbusiness
     READ
     SET CURSOR OFF
     CursorON=.F.
     mbusiness=mbusiness+space(72-len(mbusiness))
     if !empty(mbusiness)   && если ничего нет то не записывать
#ifdef PWD_BUSI
        encrypt_cl(@mbusiness,@mbusiness,72)
#endif
        REPLACE Business WITH mbusiness
*        REINDEX
        COMMIT   && сбросим буфера на диск
     else
        MustBeBusiness()
     endif
  ENDDO
setcolor(oldc)
RETURN 0
***
* Конец подпрограммы
***

*--
*  Подпрограмма переноса невыполненных дел
*
*  выполняется при запуске программы
*--
FUNCTION  MoveBusiness
PRIVATE oldselect,oldfilter,oldrec
 oldselect=select()                  && сначала сохpаним pабочую область
 SELECT 3                            && выбираем область дел
 oldfilter=dbfilter()                && сохpаним стаpый фильтp в делах
 oldrec   =recno()                   && сохpаним указатель в делах
 SET FILTER TO Yes = " "
 GO TOP
  do while .not. eof()
     if End <Mdate
       REPLACE End WITH Mdate
     endif
     skip
  enddo
 COMMIT
 SET FILTER TO &oldfilter            && восстановим фильт в делах
 go top                              && сделаем его активным
 goto oldrec                         && веpнем указатель записи на место
 select(oldselect)                   && веpнемся в pабочую область
RETURN 0
***
* Конец подпрограммы
***

***
*     Добавление новых дел:
*     1. Задним числом не разрешать вводить. В противном случае
*предупреждение.
*
*     Отметка о выполнении:
*     1. Отмечать задним числом нельзя. В противном случае пре-
*дупреждение.
*     2. Отмеченное о выполнении дело можно вернуть в  невыпол-
*ненное только в день отметки,  если дата на компьютере не сов-
*падает, то рапрещать возврат.
*
*     Удаление:
*     1. Удаление  возможно только в случае если дело добавлено
*днем, которым его хотят удалить.  В противном случае запрещать
*удаление.
*
*
*
*
*
*
*
*
*--
*
*--
FUNCTION NotDiskSpace
PRIVATE buf,bufc

buf =savescreen( 14,19,18,59 )
bufc=setcolor( "N/BG" )
  @ 14,19 SAY "╔══════════════════════════════════════╗"
  @ 15,19 SAY "║  У  Вас недостаточно места на диске  ║"
  @ 16,19 SAY "║  для  сохранения новой  информации.  ║"
  @ 17,19 SAY "║                                      ║"
  @ 18,19 SAY "╚══════════════ нажмите любую клавишу ═╝"
inkey(0)
restscreen( 14,19,18,59,buf )
setcolor( bufc )

RETURN 0
***
*  Конец функции NotDiskSpace()
***

*--
*
*--
FUNCTION MustBeBusiness
PRIVATE buf,bufc
buf =savescreen( 14,19,18,59 )
bufc=setcolor( "N/BG" )
  @ 14,19 SAY "╔══════════════════════════════════════╗"
  @ 15,19 SAY "║ Пустая строка недопустима при редак- ║"
  @ 16,19 SAY "║ тировании. Используйте удаление  для ║"
  @ 17,19 SAY "║ стирания информации.                 ║"
  @ 18,19 SAY "╚══════════════ нажмите любую клавишу ═╝"
inkey(0)
restscreen( 14,19,18,59,buf )
setcolor( bufc )
RETURN 0
***
*  Конец функции MustBeBusiness()
***

*--
*
*--
FUNCTION NotDeleteBusiness
PRIVATE buf,bufc
buf =savescreen( 14,19,18,59 )
bufc=setcolor( "N/BG" )
  @ 14,19 SAY "╔══════════════════════════════════════╗"
  @ 15,19 SAY "║ Удалить задание задним числом нельзя.║"
  @ 16,19 SAY "║ Отметьте  'ВЫПОЛНЕНО'  для  снятия с ║"
  @ 17,19 SAY "║ контроля.                            ║"
  @ 18,19 SAY "╚══════════════ нажмите любую клавишу ═╝"
inkey(0)
restscreen( 14,19,18,59,buf )
setcolor( bufc )
RETURN 0
***
*  Конец функции NotDeleteBusiness()
***

*--
*
*--
FUNCTION NotEditBusiness
PRIVATE buf,bufc
buf =savescreen( 14,19,18,59 )
bufc=setcolor( "N/BG" )
  @ 14,19 SAY "╔══════════════════════════════════════╗"
  @ 15,19 SAY "║ Изменить задание задним числом нель- ║"
  @ 16,19 SAY "║ зя. Пометьте 'ВЫПОЛНЕНО' и добавьте  ║"
  @ 17,19 SAY "║ текущей датой новое задание.         ║"
  @ 18,19 SAY "╚══════════════ нажмите любую клавишу ═╝"
inkey(0)
restscreen( 14,19,18,59,buf )
setcolor( bufc )
RETURN 0
***
*  Конец функции NotEditBusiness()
***

*--
*
*--
FUNCTION  NotDateEqual
PRIVATE buf,bufc
buf =savescreen( 14,19,19,59 )
bufc=setcolor( "N/BG" )
  if empty(Yes)
      if date()>Begin
      * пометить что выполнено можно лишь текущим числом
         @ 14,19 SAY "╔══════════════════════════════════════╗"
         @ 15,19 SAY "║ Снять с контроля данную позицию можно║"
         @ 16,19 SAY "║ лишь текущим числом.                 ║"
         @ 17,19 SAY "║ Перейдите на текущее число.          ║"
         @ 18,19 SAY "║                                      ║"
         @ 19,19 SAY "╚══════════════ нажмите любую клавишу ═╝"
      else
         @ 14,19 SAY "╔══════════════════════════════════════╗"
         @ 15,19 SAY "║ Снять с контроля будущим числом дан- ║"
         @ 16,19 SAY "║ ную позицию нельзя.                  ║"
         @ 17,19 SAY "║ У Вас имеется возможность удалить    ║"
         @ 18,19 SAY "║ данную позицию.                      ║"
         @ 19,19 SAY "╚══════════════ нажмите любую клавишу ═╝"
      endif
  else
      * снять с контроля задним числом нельзя
      if date()>End
         @ 14,19 SAY "╔══════════════════════════════════════╗"
         @ 15,19 SAY "║  Вернуть на котроль  задним  числом  ║"
         @ 16,19 SAY "║  нельзя. Используйте добавление для  ║"
         @ 17,19 SAY "║  постановки на учет.                 ║"
         @ 18,19 SAY "║                                      ║"
         @ 19,19 SAY "╚══════════════ нажмите любую клавишу ═╝"
      else
      * установить на календаре текущюю дату
         @ 14,19 SAY "╔══════════════════════════════════════╗"
         @ 15,19 SAY "║  Вернуть на контроль данную позицию  ║"
         @ 16,19 SAY "║  можно лишь текущим числом.          ║"
         @ 17,19 SAY "║  Перейдите на текущее число.         ║"
         @ 18,19 SAY "║                                      ║"
         @ 19,19 SAY "╚══════════════ нажмите любую клавишу ═╝"
      endif
  endif
inkey(0)
restscreen( 14,19,19,59,buf )
setcolor( bufc )
RETURN 0
***
*  Конец функции NotDateEqual()
***

FUNCTION  NotAppendBusiness
PRIVATE buf,bufc
buf =savescreen( 14,19,19,59 )
bufc=setcolor( "N/BG" )
     && добавить новую позицию на контроль можно лишь вперед
     @ 14,19 SAY "╔══════════════════════════════════════╗"
     @ 15,19 SAY "║ Нельзя поставить на контроль новую   ║"
     @ 16,19 SAY "║ позицию задним числом.               ║"
     @ 17,19 SAY "║ Перейдите на текущее число или любое ║"
     @ 18,19 SAY "║ следующее за текущим.                ║"
     @ 19,19 SAY "╚══════════════ нажмите любую клавишу ═╝"
inkey(0)
restscreen( 14,19,19,59,buf )
setcolor( bufc )
RETURN 0
***
*  Конец функции NotAppendBusiness()
***
