@AbapCatalog.sqlViewName: 'ZSOCDSMULTI'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Multiple association'
define view zso_cds_multi
  as select from vbak as so
  association [0..1] to kna1 as _Customer on so.kunnr = _Customer.kunnr

  association [1..*] to vbap as _Soitems  on so.vbeln = _Soitems.vbeln

  association [0..1] to vbrk as _Billing  on so.vbeln = _Billing.vbeln


{

  key so.vbeln, // Sales Order Number
      so.erdat,  // Order Date
      so.netwr,  // Net Value
      so.kunnr,  // Customer Number
      _Customer, // Association to Customer Details
      _Soitems, // Association to Sales Order Items
      _Billing // Association to Billing Document
}