FUNCTION Telephon
CREATE new
USE new

  APPEND BLANK
    REPLACE Field_name WITH "YES"
    REPLACE Field_type WITH "C"
    REPLACE Field_len  WITH 1
  APPEND BLANK
    REPLACE Field_name WITH "FIO"
    REPLACE Field_type WITH "C"
    REPLACE Field_len  WITH 40
  APPEND BLANK
    REPLACE Field_name WITH "LABEL"
    REPLACE Field_type WITH "C"
    REPLACE Field_len  WITH 240
  *
  * Какай номер телефона выводится на экран в режиме "Видно всех"
  APPEND BLANK
    REPLACE Field_name WITH "WHAT"
    REPLACE Field_type WITH "N"
    REPLACE Field_len  WITH 2
  APPEND BLANK
    REPLACE Field_name WITH "NUMBER01"
    REPLACE Field_type WITH "C"
    REPLACE Field_len  WITH 24
  APPEND BLANK
    REPLACE Field_name WITH "NUMBER02"
    REPLACE Field_type WITH "C"
    REPLACE Field_len  WITH 24
  APPEND BLANK
    REPLACE Field_name WITH "NUMBER03"
    REPLACE Field_type WITH "C"
    REPLACE Field_len  WITH 24
  APPEND BLANK
    REPLACE Field_name WITH "NUMBER04"
    REPLACE Field_type WITH "C"
    REPLACE Field_len  WITH 24
  APPEND BLANK
    REPLACE Field_name WITH "NUMBER05"
    REPLACE Field_type WITH "C"
    REPLACE Field_len  WITH 24
  APPEND BLANK
    REPLACE Field_name WITH "NUMBER06"
    REPLACE Field_type WITH "C"
    REPLACE Field_len  WITH 24
  APPEND BLANK
    REPLACE Field_name WITH "NUMBER07"
    REPLACE Field_type WITH "C"
    REPLACE Field_len  WITH 24
  APPEND BLANK
    REPLACE Field_name WITH "NUMBER08"
    REPLACE Field_type WITH "C"
    REPLACE Field_len  WITH 24
  APPEND BLANK
    REPLACE Field_name WITH "NUMBER09"
    REPLACE Field_type WITH "C"
    REPLACE Field_len  WITH 24
  APPEND BLANK
    REPLACE Field_name WITH "ABOUT"
    REPLACE Field_type WITH "M"
USE

CREATE telephon FROM new
if file("new.dbf")
   ERASE new.dbf
endif

RETURN 0
