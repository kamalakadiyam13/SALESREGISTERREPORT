@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'For Clearing Payments  AB'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZSalesClearingAB as select from I_JournalEntryItem as inv
 left outer join I_GLAccountText as gl on inv.GLAccount = gl.GLAccount and gl.Language = 'E'
 inner join I_JournalEntryItem as jei1 on inv.ReversalReferenceDocument = jei1.AccountingDocument and inv.AccountingDocumentItem = jei1.AccountingDocumentItem
and (jei1.AccountingDocumentType = 'DG' or  jei1.AccountingDocumentType = 'DR' or  jei1.AccountingDocumentType = 'RV' or  jei1.AccountingDocumentType = 'DI' or  jei1.AccountingDocumentType = 'DC')
and jei1.Ledger = '0L'
{
 key inv.CompanyCode,
    key inv.FiscalYear,
    key inv.AccountingDocument,
    key inv.AccountingDocumentType,
    jei1.AccountingDocumentType as rev_type,
    jei1.AccountingDocument as rev_doc,
    jei1.PostingDate,
    inv.IsReversal,
    inv.IsReversed,
cast(
    -abs( cast( inv.AmountInCompanyCodeCurrency as abap.dec(23,2) ) )
    as abap.dec(23,2)
) as reversal_amt,
    inv.CompanyCodeCurrency
}
where 

 inv.Ledger = '0L'
and 
 gl.GLAccountName not like '%TDS%' and gl.GLAccountName not like '%Rounded%'
and inv.ClearingJournalEntry <> ''
and inv.AccountingDocumentType='AB' and inv.IsReversal = 'X'
