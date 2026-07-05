PROGRAM main
  VAR_INPUT
    IceRequest : BOOL;
    MixType1 : BOOL;
    MixType2 : BOOL;
    MixType3 : BOOL;
    Liqueur1 : BOOL;
    Liqueur2 : BOOL;
    WaterRequest : BOOL;
  END_VAR
  VAR_OUTPUT
    DispenseIce : BOOL;
    DispenseMix1 : BOOL;
    DispenseMix2 : BOOL;
    DispenseMix3 : BOOL;
    DispenseLiqueur1 : BOOL;
    DispenseLiqueur2 : BOOL;
    DispenseWater : BOOL;
    CocktailReady : BOOL;
  END_VAR

  DispenseIce := IceRequest;
  DispenseWater := WaterRequest;
  DispenseMix1 := NOT(MixType3) AND NOT(MixType2) AND MixType1;
  DispenseMix2 := NOT(MixType3) AND NOT(MixType1) AND MixType2;
  DispenseMix3 := NOT(MixType2) AND NOT(MixType1) AND MixType3;
  DispenseLiqueur1 := NOT(Liqueur2) AND Liqueur1;
  DispenseLiqueur2 := NOT(Liqueur1) AND Liqueur2;
  CocktailReady := (DispenseLiqueur1 OR DispenseLiqueur2) AND (DispenseMix1 OR DispenseMix2 OR DispenseMix3) AND DispenseIce;
END_PROGRAM


CONFIGURATION Config0

  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 1);
    PROGRAM instance0 WITH task0 : main;
  END_RESOURCE
END_CONFIGURATION
