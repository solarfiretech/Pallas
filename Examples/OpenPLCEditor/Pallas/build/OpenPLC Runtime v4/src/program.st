PROGRAM main
  VAR
    LocalVar0 : BOOL;
    LocalVar1 : BOOL;
    LocalOut0 : BOOL;
    LocalOut1 : BOOL;
  END_VAR

  LocalOut0 := LocalVar0;
  LocalOut1 := LocalVar1;
END_PROGRAM


CONFIGURATION Config0

  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 1);
    PROGRAM instance0 WITH task0 : main;
  END_RESOURCE
END_CONFIGURATION
