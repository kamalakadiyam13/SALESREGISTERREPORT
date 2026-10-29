@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'desc for netvalue deatils'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity ZNETVALUE as select from I_AccountingDocumentJournal(P_Language : 'E') as t0
{
    key t0.AccountingDocument,
    t0.DocumentReferenceID,
    t0.CompanyCode,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    max(t0.DebitAmountInCoCodeCrcy) as DebitAmountinCompCurrency,
    t0.CompanyCodeCurrency,
     @Semantics.amount.currencyCode: 'TransactionCurrency'
    max(t0.DebitAmountInTransCrcy) as DebitAmountinTransCurrency,
    t0.TransactionCurrency,
    t0.FiscalYear
}
where cast(t0.FiscalYear as abap.int2) > 2024
group by t0.AccountingDocument,t0.CompanyCode, t0.CompanyCodeCurrency,t0.TransactionCurrency,t0.FiscalYear, t0.DocumentReferenceID
