@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'For Sales Main Payments'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZSalesPaymentMain as select distinct from ZSalesPaymentSub as pa
left outer join ZSales_SUM_of_gst as sg on pa.AccountingDocument = sg.AccountingDocument and pa.AccountingDocumentType = sg.AccountingDocumentType
{
    key pa.AccountingDocument,
    pa.FiscalYear,
    pa.AccountingDocumentType,
    pa.Invoiceamount,
    pa.Payment1_Amt,
    pa.Payment1_Date,
    pa.Payment1_Doc,
    pa.payment_type,
    pa.Payment2_Amt,
    pa.Payment2_Date,
    pa.Payment2_Doc,
    pa.Payment3_Amt,
    pa.Payment3_Date,
    pa.Payment3_Doc,
    pa.Payment4_Amt,
    pa.Payment4_Date,
    pa.Payment4_Doc,
    pa.Payment5_Amt,
    pa.Payment5_Date,
    pa.Payment5_Doc,
   // case when pa.kr_clear = pa.kz_doc then 'Close' else 'Open' end as Status,
//    case 
//    when ( pa.IsReversed = 'X' or pa.IsReversal = 'X' ) then 'Cancelled' 
//    when abs(cast(pa.Invoiceamount as abap.dec(23,2))) = abs(cast(
//         
//              coalesce(pa.Payment1_Amt,0)
//            + coalesce(pa.Payment2_Amt,0)
//            + coalesce(pa.Payment3_Amt,0)
//            + coalesce(pa.Payment4_Amt,0)
//            + coalesce(pa.Payment5_Amt,0)
//       
//   
//as abap.dec(23,2))
//)  then 'Close'
//else 'Open' end as DocumentStatus,
'' as DocumentStatus,
cast(0 as abap.dec(23,2)) as IGST_Amount,
cast(0 as abap.dec(23,2)) as SGST_Amount,
cast(0 as abap.dec(23,2)) as CGST_Amount,
cast(0 as abap.dec(23,2)) as TAXABLE_AMT,
pa.CompanyCodeCurrency, 
cast(0 as abap.dec(23,2)) as LINE_WISE_TOTAL_TAX,
cast(0 as abap.dec(23,2)) as TDS_Amt,
//sg.TDS_Amt,
sg.ReferenceDocument
}
