PROC MAIN
PRIVATE str
str=""
SELECT 1
USE main ALIAS main
go top

SELECT 2
USE tel ALIAS old

SELECT 3
USE telephon ALIAS new

SELECT 1
DO WHILE .not.eof()
   str=dosie
   ? Fio, Basetel
   if .not.empty(Fio)
      SELECT 3
      APPEND BLANK
      REPLACE fio       WITH main->fio
      REPLACE label     WITH main->label
      REPLACE about     WITH uncript(str)
      REPLACE number01  WITH substr(main->basetyp,1,7)+main->basetel
      REPLACE what      WITH 1
      SELECT 2
      SET FILTER TO rel = main->rel
      go top
      i=2
      DO WHILE .not.eof()
        ? tel
        SELECT 3
        DO CASE
           CASE i=2
           REPLACE number02  WITH substr(old->type,1,7)+old->tel
           CASE i=3
           REPLACE number03  WITH substr(old->type,1,7)+old->tel
           CASE i=4
           REPLACE number04  WITH substr(old->type,1,7)+old->tel
           CASE i=5
           REPLACE number05  WITH substr(old->type,1,7)+old->tel
           CASE i=6
           REPLACE number06  WITH substr(old->type,1,7)+old->tel
           CASE i=7
           REPLACE number07  WITH substr(old->type,1,7)+old->tel
           CASE i=8
           REPLACE number08  WITH substr(old->type,1,7)+old->tel
           CASE i=9
           REPLACE number09  WITH substr(old->type,1,7)+old->tel
           OTHERWISE
           ? "Don't move this information : "
           ?? old->type
           ?? " "
           ?? old->tel
        ENDCASE
        SELECT 2
        i=i+1
        skip
      ENDDO
   endif
   SELECT 1
   skip
ENDDO

CLOSE DATABASES

*SELECT 1
*USE telephon
*SORT ON fio TO new
*ERASE telephon.dbf
*RENAME new.dbf TO telephon.dbf
*ERASE new.dbt
RETURN

FUNCTION uncript
PARAMETERS s
PRIVATE l,i,_s
  l=len(s)
  _s=""
  for i=1 to l
    _s=_s+chr(asc(substr(s,i,1))-1)
  next
RETURN _s
***
*  Конец функции uncript()
***
