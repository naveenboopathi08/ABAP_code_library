@EndUserText.label: 'table function'
define table function ZTF_SalesOrder
returns { 
    clientno: abap.clnt;
    salesord_no: vbeln;        // Sales Order Number
    customer_no: kunnr;        // Customer Number
     kwmeng      : abap.quan( 10, 2 );    // Order Quantity  
    total_amount: abap.cuky( 5 ); // Calculated Total Amount
}
implemented by method ZCL_SALES_AMDP=>GET_SALES_DATA;