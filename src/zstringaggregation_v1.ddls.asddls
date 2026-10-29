@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'desc for String Aggregration V1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity ZSTRINGAGGREGATION_V1 as select from ZSTRINGAGG_V1 as t0
{
    key t0.AccountingDocument,
   t0.FiscalPeriod,
   t0.FiscalYear,
   t0.PostingDate,
   t0.ProfitCenter,
   t0.CompanyCode,
   t0.GLAccount,
   t0.AccountingDocumentType,
   t0.InvoiceReference,
   t0.TransactionTypeDetermination,
      case 
  when t0.TransactionTypeDetermination ='JOS' then 
     max( t0.GLAccount )
     else
    ''
end as JOSAccount,
      case 
  when t0.TransactionTypeDetermination ='JOC' then 
     max( t0.GLAccount )
     else
     ''
end as JOCAccount,
      case 
  when t0.TransactionTypeDetermination ='JOI' then 
     max( t0.GLAccount )
     else
     ''
end as JOIAccount
}
group by t0.AccountingDocument,
   t0.FiscalPeriod,
   t0.FiscalYear,
   t0.PostingDate,
   t0.ProfitCenter,
   t0.CompanyCode,
   t0.TransactionTypeDetermination,
   t0.AccountingDocumentType,
   t0.GLAccount,
   t0.InvoiceReference
