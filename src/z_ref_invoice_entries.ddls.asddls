@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'For Invoice Entries data'
@Metadata.ignorePropagatedAnnotations: true
define view entity Z_ref_invoice_entries as select distinct from I_JournalEntryItem as jei
inner join I_JournalEntry as je1 on je1.AccountingDocument = jei.AccountingDocument and je1.FiscalYear = jei.FiscalYear and jei.CompanyCode = je1.CompanyCode

inner join I_JournalEntry as je on je.AccountingDocument = jei.InvoiceReference and je.FiscalYear = jei.InvoiceReferenceFiscalYear and jei.CompanyCode = je.CompanyCode and je.AccountingDocumentType = 'DR'
{
    key jei.AccountingDocument as DG_doc,
    jei.FiscalYear as DG_year,
    jei.CompanyCode as DG_companycode,
    je.PostingDate as DR_postingdate,
    je.AccountingDocument as DR_DocumentNo,
    je.FiscalYear as DR_Fyear,
    je.CompanyCode as DR_companycode,
    je.DocumentReferenceID,
    je1.DocumentReferenceID as docrefid
    
}
where jei.Ledger = '0L'
and (
    jei.TransactionTypeDetermination = ''
    or jei.TransactionTypeDetermination = 'AGD'
    or jei.TransactionTypeDetermination = 'EGK'
)
and
(
      // (jei.AccountingDocumentType = 'RV' and jei.Customer <> '')
    //or (jei.AccountingDocumentType = 'DR' and jei.Customer <> '')
     (jei.AccountingDocumentType = 'DG' and jei.Customer <> '')
    //or (jei.AccountingDocumentType = 'DZ' and jei.Customer <> '')
    //or (jei.AccountingDocumentType = 'AB' and (jei.PostingKey = '05' or jei.PostingKey = '12') and jei.Customer <> '')
    or (jei.AccountingDocumentType = 'DC' and jei.Customer <> '')
    or (jei.AccountingDocumentType = 'DI' and jei.Customer <> '')
)
