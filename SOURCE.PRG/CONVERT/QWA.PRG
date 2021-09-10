PROC MAIN
SELECT 1
USE telephon
SET PRINT ON
SET CONSOLE OFF
SET PRINTER TO QWA.TXT
DO WHILE .not.eof()
   ? fio+number01+number02+number03+number04+number05+number06+number07+;
     number08+number09+label
   skip
ENDDO
SET PRINTER TO
SET CONSOLE ON
SET PRINT OFF
CLOSE DATABASES

RETURN
