@AbapCatalog.sqlViewName: 'ZSOCDSAUTH'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Sales Order CDS view'
@OData.publish: true
define view ZSO_CDS_VIEW
  as select from vbak
    inner join   vbap on vbak.vbeln = vbap.vbeln
{
  key vbak.vbeln,
      vbak.auart,
      vbak.erdat,
      vbak.kunnr,
      vbak.vkorg,
      vbap.matnr,
      vbap.netpr,
      vbap.kwmeng
}
