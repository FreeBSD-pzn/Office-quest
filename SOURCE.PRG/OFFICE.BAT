@ECHO OFF
rem Указание на файлы данных. Если не установвлена то в текущей диpектоpии.
SET OFFICE=C:\office02\WORK\SOURCE.PRG\
rem
OFFICE.EXE //E:512 //F:15 //BADCACHE //SWAPK:2048
ECHO ON