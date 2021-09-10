CREATE new
USE new

  APPEND BLANK
    REPLACE Field_name WITH "rel"
    REPLACE Field_type WITH "C"
    REPLACE Field_len  WITH 4
  APPEND BLANK
    REPLACE Field_name WITH "country"
    REPLACE Field_type WITH "C"
    REPLACE Field_len  WITH 25
  APPEND BLANK
    REPLACE Field_name WITH "population"
    REPLACE Field_type WITH "C"
    REPLACE Field_len  WITH 6
  APPEND BLANK
    REPLACE Field_name WITH "area"
    REPLACE Field_type WITH "C"
    REPLACE Field_len  WITH 10
  APPEND BLANK
    REPLACE Field_name WITH "capital"
    REPLACE Field_type WITH "C"
    REPLACE Field_len  WITH 20
  APPEND BLANK
    REPLACE Field_name WITH "languages"
    REPLACE Field_type WITH "C"
    REPLACE Field_len  WITH 50
  APPEND BLANK
    REPLACE Field_name WITH "currency"
    REPLACE Field_type WITH "C"
    REPLACE Field_len  WITH 20
  APPEND BLANK
    REPLACE Field_name WITH "IDDcode"
    REPLACE Field_type WITH "C"
    REPLACE Field_len  WITH 3
  APPEND BLANK
    REPLACE Field_name WITH "telexcode"
    REPLACE Field_type WITH "C"
    REPLACE Field_len  WITH 6
USE

CREATE country FROM new
