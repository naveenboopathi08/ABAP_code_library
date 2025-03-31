 CONSTANTS: lc_e1edk02  TYPE edilsegtyp        VALUE 'E1EDK02',
             lc_sd       TYPE z_team           VALUE 'SD',
             lc_bukrs    TYPE bukrs            VALUE 'ALL',
             lc_updatepo TYPE z_object         VALUE 'UPDATE_PO',
             lc_sndprn   TYPE z_constant       VALUE 'PARTNER01'.
  DATA: ls_idoc_contrl TYPE edidc,
        ls_const1      TYPE z_const.

CLEAR: ls_const1,
         ls_edidd.
  SELECT SINGLE * FROM z_const
    INTO ls_const1
    WHERE zteam    = lc_sd
        AND bukrs  = lc_bukrs
        AND object = lc_updatepo
        AND const  = lc_sndprn
        AND value  = wa_edidc-sndprn
        AND const1 = space
        AND value1 = space
        AND const2 = space
        AND value2 = space.
  IF sy-subrc = 0 AND line_exists( idoc_contrl[ sndprn = ls_const1-value ] ).
    READ TABLE idoc_data INTO ls_edidd WITH KEY segnam = lc_e1edk02.
    DATA(ls_e1edk02) = ls_edidd-sdata.
    IF ls_e1edk02+44(8) IS INITIAL.
      ls_e1edk02+44(8) = sy-datum.
      ls_edidd-sdata = ls_e1edk02.
      MODIFY idoc_data FROM ls_edidd TRANSPORTING sdata WHERE segnam = lc_e1edk02.
    ENDIF.
  ENDIF.