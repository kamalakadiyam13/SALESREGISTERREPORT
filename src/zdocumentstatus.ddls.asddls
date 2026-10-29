@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'For Document Status'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZdocumentStatus as select from I_JournalEntryItem as jei
{
  key jei.AccountingDocument,
  key jei.CompanyCode,
  key jei.FiscalYear,
  jei.AccountingDocumentType,
  jei.ClearingJournalEntry,
sum( cast( jei.AmountInCompanyCodeCurrency as abap.dec(23,2) ) ) as Orginal_Amt,
jei.CompanyCodeCurrency,
jei.IsReversal,
jei.IsReversed
}
where ( jei.AccountingDocumentType ='DR' or jei.AccountingDocumentType ='DG' or jei.AccountingDocumentType ='RV' or jei.AccountingDocumentType ='DI' or jei.AccountingDocumentType ='DC' )
  and jei.ClearingJournalEntry <> ''
  and jei.Ledger = '0L'
group by
jei.AccountingDocument,
jei.CompanyCode,
jei.FiscalYear,
jei.AccountingDocumentType,
jei.CompanyCodeCurrency,
jei.ClearingJournalEntry,
jei.IsReversal,
jei.IsReversed
