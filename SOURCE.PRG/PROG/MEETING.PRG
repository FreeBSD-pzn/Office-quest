*--
*  ���ணࠬ�� �뢮�� �������஢����� �����
*     ��ࠬ����:
*                ��� � ���ன ����஢���
*--
#include "inkey.ch"
#include "office.ch"

FUNCTION  MeetingDay
PRIVATE k,i,meet_key,sprint,ptr

 SELECT 2       && �롨ࠥ� ������� �����
 SET FILTER TO  Day=MCdate
 GO TOP
 SET COLOR TO +W/BR
 @ 24,04 SAY "������   "
 @ 24,15 SAY "����     "
 @ 24,26 SAY "⥫.��. "
 @ 24,37 SAY "�������  "
 @ 24,48 SAY "�����p�� "
 @ 24,59 SAY "�������� "
 @ 24,71 SAY "��室   "
 SET COLOR TO +W/N
 @ 24,02 SAY "F1"
 @ 24,13 SAY "F3"
 @ 24,24 SAY "F4"
 @ 24,35 SAY "F5"
 @ 24,46 SAY "F6"
 @ 24,57 SAY "F7"
 @ 24,68 SAY "Esc"
 ScreenMeeting()
 i=PutMeeting()
 DO WHILE .T.
     k=GetKey()
     SET COLOR TO +W/W
     @ 12,x()+4 SAY chr(205)
     @ 23,x()+4 SAY chr(205)
     DO CASE
        CASE k=-2
          RETURN -2
        CASE k=-3
          RETURN -3
        CASE k=-4
          RETURN -4
        CASE k=-5
          RETURN -5
        CASE k=-1
          MeetingDay=iif(MeetingDay,.F.,.T.)
          ScreenMeeting()
          i=PutMeeting()
        CASE k=27   && ����� Esc
          if TheEnd()==0
             RETURN 0
          endif
        CASE k=0    && �᫨ ��������� � ����室��� ��ᬮ����
           i=PutMeeting()
        CASE k=-6
          if date()<=MCdate
             @ 12,07 SAY chr(205)
             @ 23,07 SAY chr(205)
             AppendMeeting()
             i=PutMeeting()
          else
             NotAppendMeeting()
          endif
        CASE k=7
          if !IDCalendarON
            if Mdate<=Day
               if .not.deleted()
                 DELETE
                 PACK
                 REINDEX
               endif
               i=PutMeeting()
            else
               NotDeleteMeeting()
            endif
          endif
        CASE k=-7
          if !IDCalendarON .and. !(eof().and.bof())
            if Mdate<=Day
               EditMeeting(i)
               SET COLOR TO +GR/N
*               SPutMeeting(i,x())
               SET COLOR TO +W/W
               i=PutMeeting()
            else
               NotEditMeeting()
            endif
          endif
        CASE k=-8
          if !(eof().and.bof())
             ptr=recno()
             go top
             sprint=chr(13)+chr(10)+"     ����� �� "+dtoc(MCdate)+chr(13)+chr(10)
             sprint=sprint+"�����������������������������������"+chr(13)+chr(10)
             do while !eof()
               sprint=sprint+" "+Time+" "+alltrim(Meeting)+chr(13)+chr(10)
               skip
             enddo
             IDPrint(sprint)
             goto ptr
          endif
        CASE k=5
          @ 23,x()+4 SAY chr(205)
          if i>1
             SPutMeeting(i,x())
             skip -1
             i=i-1
             SET COLOR TO +GR/N
             SPutMeeting(i,x())
          else
             if .not.bof()
                SPutMeeting(i,x())
                skip -1
                if .not.bof()
                   scroll( y(),x(),22,x()+dx(),-1 )
                else
                   @ 12,x()+4 SAY chr(25)
                   go top
                endif
                SET COLOR TO +GR/N
                SPutMeeting(i,x())
             endif
          endif
        CASE k=24
          @ 12,x()+4 SAY chr(205)
          if .not.eof() .and. i<iif(MeetingDay,10,9)
             SPutMeeting(i,x())
             skip
             if .not.eof()
                i=i+1
             else
                @ 23,x()+4 SAY chr(24)
                go bottom
             endif
             SET COLOR TO +GR/N
             SPutMeeting(i,x())
          else
             if .not.eof()
                SPutMeeting(i,x())
                skip
                if .not.eof()
                   scroll( y(),x(),22,x()+dx(),1 )
                else
                   @ 23,x()+4 SAY chr(24)
                   go bottom
                endif
                SET COLOR TO +GR/N
                SPutMeeting(i,x())
             endif
          endif
     ENDCASE
 ENDDO
 RETURN request
***
* ����� ����ணࠬ��
***

FUNCTION x
RETURN iif( MeetingDay,1,2+11*iif(dow(MCdate)==1,6,dow(MCdate)-2) )

FUNCTION dx
RETURN iif( MeetingDay,77,9 )

FUNCTION y
RETURN iif( MeetingDay,13,14 )

FUNCTION ScreenMeeting
 if MeetingDay
    SET COLOR TO +W/W
    @ 12,00,23,79 BOX "�ͻ���Ⱥ "
    @ 12,06 SAY "�"
    @ 13,06 SAY "�"
    @ 14,06 SAY "�"
    @ 15,06 SAY "�"
    @ 16,06 SAY "�"
    @ 17,06 SAY "�"
    @ 18,06 SAY "�"
    @ 19,06 SAY "�"
    @ 20,06 SAY "�"
    @ 21,06 SAY "�"
    @ 22,06 SAY "�"
    @ 23,06 SAY "�"
 else
    SET COLOR TO +W/W
    @ 12,00,23,79 BOX "         "
    @ 12,01,23,78 BOX "�ͻ���Ⱥ "
    @ 12,12,23,23 BOX "��˺��ʺ "
    @ 12,34,23,45 BOX "��˺��ʺ "
    @ 12,56,23,67 BOX "��˺��ʺ "
 endif
RETURN 0

FUNCTION PutMeeting
PRIVATE i,j,oldc,dd,dw
  oldc=setcolor("+W/W")
  if MeetingDay
      SET FILTER TO  Day=MCdate
      GO TOP                              && ������ ��⨢�� 䨫��� ����ᥩ
      @ 13,01 CLEAR TO 22,05
      @ 13,07 CLEAR TO 22,78
      @ 13,06 SAY "�"
      @ 14,06 SAY "�"
      @ 15,06 SAY "�"
      @ 16,06 SAY "�"
      @ 17,06 SAY "�"
      @ 18,06 SAY "�"
      @ 19,06 SAY "�"
      @ 20,06 SAY "�"
      @ 21,06 SAY "�"
      @ 22,06 SAY "�"
      i=1
      @ 12,30 SAY chr(190)+" ���p�� �� "+dtoc(MCdate)+" "+chr(212)
      if eof() .and. bof()
         @ 17,24 SAY "�� "+dtoc(MCdate)+" ������ �� �������������"
      else
         DO WHILE .not.eof() .and. i<11
            SPutMeeting(i,1)
            skip
            i=i+1
         ENDDO
         go top
         i=1
         SET COLOR TO +GR/N
         SPutMeeting(i,1)
      endif
  else
      dd=MCdate
      dw=dow(dd)
      dw=iif(dw==1,6,dw-2)
      dd=dd-dw
      SET COLOR TO +W/G
      for i=0 to 6
        if i==5
          SET COLOR TO +W/BR
        endif
        if i==6
          SET COLOR TO +W/R
        endif
        @ 13,2+i*11 SAY " "+dtoc(dd+i)+" "
      next
      SET COLOR TO +W/W
      for i=0 to 6
        set filter to day=dd
        go top
        @ 14,i*11+2 CLEAR TO 22,i*11+11
        j=1
        do while !eof() .and. j<10
          SPutMeeting( j,i*11+2)
          skip
          j=j+1
        enddo
        dd=dd+1
      next
      SET FILTER TO  Day=MCdate
      GO TOP                              && ������ ��⨢�� 䨫��� ����ᥩ
      if !(eof() .and. bof())
         SET COLOR TO +GR/N
         SPutMeeting(1,x())
      endif
  endif
  setcolor(oldc)
RETURN 1
***
* ����� ����ணࠬ��
***

FUNCTION SPutMeeting
PARAMETERS y,x
PRIVATE s
     s=Meeting
#ifdef PWD_MEET
     decrypt_cl(@s,@s,72)
#endif
     if MeetingDay
       @ 12+y,x SAY Time+chr(179)+s
     else
       @ 13+y,x SAY Time+" "+substr(s,1,4)
     endif
RETURN 1
***
* ����� ����ணࠬ�� SPutMeeting()
***

FUNCTION AppendMeeting
PRIVATE mmeeting,mtime,oldc,ss,y
oldc=setcolor("N/BG,N/BG")
mtime=space(5)
mmeeting=space(72)
y=13
if !MeetingDay
   ss=savescreen( 21,0,23,79 )
   @ 21,0 TO 23,79
   y=22
endif
  if diskspace()>recsize()+2048
     SET CURSOR ON
     CursorON=.T.
     @ y,06 SAY ">"
     @ y,01 GET mtime
     @ y,07 GET mmeeting
     READ
     SET CURSOR OFF
     CursorON=.F.
     mmeeting=mmeeting+space(72-len(mmeeting))
     * �᫨ ��祣� ��� � �� �����뢠��
     if .not.empty(mmeeting) .and. .not.empty(mtime)
        APPEND BLANK
#ifdef PWD_MEET
        encrypt_cl(@mmeeting,@mmeeting,72)
#endif
        REPLACE Meeting  WITH mmeeting
        REPLACE Time     WITH mtime
        REPLACE Day      WITH MCdate
        * � ���� Yes ��祣� �� ��襬 �.�. ���� �� �믮�����
        REINDEX
        COMMIT   && ��ᨬ ���� �� ���
     endif
  else
     NotDiskSpace()
  endif
if !MeetingDay
   restscreen( 21,0,23,79,ss )
endif
setcolor(oldc)
RETURN 0
***
* ����� ����ணࠬ��
***


FUNCTION EditMeeting
PARAMETERS y
PRIVATE mtime,mmeeting,oldc,ss,sy,oldp
oldc=setcolor("N/BG,N/BG")
mtime=space(5)
mmeeting=space(72)
sy=12+y
if !MeetingDay
   ss=savescreen( 21,0,23,79 )
   @ 21,0 TO 23,79
   sy=22
endif
  DO WHILE empty(mmeeting) .or. empty(mtime)
     mtime=Time
     mmeeting=Meeting
#ifdef PWD_MEET
     decrypt_cl(@mmeeting,@mmeeting,72)
#endif
     SET CURSOR ON
     CursorON=.T.
     @ sy,06 SAY ">"
     @ sy,01 GET mtime
     @ sy,07 GET mmeeting
     READ
     SET CURSOR OFF
     CursorON=.F.
     mmeeting=mmeeting+space(72-len(mmeeting))
     * �᫨ 祣�-����� ��� � ����������
     if .not.empty(mmeeting) .and. .not.empty(mtime)
#ifdef PWD_MEET
        encrypt_cl(@mmeeting,@mmeeting,72)
#endif
        REPLACE Meeting  WITH mmeeting
        REPLACE Time     WITH mtime
        REINDEX
        COMMIT   && ��ᨬ ���� �� ���
     else
        MustBeInformation()
     endif
  ENDDO
if !MeetingDay
   restscreen( 21,0,23,79,ss )
endif
setcolor(oldc)
RETURN 0
***
* ����� ����ணࠬ��
***

FUNCTION  NotAppendMeeting
PRIVATE buf,bufc
buf =savescreen( 14,19,19,59 )
bufc=setcolor( "N/BG" )
     && �������� ����� ������ �� ����஫� ����� ���� ���।
     @ 14,19 SAY "��������������������������������������ͻ"
     @ 15,19 SAY "� ����� �������� ����� ������ ������ �"
     @ 16,19 SAY "� �᫮�.                              �"
     @ 17,19 SAY "� ��३��� �� ⥪�饥 �᫮ ��� �� �"
     @ 18,19 SAY "� ᫥���饥 �� ⥪�騬.                �"
     @ 19,19 SAY "��������������� ������ ���� ������� ͼ"
inkey(0)
restscreen( 14,19,19,59,buf )
setcolor( bufc )
RETURN 0
***
*  ����� �㭪樨 NotAppendMeeting()
***

*--
*
*--
FUNCTION MustBeInformation
PRIVATE buf,bufc
buf =savescreen( 14,19,18,59 )
bufc=setcolor( "N/BG" )
  @ 14,19 SAY "��������������������������������������ͻ"
  @ 15,19 SAY "� ����� ��ப� �������⨬� �� ।��- �"
  @ 16,19 SAY "� �஢����. �ᯮ���� 㤠�����  ��� �"
  @ 17,19 SAY "� ��࠭�� ���ଠ樨.                 �"
  @ 18,19 SAY "��������������� ������ ���� ������� ͼ"
inkey(0)
restscreen( 14,19,18,59,buf )
setcolor( bufc )
RETURN 0
***
*  ����� �㭪樨 MustBeInformation()
***

*--
*
*--
FUNCTION NotDeleteMeeting
PRIVATE buf,bufc
buf =savescreen( 14,19,18,59 )
bufc=setcolor( "N/BG" )
  @ 14,19 SAY "��������������������������������������ͻ"
  @ 15,19 SAY "�    ������� �������஢����� ������    �"
  @ 16,19 SAY "�    �᫮� �����.                    �"
  @ 17,19 SAY "�                                      �"
  @ 18,19 SAY "��������������� ������ ���� ������� ͼ"
inkey(0)
restscreen( 14,19,18,59,buf )
setcolor( bufc )
RETURN 0
***
*  ����� �㭪樨 NotDeleteMeeting()
***

*--
*
*--
FUNCTION NotEditMeeting
PRIVATE buf,bufc
buf =savescreen( 14,19,18,59 )
bufc=setcolor( "N/BG" )
  @ 14,19 SAY "��������������������������������������ͻ"
  @ 15,19 SAY "�    �������� �������஢����� ������   �"
  @ 16,19 SAY "�    �᫮� �����.                    �"
  @ 17,19 SAY "�                                      �"
  @ 18,19 SAY "��������������� ������ ���� ������� ͼ"
inkey(0)
restscreen( 14,19,18,59,buf )
setcolor( bufc )
RETURN 0
***
*  ����� �㭪樨 NotEditMeeting()
***

