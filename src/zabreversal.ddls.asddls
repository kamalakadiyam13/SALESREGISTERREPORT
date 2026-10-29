@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'For AB reversal'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZABReversal as
select from I_JournalEntryItem as inv
left outer join I_GLAccountText as gl on inv.GLAccount = gl.GLAccount and gl.Language = 'E'
inner join I_JournalEntryItem as jei1 on inv.ReversalReferenceDocument = jei1.AccountingDocument and inv.AccountingDocumentItem = jei1.AccountingDocumentItem
and (jei1.AccountingDocumentType = 'DG' or  jei1.AccountingDocumentType = 'DR' or  jei1.AccountingDocumentType = 'RV' or  (jei1.AccountingDocumentType = 'DZ' and jei1.SpecialGLCode <> '' ) )
and jei1.Ledger = '0L'
{
key inv.CompanyCode,
    key inv.FiscalYear,
    key inv.AccountingDocument,
    key inv.AccountingDocumentType,
    inv.AccountingDocumentItem,
    jei1.AccountingDocumentType as rev_type,
    jei1.AccountingDocument as rev_doc,
    inv.LedgerGLLineItem as LedgerGLLineItem,
    inv.Product,
    inv.CostCenter,
    inv.CreationDate,
    inv.DocumentDate,
    inv.PostingDate,
    inv.NetDueDate,
    inv.Plant,
    inv.TaxCode,
    inv.GLAccount,
    inv.YY1_HSN_Code_COB,
    cast(inv.Quantity as abap.dec( 11, 2 )) as Quantity,
    inv.BaseUnit,
    inv.ProfitCenter,
    inv.AccountingDocCreatedByUser,
    inv.AssignmentReference,
    inv.ReversalReferenceDocument,
    inv.WBSElementInternalID,
cast(
    -abs( cast( inv.AmountInCompanyCodeCurrency as abap.dec(23,2) ) )
    as abap.dec(23,2)
) as reversal_amt,
   inv.TransactionCurrency,
    inv.CompanyCodeCurrency
}
where
 
inv.Ledger = '0L'
and
gl.GLAccountName not like '%TDS%' and gl.GLAccountName not like '%Rounded%'
 
and inv.AccountingDocumentType='AB' and inv.IsReversal = 'X'
and ( inv.TransactionTypeDetermination <> 'AGD' or inv.TransactionTypeDetermination <> 'EGK' )
//and inv.Customer = ''
and inv.TaxCode <> ''
and ( inv.TransactionTypeDetermination <> 'JIC' and inv.TransactionTypeDetermination <> 'JIS' and inv.TransactionTypeDetermination <> 'JII'  
and inv.TransactionTypeDetermination <> 'JOC' and inv.TransactionTypeDetermination <> 'JOS' and inv.TransactionTypeDetermination <> 'JOI' and  inv.TransactionTypeDetermination <> 'JCI'
and inv.TransactionTypeDetermination <> 'JRC' and inv.TransactionTypeDetermination <> 'JRS' and inv.TransactionTypeDetermination <> 'JRI')
