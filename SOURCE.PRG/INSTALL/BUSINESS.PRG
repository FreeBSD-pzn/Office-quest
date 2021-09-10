*---------------------------------------------------------------------------
*    Создание файла BUSINESS.DBF
*
* YES       - выполнено ли текущее задание 0/1 (нет/да)
* BUSINESS  - собственно что нужно сделать длина 76 символов
* BEGIN     - дата получения задания
* END       - дата выполнения задания
*---------------------------------------------------------------------------
FUNCTION Business
CREATE new
USE new

  APPEND BLANK
    REPLACE Field_name WITH "YES"
    REPLACE Field_type WITH "C"
    REPLACE Field_len  WITH 1
  APPEND BLANK
    REPLACE Field_name WITH "BUSINESS"
    REPLACE Field_type WITH "C"
    REPLACE Field_len  WITH 72
  APPEND BLANK
    REPLACE Field_name WITH "BEGIN"
    REPLACE Field_type WITH "D"
    REPLACE Field_len  WITH 8
  APPEND BLANK
    REPLACE Field_name WITH "END"
    REPLACE Field_type WITH "D"
    REPLACE Field_len  WITH 8
USE

CREATE business FROM new
if file("new.dbf")
   ERASE new.dbf
endif

RETURN 0
