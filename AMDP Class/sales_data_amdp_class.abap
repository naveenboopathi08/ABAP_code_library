*Simple AMDP class for fetch the sales data from VBAK & VBAP table based on customer number.

CLASS zcl_amdp_sales DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb.
    TYPES: BEGIN OF ty_sales_data,
             vbeln TYPE vbeln_va,
             erdat TYPE erdat,
             kunnr TYPE kunnr,
             matnr TYPE matnr,
             netwr TYPE netwr,
           END OF ty_sales_data.

    TYPES: tt_sales_data TYPE TABLE OF ty_sales_data.
    CLASS-METHODS get_sales_data
      IMPORTING VALUE(iv_kunnr) TYPE kunnr
      EXPORTING VALUE(et_data)  TYPE tt_sales_data.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_amdp_sales IMPLEMENTATION.
  METHOD get_sales_data BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT OPTIONS READ-ONLY USING vbak vbap.
    et_data =
          SELECT a.vbeln, a.erdat, a.kunnr, b.matnr, b.netwr
          FROM vbak AS a
          INNER JOIN vbap AS b
          ON a.vbeln = b.vbeln
          WHERE a.kunnr = :iv_kunnr;
  ENDMETHOD.
ENDCLASS.
