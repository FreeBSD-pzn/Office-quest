*--
*  ���ணࠬ�� �뢮�� �������஢����� ���
*     ��ࠬ����:
*                ��� � ���ன ����஢���
*--
#include "office.ch"

FUNCTION  BusinessDay
PRIVATE k,i,sprint,ptr

 SELECT 3                            && �롨ࠥ� ������� ���
 SET FILTER TO  Begin<=MCdate.and.End>=MCdate
 GO TOP
 SET COLOR TO +W/BR
 @ 24,04 SAY "������   "
 @ 24,15 SAY "�����  "
 @ 24,26 SAY "⥫.��. "
 @ 24,37 SAY "�������  "
 @ 24,48 SAY "�����த "
 @ 24,59 SAY "�������� "
 @ 24,71 SAY "��室   "
 SET COLOR TO +W/N
 @ 24,02 SAY "F1"
 @ 24,13 SAY "F2"
 @ 24,24 SAY "F4"
 @ 24,35 SAY "F5"
 @ 24,46 SAY "F6"
 @ 24,57 SAY "F7"
 @ 24,68 SAY "Esc"
 SET COLOR TO +W/W
 @ 12,00,23,79 BOX "�ͻ���Ⱥ "
 @ 12,03 SAY "�"
 @ 13,03 SAY "�"
 @ 14,03 SAY "�"
 @ 15,03 SAY "�"
 @ 16,03 SAY "�"
 @ 17,03 SAY "�"
 @ 18,03 SAY "�"
 @ 19,03 SAY "�"
 @ 20,03 SAY "�"
 @ 21,03 SAY "�"
 @ 22,03 SAY "�"
 @ 23,03 SAY "�"
 i=PutBusiness()
 SET COLOR TO +W/W
 DO WHILE .T.
     k=GetKey()
     DO CASE
        CASE k=-1
          RETURN -1
        CASE k=-3
          RETURN -3
        CASE k=-4
          RETURN -4    && �������
        CASE k=-5
          RETURN -5    && �����p��
        CASE k=27   && ����� Esc
          if TheEnd()=0
             RETURN 0
          endif
        CASE k=0    && �᫨ ��������� � ����室��� ��ᬮ����
           SET FILTER TO  Begin<=MCdate.and.End>=MCdate
           GO TOP
           i=PutBusiness()
        CASE k=13
            if MCdate=End.and.date()=End  && �믮����� ⮫쪮 �᫨ ���� ᮢ������
               REPLACE Yes WITH iif(empty(Yes),chr(251),chr(32) )
               COMMIT                && ����襬 �� ���
               SET COLOR TO +W/B
               SPutBusiness(i)
               SET COLOR TO +W/W
            else
               NotDateEqual()
            endif
        CASE k=-6
          if date()<=MCdate
             @ 12,04 SAY chr(205)
             @ 23,04 SAY chr(205)
             AppendBusiness()
             i=PutBusiness()
          else
             NotAppendBusiness()
          endif
        CASE k=-7
          if !IDCalendarON .and. !(eof().and.bof())
            if End==Begin .and. Mdate<=End
               EditBusiness(i)
               SET COLOR TO +W/B
               SPutBusiness(i)
               SET COLOR TO +W/W
            else
               NotEditBusiness()
            endif
          endif
        CASE k=-8
          if !(eof().and.bof())
             ptr=recno()
             go top
             sprint=chr(13)+chr(10)+"     ���� �� "+dtoc(MCdate)+chr(13)+chr(10)
             sprint=sprint+"�����������������������������������"+chr(13)+chr(10)
             do while !eof()
               sprint=sprint+"  "+alltrim(Business)+chr(13)+chr(10)
               skip
             enddo
             IDPrint(sprint)
             goto ptr
          endif
        CASE k=7
          if !IDCalendarON
            if End==Begin .and. Mdate<=End
               if .not.deleted()
                  DELETE
                  PACK
                  REINDEX
               endif
               i=PutBusiness()
            else
               NotDeleteBusiness()
            endif
          endif
        CASE k=5
          @ 23,04 SAY chr(205)
          if i>1
             SPutBusiness(i)
             skip -1
             i=i-1
             SET COLOR TO +W/B
             SPutBusiness(i)
          else
             if .not.bof()
                SPutBusiness(i)
                skip -1
                if .not.bof()
                   scroll( 13,02,22,77,-1 )
                else
                   @ 12,04 SAY chr(25)
                   go top
                endif
                SET COLOR TO +W/B
                SPutBusiness(i)
             endif
          endif
          SET COLOR TO +W/W
        CASE k=24
          @ 12,04 SAY chr(205)
          if .not.eof() .and. i<10
             SPutBusiness(i)
             skip
             if .not.eof()
                i=i+1
             else
                @ 23,04 SAY chr(24)
                go bottom
             endif
             SET COLOR TO +W/B
             SPutBusiness(i)
          else
             if .not.eof()
                SPutBusiness(i)
                skip
                if .not.eof()
                   scroll( 13,02,22,77,1 )
                else
                   @ 23,04 SAY chr(24)
                   go bottom
                endif
                SET COLOR TO +W/B
                SPutBusiness(i)
             endif
          endif
          SET COLOR TO +W/W
     ENDCASE
 ENDDO
 RETURN request
***
* ����� ����ணࠬ��
***

FUNCTION PutBusiness
PRIVATE i,oldc
  oldc=setcolor("+W/W")
  GO TOP                              && ������ ��⨢�� 䨫��� ����ᥩ
  @ 13,01 CLEAR TO 22,02
  @ 13,04 CLEAR TO 22,78
  @ 13,03 SAY "�"
  @ 14,03 SAY "�"
  @ 15,03 SAY "�"
  @ 16,03 SAY "�"
  @ 17,03 SAY "�"
  @ 18,03 SAY "�"
  @ 19,03 SAY "�"
  @ 20,03 SAY "�"
  @ 21,03 SAY "�"
  @ 22,03 SAY "�"

  i=1
  @ 12,31 SAY chr(190)+" ���� �� "+dtoc(MCdate)+" "+chr(212)
  if eof() .and. bof()
     @ 17,24 SAY "�� "+dtoc(MCdate)+" ��� �� �������������"
  else
     DO WHILE .not.eof() .and. i<11
        SPutBusiness(i)
        skip
        i=i+1
     ENDDO
     go top
     i=1
     SET COLOR TO +W/B
     SPutBusiness(i)
  endif
  setcolor(oldc)
RETURN 1
***
* ����� ����ணࠬ��
***

FUNCTION SPutBusiness
PARAMETERS y
PRIVATE s
     s=Business
#ifdef PWD_BUSI
     decrypt_cl(@s,@s,72)
#endif
     @ 12+y,1 SAY " "+iif(.not.empty(Yes),iif(MCdate<End,chr(7),Yes),Yes);
                  +chr(179)+" "+s+"  "
RETURN 1
***
* ����� ����ணࠬ�� SPutBusiness()
***

FUNCTION AppendBusiness
PRIVATE mbusiness,oldc
oldc=setcolor("N/BG,N/BG")
mbusiness=space(72)
  if diskspace()>recsize()+2048
     SET CURSOR ON
     CursorON=.T.
     @ 13,01 SAY "  ->"
     @ 13,77 SAY "  "
     @ 13,05 GET mbusiness
     READ
     SET CURSOR OFF
     CursorON=.F.
     mbusiness=mbusiness+space(72-len(mbusiness))
     if !empty(mbusiness)   && �᫨ ��祣� ��� � �� �����뢠��
        APPEND BLANK
#ifdef PWD_BUSI
        encrypt_cl(@mbusiness,@mbusiness,72)
#endif
        REPLACE Business WITH mbusiness
        REPLACE Begin    WITH MCdate
        REPLACE End      WITH MCdate
        * � ���� Yes ��祣� �� ��襬 �.�. ���� �� �믮�����
        REINDEX
        COMMIT   && ��ᨬ ���� �� ���
     endif
  else
     NotDiskSpace()
  endif
setcolor(oldc)
RETURN 0
***
* ����� ����ணࠬ��
***

FUNCTION EditBusiness
PARAMETERS y
PRIVATE mbusiness,oldc
oldc=setcolor("N/BG,N/BG")
mbusiness=space(72)
  DO WHILE empty(mbusiness)
     mbusiness=Business
#ifdef PWD_BUSI
     decrypt_cl(@mbusiness,@mbusiness,72)
#endif
     SET CURSOR ON
     CursorON=.T.
     @ 12+y,01 SAY "  ->"
     @ 12+y,77 SAY "  "
     @ 12+y,05 GET mbusiness
     READ
     SET CURSOR OFF
     CursorON=.F.
     mbusiness=mbusiness+space(72-len(mbusiness))
     if !empty(mbusiness)   && �᫨ ��祣� ��� � �� �����뢠��
#ifdef PWD_BUSI
        encrypt_cl(@mbusiness,@mbusiness,72)
#endif
        REPLACE Business WITH mbusiness
*        REINDEX
        COMMIT   && ��ᨬ ���� �� ���
     else
        MustBeBusiness()
     endif
  ENDDO
setcolor(oldc)
RETURN 0
***
* ����� ����ணࠬ��
***

*--
*  ����ணࠬ�� ��७�� ���믮������� ���
*
*  �믮������ �� ����᪥ �ணࠬ��
*--
FUNCTION  MoveBusiness
PRIVATE oldselect,oldfilter,oldrec
 oldselect=select()                  && ᭠砫� ��p���� p������ �������
 SELECT 3                            && �롨ࠥ� ������� ���
 oldfilter=dbfilter()                && ��p���� ��p� 䨫��p � �����
 oldrec   =recno()                   && ��p���� 㪠��⥫� � �����
 SET FILTER TO Yes = " "
 GO TOP
  do while .not. eof()
     if End <Mdate
       REPLACE End WITH Mdate
     endif
     skip
  enddo
 COMMIT
 SET FILTER TO &oldfilter            && ����⠭���� 䨫�� � �����
 go top                              && ᤥ���� ��� ��⨢��
 goto oldrec                         && ��p��� 㪠��⥫� ����� �� ����
 select(oldselect)                   && ��p����� � p������ �������
RETURN 0
***
* ����� ����ணࠬ��
***

***
*     ���������� ����� ���:
*     1. ������ �᫮� �� ࠧ���� �������. � ��⨢��� ��砥
*�।�०�����.
*
*     �⬥⪠ � �믮������:
*     1. �⬥��� ������ �᫮� �����. � ��⨢��� ��砥 ��-
*��०�����.
*     2. �⬥祭��� � �믮������ ���� ����� ������ �  ���믮�-
*������ ⮫쪮 � ���� �⬥⪨,  �᫨ ��� �� �������� �� ᮢ-
*������, � ࠯���� ������.
*
*     ��������:
*     1. ��������  �������� ⮫쪮 � ��砥 �᫨ ���� ���������
*����, ����� ��� ���� 㤠����.  � ��⨢��� ��砥 �������
*㤠�����.
*
*
*
*
*
*
*
*
*--
*
*--
FUNCTION NotDiskSpace
PRIVATE buf,bufc

buf =savescreen( 14,19,18,59 )
bufc=setcolor( "N/BG" )
  @ 14,19 SAY "��������������������������������������ͻ"
  @ 15,19 SAY "�  �  ��� �������筮 ���� �� ��᪥  �"
  @ 16,19 SAY "�  ���  ��࠭���� �����  ���ଠ樨.  �"
  @ 17,19 SAY "�                                      �"
  @ 18,19 SAY "��������������� ������ ���� ������� ͼ"
inkey(0)
restscreen( 14,19,18,59,buf )
setcolor( bufc )

RETURN 0
***
*  ����� �㭪樨 NotDiskSpace()
***

*--
*
*--
FUNCTION MustBeBusiness
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
*  ����� �㭪樨 MustBeBusiness()
***

*--
*
*--
FUNCTION NotDeleteBusiness
PRIVATE buf,bufc
buf =savescreen( 14,19,18,59 )
bufc=setcolor( "N/BG" )
  @ 14,19 SAY "��������������������������������������ͻ"
  @ 15,19 SAY "� ������� ������� ������ �᫮� �����.�"
  @ 16,19 SAY "� �⬥���  '���������'  ���  ���� � �"
  @ 17,19 SAY "� ����஫�.                            �"
  @ 18,19 SAY "��������������� ������ ���� ������� ͼ"
inkey(0)
restscreen( 14,19,18,59,buf )
setcolor( bufc )
RETURN 0
***
*  ����� �㭪樨 NotDeleteBusiness()
***

*--
*
*--
FUNCTION NotEditBusiness
PRIVATE buf,bufc
buf =savescreen( 14,19,18,59 )
bufc=setcolor( "N/BG" )
  @ 14,19 SAY "��������������������������������������ͻ"
  @ 15,19 SAY "� �������� ������� ������ �᫮� ����- �"
  @ 16,19 SAY "� ��. ������� '���������' � �������  �"
  @ 17,19 SAY "� ⥪�饩 ��⮩ ����� �������.         �"
  @ 18,19 SAY "��������������� ������ ���� ������� ͼ"
inkey(0)
restscreen( 14,19,18,59,buf )
setcolor( bufc )
RETURN 0
***
*  ����� �㭪樨 NotEditBusiness()
***

*--
*
*--
FUNCTION  NotDateEqual
PRIVATE buf,bufc
buf =savescreen( 14,19,19,59 )
bufc=setcolor( "N/BG" )
  if empty(Yes)
      if date()>Begin
      * ������� �� �믮����� ����� ���� ⥪�騬 �᫮�
         @ 14,19 SAY "��������������������������������������ͻ"
         @ 15,19 SAY "� ����� � ����஫� ������ ������ ������"
         @ 16,19 SAY "� ���� ⥪�騬 �᫮�.                 �"
         @ 17,19 SAY "� ��३��� �� ⥪�饥 �᫮.          �"
         @ 18,19 SAY "�                                      �"
         @ 19,19 SAY "��������������� ������ ���� ������� ͼ"
      else
         @ 14,19 SAY "��������������������������������������ͻ"
         @ 15,19 SAY "� ����� � ����஫� ���騬 �᫮� ���- �"
         @ 16,19 SAY "� ��� ������ �����.                  �"
         @ 17,19 SAY "� � ��� ������� ����������� 㤠����    �"
         @ 18,19 SAY "� ������ ������.                      �"
         @ 19,19 SAY "��������������� ������ ���� ������� ͼ"
      endif
  else
      * ���� � ����஫� ������ �᫮� �����
      if date()>End
         @ 14,19 SAY "��������������������������������������ͻ"
         @ 15,19 SAY "�  ������ �� ���஫�  ������  �᫮�  �"
         @ 16,19 SAY "�  �����. �ᯮ���� ���������� ���  �"
         @ 17,19 SAY "�  ���⠭���� �� ���.                 �"
         @ 18,19 SAY "�                                      �"
         @ 19,19 SAY "��������������� ������ ���� ������� ͼ"
      else
      * ��⠭����� �� �������� ⥪���� ����
         @ 14,19 SAY "��������������������������������������ͻ"
         @ 15,19 SAY "�  ������ �� ����஫� ������ ������  �"
         @ 16,19 SAY "�  ����� ���� ⥪�騬 �᫮�.          �"
         @ 17,19 SAY "�  ��३��� �� ⥪�饥 �᫮.         �"
         @ 18,19 SAY "�                                      �"
         @ 19,19 SAY "��������������� ������ ���� ������� ͼ"
      endif
  endif
inkey(0)
restscreen( 14,19,19,59,buf )
setcolor( bufc )
RETURN 0
***
*  ����� �㭪樨 NotDateEqual()
***

FUNCTION  NotAppendBusiness
PRIVATE buf,bufc
buf =savescreen( 14,19,19,59 )
bufc=setcolor( "N/BG" )
     && �������� ����� ������ �� ����஫� ����� ���� ���।
     @ 14,19 SAY "��������������������������������������ͻ"
     @ 15,19 SAY "� ����� ���⠢��� �� ����஫� �����   �"
     @ 16,19 SAY "� ������ ������ �᫮�.               �"
     @ 17,19 SAY "� ��३��� �� ⥪�饥 �᫮ ��� �� �"
     @ 18,19 SAY "� ᫥���饥 �� ⥪�騬.                �"
     @ 19,19 SAY "��������������� ������ ���� ������� ͼ"
inkey(0)
restscreen( 14,19,19,59,buf )
setcolor( bufc )
RETURN 0
***
*  ����� �㭪樨 NotAppendBusiness()
***
