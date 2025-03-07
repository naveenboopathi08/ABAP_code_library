*&---------------------------------------------------------------------*
*&  Include           ZCHANGE_REQ_DEL_DATE
*&---------------------------------------------------------------------*

*----------------------------------------------------------------------*
* Description                                                          *
* To change requested delivery date using country code for oders       *
*----------------------------------------------------------------------*


CONSTANTS: lc_object    TYPE /bay0/gz_object   VALUE 'REQ_DELIVERY_DATE',
           lc_time      TYPE sy-uzeit          VALUE '130000',
           lc_cz        TYPE wfcid             VALUE 'CZ',                 "Time Zone according to the user
           lc_indicator TYPE indicator         VALUE '+',
           lc_va03      TYPE sy-tcode          VALUE 'VA03',
           lc_va02      TYPE sy-tcode          VALUE 'VA02',
           lc_flag      TYPE char1             VALUE 'X'.
DATA: lv_attr_1      TYPE char1,
      lv_days_to_add TYPE i,
      lv_exit        TYPE char1.

CLEAR: lv_exit,lv_attr_1.
IMPORT lv_exit FROM MEMORY ID 'EXIT_FLAG'.		                   "While creation of order this user is called multiple of time. To prevent the update every time, I used Import/Export memory ID
SELECT SINGLE attr_1
  FROM z_const								   "Instead of writing multiple IF conditions, I added all the condition in custom table. If entry found the subrc value will be zero.
  INTO lv_attr_1
  WHERE zteam  = lc_zteam
  AND   bukrs  = vbak-bukrs_vf
  AND   object = lc_object
  AND   const  = lc_con
  AND   value  = vbak-vkorg
  AND   const1 = lc_con1
  AND   value1 = vbak-auart
  AND   const2 = space
  AND   value2 = space.

IF sy-subrc IS INITIAL AND sy-tcode <> lc_va03
                       AND sy-tcode <> lc_va02
                       AND lv_exit <> lc_flag.				   "Prevent the updation while using VA02 and VA03.
  CLEAR: lv_exit,
         lv_days_to_add.
  lv_exit = lc_flag.
  EXPORT lv_exit TO MEMORY ID 'EXIT_FLAG'.
  CALL FUNCTION 'DAY_IN_WEEK'
    EXPORTING
      datum = vbak-vdatu
    IMPORTING
      wotnr = lv_day.

  lv_days_to_add = SWITCH i( lv_day
    WHEN 1 THEN COND i( WHEN sy-uzeit < lc_time THEN 1 ELSE 2 )
    WHEN 2 THEN COND i( WHEN sy-uzeit < lc_time THEN 1 ELSE 2 )
    WHEN 3 THEN COND i( WHEN sy-uzeit < lc_time THEN 1 ELSE 2 )
    WHEN 4 THEN COND i( WHEN sy-uzeit < lc_time THEN 1 ELSE 4 )
    WHEN 5 THEN COND i( WHEN sy-uzeit < lc_time THEN 3 ELSE 4 )
    WHEN 6 THEN COND i( WHEN sy-uzeit < lc_time THEN 2 ELSE 3 )
    WHEN 7 THEN COND i( WHEN sy-uzeit < lc_time THEN 1 ELSE 2 ) ).

  vbak-vdatu = vbak-vdatu + lv_days_to_add.

  CALL FUNCTION 'DATE_CONVERT_TO_FACTORYDATE'			 	  "If the date is not working day, this FM gives the next working day according to factory calender ID.
    EXPORTING
      correct_option               = lc_indicator
      date                         = vbak-vdatu
      factory_calendar_id          = lc_cz
    IMPORTING
      date                         = vbak-vdatu
    EXCEPTIONS
      calendar_buffer_not_loadable = 1
      correct_option_invalid       = 2
      date_after_range             = 3
      date_before_range            = 4
      date_invalid                 = 5
      factory_calendar_not_found   = 6
      OTHERS                       = 7.
  IF sy-subrc <> 0.
* Implement suitable error handling here				   "Implement suitable Error handling accordingly.
  ENDIF.
ENDIF.

