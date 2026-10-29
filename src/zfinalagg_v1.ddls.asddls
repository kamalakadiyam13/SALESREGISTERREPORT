@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'desc for FINAL AGG_V1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity ZFINALAGG_V1 as select from ZSTRINGAGGREGATION_V1 as t0
{
     key t0.AccountingDocument,
   t0.FiscalPeriod,
   t0.FiscalYear,
   t0.PostingDate,
   t0.ProfitCenter,
   t0.CompanyCode,
   t0.GLAccount,
   t0.InvoiceReference,
   t0.AccountingDocumentType,
   max(JOSAccount) as JOSAccount,
   max(JOCAccount) as JOCAccount,
   max(JOIAccount) as JOIAccount,
   t0.TransactionTypeDetermination
}
group by t0.AccountingDocument,
   t0.FiscalPeriod,
   t0.FiscalYear,
   t0.PostingDate,
   t0.ProfitCenter,
   t0.CompanyCode,
   t0.AccountingDocumentType,t0.GLAccount,
   t0.InvoiceReference,
   t0.TransactionTypeDetermination
