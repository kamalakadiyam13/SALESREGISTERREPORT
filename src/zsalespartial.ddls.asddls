@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'For Sales Partial'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZSalesPartial as  select distinct from I_JournalEntryItem as inv
 left outer join I_GLAccountText as gl on inv.GLAccount = gl.GLAccount and gl.Language = 'E'
left outer join I_JournalEntryItem as p1
    on  inv.AccountingDocument = p1.InvoiceReference
    //and inv.AccountingDocumentItem = p1.InvoiceItemReference
    and inv.CompanyCode = p1.CompanyCode
    and inv.FiscalYear = p1.FiscalYear
    and ( p1.AccountingDocumentType = 'DZ' or p1.AccountingDocumentType = 'ZP' )
    and p1.InvoiceReference <> ''
    and p1.ClearingJournalEntry = ''
 
left outer join I_JournalEntryItem as p2
    on  inv.AccountingDocument = p2.InvoiceReference
    //and inv.AccountingDocumentItem = p2.InvoiceItemReference
    and inv.CompanyCode = p2.CompanyCode
    and inv.FiscalYear = p2.FiscalYear
    and ( p2.AccountingDocumentType = 'DZ' or p2.AccountingDocumentType = 'ZP' )
    and p2.CreationDateTime > p1.CreationDateTime
    and p2.InvoiceReference <> ''
    and p2.ClearingJournalEntry = ''
 
left outer join I_JournalEntryItem as p3
    on  inv.AccountingDocument = p3.InvoiceReference
    //and inv.AccountingDocumentItem = p3.InvoiceItemReference
    and inv.CompanyCode = p3.CompanyCode
    and inv.FiscalYear = p3.FiscalYear
    and ( p3.AccountingDocumentType = 'DZ' or p3.AccountingDocumentType = 'ZP' )
    and p3.CreationDateTime > p2.CreationDateTime
    and p3.InvoiceReference <> ''
    and p3.ClearingJournalEntry = ''
 
left outer join I_JournalEntryItem as p4
    on  inv.AccountingDocument = p4.InvoiceReference
    //and inv.AccountingDocumentItem = p4.InvoiceItemReference
    and inv.CompanyCode = p4.CompanyCode
   and inv.FiscalYear = p4.FiscalYear
    and ( p4.AccountingDocumentType = 'DZ' or p4.AccountingDocumentType = 'ZP' )
    and p4.CreationDateTime > p3.CreationDateTime
    and p4.InvoiceReference <> ''
    and p4.ClearingJournalEntry = ''
 
left outer join I_JournalEntryItem as p5
    on  inv.AccountingDocument = p5.InvoiceReference
   // and inv.AccountingDocumentItem = p5.InvoiceItemReference
    and inv.CompanyCode = p5.CompanyCode
    and inv.FiscalYear = p5.FiscalYear
    and ( p5.AccountingDocumentType = 'DZ' or p5.AccountingDocumentType = 'ZP' )
    and p5.CreationDateTime > p4.CreationDateTime
    and p5.InvoiceReference <> ''
    and p5.ClearingJournalEntry = ''
    
//    left outer join I_Withholdingtaxitem as wht on inv.AccountingDocument = wht.AccountingDocument
//    and inv.AccountingDocumentItem = wht.AccountingDocumentItem and inv.CompanyCode = wht.CompanyCode
 
{
    key inv.CompanyCode,
    key inv.FiscalYear,
    key inv.AccountingDocument  as InvoiceDocument,
    key inv.AccountingDocumentType,
    p1.AccountingDocumentType as rev_type,
    inv.ClearingJournalEntry,
    //inv.TransactionCurrency,
    inv.CompanyCodeCurrency,

    inv.DocumentDate as DocumentDate,
    inv.PostingDate as PostingDate,
    inv.IsReversal,
    inv.IsReversed,


min( cast( inv.AmountInCompanyCodeCurrency as abap.dec(23,2) ) ) as invamt,
//sum(cast( inv.AmountInCompanyCodeCurrency as abap.dec(23,2) )) as totalbase_amt,

min( p1.AccountingDocument ) as Payment1_Doc,
cast(min (cast( p1.AmountInCompanyCodeCurrency as abap.dec(23,2) )) as abap.dec(23,2)) as Payment1_Amt,
min( p1.PostingDate ) as Payment1_Date,
min( p2.AccountingDocument ) as Payment2_Doc,
cast(min(cast( p2.AmountInCompanyCodeCurrency as abap.dec(23,2) ))  as abap.dec(23,2)) as Payment2_Amt,
min( p2.PostingDate ) as Payment2_Date,
min( p3.AccountingDocument ) as Payment3_Doc,
cast(min(cast( p3.AmountInCompanyCodeCurrency as abap.dec(23,2) )) as abap.dec(23,2)) as Payment3_Amt,
min( p3.PostingDate ) as Payment3_Date,
min( p4.AccountingDocument ) as Payment4_Doc,
cast(min(cast( p4.AmountInCompanyCodeCurrency as abap.dec(23,2) )) as abap.dec(23,2)) as Payment4_Amt,
min( p4.PostingDate ) as Payment4_Date,
min( p5.AccountingDocument ) as Payment5_Doc,
cast(min(cast( p5.AmountInCompanyCodeCurrency as abap.dec(23,2) )) as abap.dec(23,2)) as Payment5_Amt,
min( p5.PostingDate ) as Payment5_Date
}
 

 where inv.Ledger = '0L'
and inv.ClearingJournalEntry = ''
and ( inv.AccountingDocumentType = 'DR' or inv.AccountingDocumentType = 'DG' or inv.AccountingDocumentType = 'RV' or inv.AccountingDocumentType = 'DI' or inv.AccountingDocumentType = 'DC' )
and inv.LedgerGLLineItem = '000001'


group by
    inv.CompanyCode,
    inv.FiscalYear,
    inv.AccountingDocument,
    inv.TransactionCurrency,
    inv.CompanyCodeCurrency,
    inv.AccountingDocumentType,
    inv.ClearingJournalEntry,
    p1.AccountingDocumentType,
    inv.DocumentDate,
    inv.IsReversal,
    inv.IsReversed,
    inv.PostingDate
