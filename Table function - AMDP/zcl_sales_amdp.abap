CLASS zcl_sales_amdp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .
  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb.
    CLASS-METHODS get_sales_data
        FOR TABLE FUNCTION ztf_salesorder.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.
CLASS zcl_sales_amdp IMPLEMENTATION.
  METHOD get_sales_data BY DATABASE FUNCTION
      FOR HDB  " Runs only on HANA
      LANGUAGE SQLSCRIPT
      OPTIONS READ-ONLY USING vbak vbap.
    RETURN
      SELECT
        so.mandt     as clientno,
        so.vbeln     as salesord_no,
        so.kunnr     as customer_no,
        it.kwmeng    as kwmeng,
        sum(so.netwr * it.kwmeng) as total_amount
      from vbak as so
      INNER JOIN vbap AS it
    ON so.vbeln = it.vbeln
      group by so.mandt,so.vbeln, so.kunnr,it.kwmeng;
  endmethod.
ENDCLASS.