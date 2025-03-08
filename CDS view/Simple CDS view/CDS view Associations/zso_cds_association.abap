@AbapCatalog.sqlViewName: 'ZSO_CDSASSO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View with Association'
define view zso_cds_association as 
 select from vbak as so
  association [0..1] to kna1 as _Customer
    on so.kunnr = _Customer.kunnr
{
  key so.vbeln,         // Sales Order Number
      so.erdat,         // Creation Date
      so.netwr,         // Net Value
      so.kunnr,
      _Customer        // Association to KNA1 (Customer Table)
}