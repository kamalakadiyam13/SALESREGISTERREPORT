@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'For customer data'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCustomerDatas as select from I_OperationalAcctgDocItem as oa 
{
    key oa.AccountingDocument,
    oa.CompanyCode,
    oa.FiscalYear,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
     oa.AmountInCompanyCodeCurrency,
     oa.CompanyCodeCurrency,
     @Semantics.amount.currencyCode: 'TransactionCurrency'
    oa.AmountInTransactionCurrency,
    oa.TransactionCurrency,
    oa.Customer,
    oa.OffsettingAccount,
    oa.Plant,
    oa.NetDueDate,
    oa.DocumentItemText,
    oa.InvoiceReference,
    oa.InvoiceItemReference,
    oa.InvoiceReferenceFiscalYear
}
where 
//( oa.TransactionTypeDetermination = 'AGD'  or oa.TransactionTypeDetermination = 'EGK' or oa.TransactionTypeDetermination = '') 
//and oa.Customer <> ''
(
    oa.TransactionTypeDetermination = ''
    or oa.TransactionTypeDetermination = 'AGD'
    or oa.TransactionTypeDetermination = 'EGK'
)
and
(
       (oa.AccountingDocumentType = 'RV' and oa.Customer <> '')
    or (oa.AccountingDocumentType = 'DR' and oa.Customer <> '')
    or (oa.AccountingDocumentType = 'DG' and oa.Customer <> '')
    or (oa.AccountingDocumentType = 'DZ' and oa.Customer <> '')
    or (oa.AccountingDocumentType = 'AB' and (oa.PostingKey = '05' or oa.PostingKey = '02' or oa.PostingKey = '12') and oa.Customer <> '')
    or (oa.AccountingDocumentType = 'DC' and oa.Customer <> '')
    or (oa.AccountingDocumentType = 'DI' and oa.Customer <> '')
)

 //AND OA.AccountingDocumentItem = '0001'
