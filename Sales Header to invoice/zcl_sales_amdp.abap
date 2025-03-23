PERFORM sales_header_text.

FORM sales_header_text .
  CONSTANTS: lc_vbbk TYPE tdobject VALUE 'VBBK',
             lc_id   TYPE tdid VALUE '0002'.

  DATA: lt_header_text TYPE TABLE OF tline,
        lv_tdname      TYPE stxh-tdname,
        lv_final_text  TYPE string.

  CLEAR: lt_header_text[],
         lv_tdname,
         lv_final_text.

  DATA(lv_vbeln_vauf) = |{ vbdkr-vbeln_vauf ALPHA = OUT } |.
  lv_tdname = lv_vbeln_vauf.

  PERFORM read_text TABLES lt_header_text
        USING lc_vbbk lv_tdname lc_id vbdkr-spras_we.

  IF lt_header_text IS NOT INITIAL.
    LOOP AT lt_header_text ASSIGNING FIELD-SYMBOL(<ls_header_text>).
      lv_final_text = |{ lv_final_text } { <ls_header_text>-tdline }|.
    ENDLOOP.
    lv_final_text = condense( lv_final_text ).
  ENDIF.
  CLEAR: gv_final_text1,
         gv_final_text2,
         gv_final_text3,
         gv_final_text4,
         gv_final_text5,
         gv_final_text6,
         gv_final_text7,
         gv_final_text8.
  DATA(lv_len) = strlen( lv_final_text ).
  IF lv_len >= 57.
    gv_final_text1 = lv_final_text(57).
  ELSE.
    gv_final_text1 = lv_final_text.
    RETURN.
  ENDIF.
  IF lv_len >= 81.
    gv_final_text2 = lv_final_text+58(23).
  ELSE.
    gv_final_text2 = lv_final_text+58.
    RETURN.
  ENDIF.
  IF lv_len >= 93.
    gv_final_text3 = lv_final_text+81(11).
  ELSE.
    gv_final_text3 = lv_final_text+81.
    RETURN.
  ENDIF.

  IF lv_len >= 109.
    gv_final_text4 = lv_final_text+93(15).
  ELSE.
    gv_final_text4 = lv_final_text+93.
    RETURN.
  ENDIF.
  IF lv_len >= 130.
    gv_final_text5 = lv_final_text+109(20).
  ELSE.
    gv_final_text5 = lv_final_text+109.
    RETURN.
  ENDIF.
  IF lv_len >= 174.
    gv_final_text6 = lv_final_text+130(44).
  ELSE.
    gv_final_text6 = lv_final_text+130.
    RETURN.
  ENDIF.
  IF lv_len >= 362.
    gv_final_text7 = lv_final_text+174(188).
    lv_len = lv_len - 362.
    gv_final_text8 = lv_final_text+362(lv_len).
  ELSE.
    gv_final_text7 = lv_final_text+174.
    gv_final_text8 = ''.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  READ_TEXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LT_HEADER_TEXT  text
*      -->P_LC_VBBK  text
*      -->P_LV_TDNAME  text
*      -->P_LC_ID  text
*      -->P_VBDKR_SPRAS_WE  text
*----------------------------------------------------------------------*
FORM read_text  TABLES   out_text_tab STRUCTURE tline
                USING    in_tdobject  LIKE stxh-tdobject
                         in_tdname    LIKE stxh-tdname
                         in_tdid      LIKE stxh-tdid
                         in_tdspras   LIKE stxh-tdspras.
  CONSTANTS: lc_readtxt(9) TYPE c VALUE 'READ_TEXT'.
  REFRESH out_text_tab.
  CALL FUNCTION lc_readtxt
    EXPORTING
      id                      = in_tdid
      language                = in_tdspras
      name                    = in_tdname
      object                  = in_tdobject
    TABLES
      lines                   = out_text_tab
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
ENDFORM.