@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'For Clearing Payments  MAIN'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZClearingSalesDataMAIN as select from  ZClearingSalesData01  as ori
left outer join ZClearingSalesData02  as jei
on  ori.ClearingJournalEntry = jei.CLEARING_DOC
and ori.CompanyCode = jei.CompanyCode
and ori.ClearingJournalEntryFiscalYear = jei.ClearingJournalEntryFiscalYear
//and ori.FiscalYear = jei.FiscalYear
{
  key ori.AccountingDocument,
  ori.AccountingDocumentType,
  jei.AccountingDocumentType as clear_type,
  ori.CompanyCode,
  ori.FiscalYear,
  ori.Orginal_Amt,
  jei.CLEARING_DOC,
  jei.Clearing_Amt,
  ori.ClearingDate,
  jei.PostingDate,
  ori.CompanyCodeCurrency,
  ori.ClearingJournalEntry as kr_cle_doc,
  ori.IsReversal,
  ori.IsReversed
}
