*--
*  ����ணࠬ�� �p���p�� ������ ��� ������ ���짮��⥫�
*--
FUNCTION HaveDatebase
PRIVATE request,filename
  request=.T.
  if !file(IDPath+"telephon.dbf")
     request=.F.
  endif
  if !file(IDPath+"telephon.dbt")
     request=.F.
  endif
  if !file(IDPath+"notepad.dbf")
     request=.F.
  endif
  if !file(IDPath+"notepad.dbt")
     request=.F.
  endif
  if !file(IDPath+"business.dbf")
     request=.F.
  endif
  if !file(IDPath+"meeting.dbf")
     request=.F.
  endif
  if request
     filename=IDPath+"business.dbf"
     SELECT 3
     USE &filename
     filename=IDPath+"business.ntx"
     INDEX ON Begin TO &filename
     filename=IDPath+"meeting.dbf"
     SELECT 2
     USE &filename 
     filename=IDPath+"meeting.ntx"
     INDEX ON Time TO &filename
  else
     SET COLOR TO W/N
     @ 00,00,23,79 BOX "�Ŀ����� "
     @ 01,01,22,78 BOX "�Ŀ����� "
     @ 02,03 SAY '    �� ࠡ�� ���ᮭ��쭮� ���ଠ樮���� ��⥬�  ��  �����,  �����'
     @ 03,03 SAY '�������� ���� ��࠭����� �� ��᪥ � ��᪮�쪨� 䠩���.  ���⮬� ��� ��-'
     @ 04,03 SAY '���쭮� ࠡ��� OFFICE-QUEST �� ��᪥ ��襣� �������� ������ ������⢮-'
     @ 05,03 SAY '���� ᫥���騥 䠩��:'
     @ 06,03 SAY '    BUSINESS.DBF'
     @ 07,03 SAY '    MEETING.DBF'
     @ 08,03 SAY '    TELEPHON.DBF'
     @ 09,03 SAY '    TELEPHON.DBT'
     @ 10,03 SAY '    NOTEPAD.DBF'
     @ 11,03 SAY '    NOTEPAD.DBT'
     @ 12,03 SAY '�� 䠩�� ᮤ�ঠ� ⮫쪮  ���  �����  �  ���  ������  �ᯮ��������  �'
     @ 13,03 SAY '�⤥�쭮� ��⠫��� (��४�ਨ). ��� ��⠫��� ���஥ ����㯭� ���ᮭ���-'
     @ 14,03 SAY '��� ���ଠ樮���� ��⥬� ᫥���饥:'
     @ 15,03 SAY '      ->'
     @ 16,03 SAY '��� ����室��� �஢���� ������� �� �� ��襯���᫥��� 䠩�� � 㪠���-'
     @ 17,03 SAY '��� ��४�ਨ.  �᫨ ������-����� 䠩�� ��� ����⠭���� ���, �ᯮ����'
     @ 18,03 SAY '�।��騥 ����� (���஡��� ᬮ�� � �㪮����⢥ ������).'
     SET COLOR TO +GR/N
     @ 15,12 SAY IDPath
     @ 20,03 SAY '                              ��� �த������� ������ ���� �������.'
     inkey(0)
  endif
RETURN request
