@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'For Clearing Payments 02'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZClearingSalesData02 
as select from I_JournalEntryItem as jei
{
  key jei.ClearingJournalEntry,
  key jei.CompanyCode,
  key jei.FiscalYear,
  jei.AccountingDocumentType,
  jei.AccountingDocument as CLEARING_DOC,
 sum( cast( AmountInCompanyCodeCurrency as abap.dec(23,2) ) ) as Clearing_Amt,
  min( jei.ClearingDate ) as ClearingDate,
  jei.ClearingJournalEntryFiscalYear,
  jei.PostingDate,
  jei.CompanyCodeCurrency
}
where ( jei.AccountingDocumentType ='DZ' or jei.AccountingDocumentType ='ZP')
  and jei.ClearingJournalEntry <> ''
  and jei.Ledger = '0L'
group by jei.ClearingJournalEntry, 
 jei.ClearingJournalEntryFiscalYear,
jei.CompanyCode,
 jei.FiscalYear, 
jei.AccountingDocument,
jei.CompanyCodeCurrency,
  jei.AccountingDocumentType,
  jei.PostingDate
