*---------------------------------------------------------------------------
*    Создание файла MEETING.DBF
*
*  DAY     - день на который назначена встреча
*  TIME    - время встречи
*  SIGNAL  - за какое время до встречи подать сигнал
*  MEETING - что за встреча, строка 70 символов
*---------------------------------------------------------------------------
FUNCTION Meeting
CREATE new
USE new

  APPEND BLANK
    REPLACE Field_name WITH "DAY"
    REPLACE Field_type WITH "D"
    REPLACE Field_len  WITH 8
  APPEND BLANK
    REPLACE Field_name WITH "TIME"
    REPLACE Field_type WITH "C"
    REPLACE Field_len  WITH 5
  APPEND BLANK
    REPLACE Field_name WITH "SIGNAL"
    REPLACE Field_type WITH "C"
    REPLACE Field_len  WITH 5
  APPEND BLANK
    REPLACE Field_name WITH "MEETING"
    REPLACE Field_type WITH "C"
    REPLACE Field_len  WITH 72
USE

CREATE meeting FROM new
if file("new.dbf")
   ERASE new.dbf
endif

RETURN 0
