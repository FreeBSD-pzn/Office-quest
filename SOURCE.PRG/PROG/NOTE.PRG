FUNCTION Notepad
PRIVATE s,k,filename,INNote,IDSave
  filename=IDPath+"notepad.dbf"
  IDHelp="Notepad"
  *-------------------------------------------------
  SET COLOR TO +BG/B
  @ 12,00,24,79 BOX "�ͻ���Ⱥ "
  @ 12,30 SAY "� ����H��           �"
  SET COLOR TO +W/BR
  @ 24,00 SAY "     �    �       �F1-������ F9-����� F2-���� F3-����� F4-⥫.�p. Esc-��室 "
  SET COLOR TO +BG/B
  *-------------------------------------------------
  SELECT 5
  USE &filename
  *-------------------------------------------------
  k=0
  DO WHILE .T.
    INNote=.F.
    SET FILTER TO NoteDay=MCDate
    go top
    if bof() .and. eof()   && �.�. ����� �� ����� ���� ���
      s=""
    else
      s=NOTE
    endif
    @ 12,41 SAY dtoc(MCdate)
    readinsert(.T.)
    k=-8   && �⮡� ���� � 横�
    do while k==-8    && �����
    if !IDCalendarON
      SET CURSOR ON
      CursorON=.T.
    endif
    @ 14,02 SAY ""
    s=memoedit( s,13,02,23,77,.T.,"InNotepad",75,0 )
    if !IDCalendarON
      SET CURSOR OFF
      CursorON=.F.
    endif
    k=lastkey()  && ����稬 ��᫥���� ������� ������ �p��� ��᫥ ��室�
    if k==-8
      IDPrint(s)
    endif
    enddo
    IDSave=.F.
    if bof() .and. eof()   && �.�. ����� �� ����� ���� ���
       if len(alltrim(s))>0
          IDSave=.T.
       endif
    else
      if s!=NOTE
          IDSave=.T.
       endif
    endif
    if IDSave
    if SaveNotepad()
       if eof() .and. bof()
         APPEND BLANK
         REPLACE NoteDay WITH MCDate
       endif
       REPLACE NOTE WITH s
       COMMIT
    endif
    endif
    if !INNote
      k=GetKey()
    else
      **k=lastkey() ����祭� �p��� ��᫥ ��室� �� memoedit()
      if k==-9
         IDCalendarON=.T.
         SET COLOR TO W/N
         @ 11,00 SAY "��������������������������������������������������������������������������������"
         SET COLOR TO +W/N
         @ 09,00 SAY "��������������������������������������������������������������������������������"
         SET COLOR TO +BG/B
      endif
    endif
    if k==27     && �p��뢠�� �� �� �뫮
       if TheEnd()==0
         k=0
         EXIT
       endif
    endif
    if k==-1 .or. k==-2 .or. k==-3 .or. k==-5
       EXIT
    endif
  ENDDO
  USE
RETURN k
***
*  End of Notepad()
***

FUNCTION InNotepad
PARAMETERS status,line,col
PRIVATE request,oldc,x,y,key,i
** ��뢠���� ��᫥ �믮������ ����⢨� memoedit()
  request=0
  x=col()
  y=row()
  key=lastkey()
  if CursorON
     SET CURSOR OFF
  endif
  oldc=setcolor("+W/BR")
  DO CASE
     CASE status=3
        key=0
        if readinsert()
          @ 24,11 SAY "��⠢��"
        else
          @ 24,11 SAY "������ "
        endif
        if IDCalendarON
          KEYBOARD chr(27)
        endif
     CASE status=0
        INNote=.T.
        @ 24,01 SAY str( line,4 )
        @ 24,06 SAY str( col ,4 )
  ENDCASE
  if status==1 .or. status==2
    if key==-1 .or. key==-2 .or. key==-3 .or. key==-5 .or. key==27
       request=23
    endif
    if key==-9 .or. key==-8
      request=23
    endif
    if key==22    && �᫨ ����� ������ Insert
       if !readinsert()
          @ 24,11 SAY "��⠢��"
       else
          @ 24,11 SAY "������ "
       endif
    endif
  endif
  if request==23
     @ 24,01 SAY "    "
     @ 24,06 SAY "    "
  endif
  setcolor(oldc)
  @ y,x SAY ""          && ��⠭����� ��p�p �� ����
  if CursorON
     SET CURSOR ON
  endif
RETURN request
***
*  End of InNotepad()
***

FUNCTION SaveNotepad
PRIVATE request,key,oldc,buf
    request=.T.
    key=0
    buf=savescreen( 14,22,19,57 )
    oldc=setcolor("+W/W")
    @ 14,22,19,57 BOX "�Ŀ����� "
    @ 15,24 SAY "���࠭��� ��������� � �������� ?"
    tone(262,9)
    do while key!=13
       if request
          SET COLOR TO W/BR
          @ 16,30 SAY "������"
          @ 18,30 SAY "������"
          SET COLOR TO +W/BR
          @ 17,30 SAY "  ��  "
          SET COLOR TO +W/W
          @ 16,43,18,49 BOX "�Ŀ�����"
          SET COLOR TO N/W
          @ 17,44 SAY " ��� "
       else
          SET COLOR TO W/BR
          @ 16,43 SAY "�������"
          @ 18,43 SAY "�������"
          SET COLOR TO +W/BR
          @ 17,43 SAY "  ���  "
          SET COLOR TO +W/W
          @ 16,30,18,35 BOX "�Ŀ�����"
          SET COLOR TO N/W
          @ 17,31 SAY " �� "
       endif
       key=0
       do while key==0
          key=inkey()
       enddo
       do case
          case key=4
               request=.F.
          case key=19
               request=.T.
       endcase
    enddo
restscreen( 14,22,19,57,buf )
setcolor(oldc)
RETURN request
