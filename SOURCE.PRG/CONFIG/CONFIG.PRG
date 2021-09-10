**---------------------------------------------------------------------------
* Информация о различных режимах работы программы хранится в
* файле PASSWORD.DBF.
*
* Поля:
*     Имя поля    | Длина | Для чего
*     -----------------------------------------------------------------------
*  -> Name             20   Хранится информация о имени пользователя
*  -> Password         20   Хранится пароль пользователя в зашифрованном
*                           виде. Шифруется сам собой.
*  -> IDPath           60   Путь до файлов баз данных пользователя. Каждый
*                           пользователь может его изменить по своему
*                           усмотрению, если возникнет необходимость
*                           перенести информацию на другой диск или в другую
*                           директорию.
*  -> IDRun             4   При запуске программы выбор модуля для запуска
*                           например: телефонный справочник, дела, встречи...
*  -> MPort             4   Строка с именем порта к которому подключен модем
*                           например: COM1, COM2, COM3, COM4.
*  -> MDial            30   Строка команд для модема. Об'единяется с номером
*                           при наборе.
*  -> PPort             4   Строка с именем порта к которому подключен
*                           принтер, например: LPT1, LPT2, LPT3, COM1, и т.д.
*  -> PName             4   Указатель на номер записи содержащей модель
*                           принтера и необходимые управляющие команды.
*  -> PFont             1   Указатель на номер шрифта, где имеется след.
*                           выбор: 10 CPI, 12 CPI, 17 CPI, 20 CPI.
*  -> PLine             3   Растояние между строками при печати.
*  -> PQuality          1   Качество печати для черновиков или документов.
*  -> PPage             3   Длина страницы в строках.
*  -> PLeft             2   Отступ с левой стороны листа в пробелах.
*  ->
*  -> TelephonON        1   .T./.F. если истинно, то автоматически выводит-
*                           ся информация при смене выбранной буквы, иначе
*                           требуется нажатия Enter для вывода информации
*                           из телефонного справочника. По умолчанию при
*                           установке системы требуется нажатия Enter.
*
*  -> r00001            1   Зарезервировано для использования в будущем.
*  -> r00002            1   Зарезервировано для использования в будущем.
*  -> r00003            1   Зарезервировано для использования в будущем.
*  -> r00004            1   Зарезервировано для использования в будущем.
*  -> r00005            1   Зарезервировано для использования в будущем.
*  -> r00006            1   Зарезервировано для использования в будущем.
*  -> r00007            1   Зарезервировано для использования в будущем.
*  -> r00008            1   Зарезервировано для использования в будущем.
*  -> r00009            1   Зарезервировано для использования в будущем.
*  -> r00010            1   Зарезервировано для использования в будущем.
*  -> r00011            1   Зарезервировано для использования в будущем.
*  -> r00012            1   Зарезервировано для использования в будущем.
*  -> r00013            1   Зарезервировано для использования в будущем.
*  -> r00014            1   Зарезервировано для использования в будущем.
*  -> r00015            1   Зарезервировано для использования в будущем.
*  -> r00016            1   Зарезервировано для использования в будущем.
*  -> r00017            1   Зарезервировано для использования в будущем.
*  -> r00018            1   Зарезервировано для использования в будущем.
*  -> r00019            1   Зарезервировано для использования в будущем.
*  -> r00020            1   Зарезервировано для использования в будущем.
*
*  -> AllColor        800   Для 100 возможных цветов, на каждый цвет
*                           8 символов (например [+GR/+BG ]).
*  -> AllMusic        800   Для 100 нот, на каждую ноту 8 символов
*                           формат: xxxx,tt; где xxxx-частота в гц.
*                           tt-число 1/18 сек. интервалов.
**---------------------------------------------------------------------------

*FUNCTION GetSetup
  **-------------------------------------
  *   Сигнал будильника
  *
*  PutBeep=alltrim(AllMusic)
*  MaxBeep=len(PutMusic)/8
*RETURN 0
***
*  Конец функции GetSetup()
***

FUNCTION Config
PRIVATE i,j,s,filename,olds
  s="Смена имени и пароля пользователя       "+;
    "----------------------------------------"+;
    "Установка параметров модема             "+;
    "Смена рабочего каталога                 "+;
    "----------------------------------------"+;
    "Выход из установки параметров           "
  SET COLOR TO /BR
  @ 24,00 SAY space(80)
  SET COLOR TO BG/B
  @ 12,00,23,79 BOX "█▀███▄██ "
  SET COLOR TO W/B
  @ 13,02 SAY "УСТАНОВКА параметров Персональной информационной системы:"
  @ 14,04 SAY "->>"
  i=0
  j=0
  olds=select()
  SELECT 1
  filename=PathOffice+"PASSWORD.DBF"
  USE &filename
  DO WHILE .T.
     @ 14,07 CLEAR TO 22,77
     DO WHILE .T.
        FOR j=0 TO 5
          @ 14+j,08 SAY substr(s,1+(i+j)%6*40,40)
        NEXT
        key =inkey()
        do while key==0
          key=inkey()
        enddo
        DO CASE
           CASE key=24
              i=iif(i==5,0,i+1)
           CASE key=5
              i=iif(i==0,5,i-1)
           CASE key=13
              do case
                case i=0
                  ChangePassw()
                case i=1
                *  ChangePrint()
                case i=2
                  ChangeModem()
                case i=3
                  ChangePath()
                case i=4
                *  ChangeSystem()
                case i=5
                  IDName=alltrim(NAME)
                  IDPassword=alltrim(uncript(PASSWORD))
                  *IDPath=alltrim(PATH)  && смена каталога только после выхода
                  *IDNumber=i
                  ModemDevice=MPort
                  ModemDial  =MDial
                  j=IDRun
                  USE
                  select(olds)
                  RETURN j   && возвpащаем номеp функции для выполнения
              endcase
              EXIT
        ENDCASE
     ENDDO
  ENDDO
***
*  Конец функции PutSetup()
***

FUNCTION ChangePassw
PRIVATE mname,mpassword,oldc
  @ 14,07,22,77 BOX "┌─┐│┘─└│ "
  oldc=setcolor(",N/W")
  if !CursorON
     SET CURSOR ON
  endif
  mname    =space(20)
  mpassword=space(20)
  @ 19,10 SAY "   Введите новое имя : " GET mname
  @ 20,10 SAY "Введите новый пароль : " GET mpassword
  READ
  if !CursorON
     SET CURSOR OFF
  endif
  if !empty(mname) .and. !empty(mpassword)
    REPLACE NAME     WITH mname
    REPLACE PASSWORD WITH cript(mpassword)
    COMMIT
  endif
  setcolor(oldc)
RETURN 0
***
*  Конец функции ChangePassw()
***

FUNCTION ChangePath
PRIVATE mpath,oldc
  @ 14,07,22,77 BOX "┌─┐│┘─└│ "
  oldc=setcolor(",N/W")
  if !CursorON
     SET CURSOR ON
  endif
  mpath=space(20)
  @ 17,10 SAY "Текущее имя Вашего каталога : "
  @ 18,10 SAY "->"+IDPath
  @ 19,10 SAY "Введите новое имя Вашего каталога : "
  @ 20,10 SAY "->" GET mpath
  READ
  if !CursorON
     SET CURSOR OFF
  endif
  if !empty(mpath)
    REPLACE PATH  WITH mpath
    COMMIT
  endif
  setcolor(oldc)
RETURN 0
***
*  Конец функции ChangePath()
***

FUNCTION ChangeModem
PRIVATE s,i,oldc
  s="COM1COM2COM3COM4"
  @ 14,07,22,77 BOX "┌─┐│┘─└│ "
  i=0
  @ 15,09 SAY "Текущее имя порта подключения модема : "+MPort
  @ 16,09 SAY "Новое  имя  порта подключения модема : "
  @ 17,09 SAY "Текущая командная строка : "+Mdial
  @ 18,09 SAY "Новая  командная  строка : "
  oldc=setcolor("N/W,N/W")
  DO WHILE .T.
     @ 16,48 SAY substr(s,1+i*4,4)
     key =inkey()
     do while key==0
       key=inkey()
     enddo
     DO CASE
        CASE key=24
           i=iif(i==3,i,i+1)
        CASE key=5
           i=iif(i==0,i,i-1)
        CASE key=13
           REPLACE MPort WITH substr(s,1+i*4,4)
           EXIT
        CASE key=27
           EXIT
     ENDCASE
  ENDDO
  if !CursorON
     SET CURSOR ON
  endif
  s=MDial
  @ 18,36 GET s
  READ
  if !CursorON
     SET CURSOR OFF
  endif
  if !empty(s)
    REPLACE MDial WITH s
  endif
  COMMIT
  setcolor(oldc)
RETURN 0
***
*  Конец функции ChangeModem()
***
