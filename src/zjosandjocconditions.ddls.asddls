@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'For JOS AND JOCConditions'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZJOSANDJOCConditions as select from  ZJOCConditions as cgst
left outer join ZJOSConditions as sgst on sgst.AccountingDocument = cgst.AccountingDocument
and sgst.CompanyCode = cgst.CompanyCode
and sgst.FiscalYear = sgst.FiscalYear
{
    key cgst.AccountingDocument,
    cgst.AccountingDocumentType,
    cgst.CompanyCodeCurrency,
    cast(cgst.AmountInCompanyCodeCurrency as abap.dec(23,2)) as CGSTCompany,
    cast(cgst.AmountInFunctionalCurrency as abap.dec(23,2)) as CGSTFunc,
    cast(cgst.AmountInTransactionCurrency as abap.dec(23,2)) as CGSTTrans,
    cast(sgst.AmountInCompanyCodeCurrency as abap.dec(23,2)) as SGSTCOMPANY,
    cast(sgst.AmountInFunctionalCurrency as abap.dec(23,2)) as SGSTFunc,
    cast(sgst.AmountInTransactionCurrency as abap.dec(23,2)) as SGSTTrans,
    sgst.CompanyCode,
    sgst.FiscalYear,
    cgst.GLAccount as CGSTGL,
    sgst.GLAccount as SGSTGL
}
