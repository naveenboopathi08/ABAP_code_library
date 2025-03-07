*&---------------------------------------------------------------------*
*& Report ZCDS_CONSUME01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zcds_consume01.

TABLES: zsocdsauth.

DATA: lt_data TYPE TABLE OF zsocdsauth,
      lo_alv  TYPE REF TO cl_salv_table.

START-OF-SELECTION.

  SELECT * FROM zsocdsauth INTO TABLE lt_data UP TO 100 ROWS.

  IF lt_data IS NOT INITIAL.
    TRY.
        CALL METHOD cl_salv_table=>factory
          IMPORTING
            r_salv_table = lo_alv
          CHANGING
            t_table      = lt_data.
        lo_alv->display( ).
      CATCH cx_salv_msg INTO DATA(lx_msg).
        MESSAGE lx_msg->get_text( ) TYPE 'E'.
    ENDTRY.
  ELSE.
    MESSAGE 'No data found in CDS View' TYPE 'I'.
  ENDIF.