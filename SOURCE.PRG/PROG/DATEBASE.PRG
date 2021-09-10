*--
*  Подпрограмма пpовеpки наличия баз данных пользователя
*--
FUNCTION HaveDatebase
PRIVATE request,filename
  request=.T.
  if !file(IDPath+"telephon.dbf")
     request=.F.
  endif
  if !file(IDPath+"telephon.dbt")
     request=.F.
  endif
  if !file(IDPath+"notepad.dbf")
     request=.F.
  endif
  if !file(IDPath+"notepad.dbt")
     request=.F.
  endif
  if !file(IDPath+"business.dbf")
     request=.F.
  endif
  if !file(IDPath+"meeting.dbf")
     request=.F.
  endif
  if request
     filename=IDPath+"business.dbf"
     SELECT 3
     USE &filename
     filename=IDPath+"business.ntx"
     INDEX ON Begin TO &filename
     filename=IDPath+"meeting.dbf"
     SELECT 2
     USE &filename 
     filename=IDPath+"meeting.ntx"
     INDEX ON Time TO &filename
  else
     SET COLOR TO W/N
     @ 00,00,23,79 BOX "┌─┐│┘─└│ "
     @ 01,01,22,78 BOX "┌─┐│┘─└│ "
     @ 02,03 SAY '    При работе персональной информационной системы  все  данные,  которые'
     @ 03,03 SAY 'вводятся Вами сохраняются на диске в нескольких файлах.  Поэтому для пра-'
     @ 04,03 SAY 'вильной работы OFFICE-QUEST на диске Вашего компьютера должны присутство-'
     @ 05,03 SAY 'вать следующие файлы:'
     @ 06,03 SAY '    BUSINESS.DBF'
     @ 07,03 SAY '    MEETING.DBF'
     @ 08,03 SAY '    TELEPHON.DBF'
     @ 09,03 SAY '    TELEPHON.DBT'
     @ 10,03 SAY '    NOTEPAD.DBF'
     @ 11,03 SAY '    NOTEPAD.DBT'
     @ 12,03 SAY 'эти файлы содержат только  Ваши  данные  и  они  должны  располагаться  в'
     @ 13,03 SAY 'отдельном каталоге (директории). Имя каталога которое доступно персональ-'
     @ 14,03 SAY 'ной информационной системе следующее:'
     @ 15,03 SAY '      ->'
     @ 16,03 SAY 'Вам необходимо проверить имеются ли все вышеперечисленные файлы в указан-'
     @ 17,03 SAY 'ной директории.  Если кокого-нибудь файла нет восстановите его, используя'
     @ 18,03 SAY 'предыдущие копии (подробнее смотри в руководстве оператора).'
     SET COLOR TO +GR/N
     @ 15,12 SAY IDPath
     @ 20,03 SAY '                              Для продолжения нажмите любую клавишу.'
     inkey(0)
  endif
RETURN request
