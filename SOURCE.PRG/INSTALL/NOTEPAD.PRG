*---------------------------------------------------------------------------
*    Создание файла NOTEPAD.DBF
*
* NDate     - дата записной книжки
* NOTE      - записная книжка
*---------------------------------------------------------------------------
FUNCTION Notepad
CREATE new
USE new

  APPEND BLANK
    REPLACE Field_name WITH "NoteDay"
    REPLACE Field_type WITH "D"
    REPLACE Field_len  WITH 8
  APPEND BLANK
    REPLACE Field_name WITH "qwa"
    REPLACE Field_type WITH "c"
    REPLACE Field_len  WITH 8
  APPEND BLANK
    REPLACE Field_name WITH "NOTE"
    REPLACE Field_type WITH "M"
USE

CREATE notepad FROM new
if file("new.dbf")
   ERASE new.dbf
endif

RETURN 0
