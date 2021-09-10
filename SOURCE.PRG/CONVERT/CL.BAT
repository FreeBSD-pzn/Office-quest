clipper %1  /L /M /N
IF NOT ERRORLEVEL 1 rtlink FI %1 LIB clipper,extend
IF NOT ERRORLEVEL 1 goto next
exit
:next
