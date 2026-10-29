@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'desc for String Agg V1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity ZSTRINGAGG_V1 as select from I_AccountingDocumentJournal(P_Language : 'E')
{
    key AccountingDocument,
    TransactionTypeDetermination,
    ProfitCenter,
    PostingDate,
    FiscalPeriod,
    FiscalYear,
    GLAccount,
    CompanyCode,
    AccountingDocumentType,
    InvoiceReference
    
}
where ( TransactionTypeDetermination = 'JOC' 
 or TransactionTypeDetermination = 'JOS' 
 or TransactionTypeDetermination = 'JOI' )
 group by AccountingDocument, TransactionTypeDetermination,ProfitCenter,PostingDate,FiscalPeriod,FiscalYear,GLAccount,
 CompanyCode,
 AccountingDocumentType,
 InvoiceReference
