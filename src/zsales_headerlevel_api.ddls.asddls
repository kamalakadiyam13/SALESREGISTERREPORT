@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'For Header level Pay'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel: {
modelingPattern: #ANALYTICAL_DIMENSION,
    supportedCapabilities: [#ANALYTICAL_DIMENSION, #CDS_MODELING_ASSOCIATION_TARGET, #SQL_DATA_SOURCE, #CDS_MODELING_DATA_SOURCE]
    }
define view entity ZSALES_HEADERLEVEL_API as select distinct from Z_Sales_Register_Report as pr
left outer join ZSalesPaymentMain as pay on pr.AccountingDocument = pay.AccountingDocument and pr.AccountingDocumentType = pay.AccountingDocumentType
left outer join I_BusinessUserBasic as bu on pr.AccountingDocCreatedByUser = bu.UserID 
{
    key pr.CompanyCode,
    pr.FiscalYear,
    pr.PostingDate,
    bu.PersonFullName as Created_by,
    pr.CreationDate,
    pr.AccountingDocument,
    pr.AccountingDocumentType,
    pr.OverallBillingStatusDesc,
    pr.BillingDocument,
    pr.ReferenceDocument,
    pr.YY1_EMAIL_REFERENCE_SDH,
    //pr.PostingDate,
    pr.DueDate,
    //pr.InventoryGL_ExpensiveGL,
    //pr.InventoryGL_ExpensiveGL_text,
    pr.Plant,
    pr.DocumentReferenceID as AssignmentReference,
    pr.SalesDocument,
    pr.SalesOrganization,
    //pr.MaterialDocument,
    pr.CustomerAccountGroup,
    pr.PayerParty,
    pr.BusinessPartnerFullName,
    pr.TaxNumber3,
    pr.AccountingDocumentHeaderText,
    //pr.BPGSTIN,
    pr.BusinessPlace,
    //pr.SalesDocument,
    //pr.PurchasingDocumentTypeName,
    pr.BillToPartyRegion,
    substring( pr.TaxNumber3, 3, 10 ) as pannumber,
    sum(cast(pr.DebitAmountinCompCurrency1 as abap.dec(23,2))) as TaxableAmount,
    sum(cast(pr.DiscountAmount1 as abap.dec(23,2))) as discount_amt,
    sum(cast(pr.JOCGValue as abap.dec(15,2))) as CGST_Amount,
  sum(cast(pr.JOSGValue as abap.dec(15,2))) as SGST_Amount,
    sum(cast(pr.JOIGValue as abap.dec(15,2))) as IGST_Amount,
    //(cast(pr.IGST_Amount as abap.dec(23,2))) as IGST_Amount, 
    //sum(cast(pr.Frieght_amt as abap.dec(15,2))) as Frieght_amt,
    //sum(cast(pr.Frieght_tax_amt as abap.dec(15,2))) as Frieght_tax_amt,
    //(cast(pr.Frieght_amt as abap.dec(15,2))) as Frieght_amt,
    //(cast(pr.Frieght_tax_amt as abap.dec(15,2))) as Frieght_tax_amt,
    //pr.PaymentTerms,
    //pr.PaymentTermsName,
    //pr.,
    //pr.ApInvoiceReferenceNo,
    //pr.ApInvoiceDate,
    pr.CompanyCodeCurrency,
sum(
      coalesce( cast( pr.JOCGValue as abap.dec(15,2) ), cast( 0 as abap.dec(15,2) ) )
    + coalesce( cast( pr.JOSGValue as abap.dec(15,2) ), cast( 0 as abap.dec(15,2) ) )
    + coalesce( cast( pr.JOIGValue as abap.dec(15,2) ), cast( 0 as abap.dec(15,2) ) )
) as Total_Tax_Amount,

sum(
    cast(
        (
            coalesce( cast( pr.JOCGValue as abap.dec(23,2) ), cast( 0 as abap.dec(23,2) ) )
          + coalesce( cast( pr.JOSGValue as abap.dec(23,2) ), cast( 0 as abap.dec(23,2) ) )
          + coalesce( cast( pr.JOIGValue as abap.dec(23,2) ), cast( 0 as abap.dec(23,2) ) )
          + coalesce( cast( pr.DebitAmountinCompCurrency1 as abap.dec(23,2) ), cast( 0 as abap.dec(23,2) ) )
        )
    as abap.dec(23,2) )
) as Row_Total_Value,
pay.Invoiceamount as Total_value,

//(cast(
//      (
//            coalesce(pr.IGST_Amount,0)
//          + coalesce(pr.CGST_Amount,0)
//          + coalesce(pr.SGST_Amount,0)
//          + coalesce(pr.RCM_CGST_Amount,0)
//          + coalesce(pr.RCM_SGST_Amount,0)
//          + coalesce(pr.RCM_IGST_Amount,0)
//      )
//as abap.dec(23,2))) as Total_Tax_Amount,
//
//(cast(
//      (
//            coalesce(pr.IGST_Amount,0)
//          + coalesce(pr.CGST_Amount,0)
//          + coalesce(pr.SGST_Amount,0)
//          + coalesce(pr.RCM_CGST_Amount,0)
//          + coalesce(pr.RCM_SGST_Amount,0)
//          + coalesce(pr.RCM_IGST_Amount,0)
//          + coalesce(pr.TaxableAmount,0)
//      )
//as abap.dec(23,2))) as Row_Total_Value,
//
//(cast(
//      (
//            coalesce(pr.IGST_Amount,0)
//          + coalesce(pr.CGST_Amount,0)
//          + coalesce(pr.SGST_Amount,0)
//          + coalesce(pr.RCM_CGST_Amount,0)
//          + coalesce(pr.RCM_SGST_Amount,0)
//          + coalesce(pr.RCM_IGST_Amount,0)
//          + coalesce(pr.TaxableAmount,0)
//          + coalesce(pr.TDSAmt,0)
//      )
//as abap.dec(23,2))) as Total_value,
//sum(pay.Payment1_Amt) as Payment1_Amt,
cast(
    case
        when pr.OverallBillingStatusDesc = 'Cancelled'
            then cast(0 as abap.dec(23,2))

        else cast(pay.Payment1_Amt as abap.dec(23,2))
    end
as abap.dec(23,2)) as Payment1_Amt,
case
    when pr.OverallBillingStatusDesc = 'Cancelled' 
        then cast( '00000000' as abap.dats )

    else cast( pay.Payment1_Date as abap.dats )
end as Payment1_Date,
case
    when pr.OverallBillingStatusDesc = 'Cancelled'
        then cast( '' as abap.char(10) )

    else cast( pay.Payment1_Doc as abap.char(10) )
end as Payment1_Doc,
//sum(pay.Payment2_Amt) as Payment2_Amt,
//(pay.Payment2_Amt) as Payment2_Amt,
//pay.Payment2_Date,
//pay.Payment2_Doc,
cast(
    case
        when pr.OverallBillingStatusDesc = 'Cancelled' 
            then cast(0 as abap.dec(23,2))
        else cast(pay.Payment2_Amt as abap.dec(23,2))
    end
as abap.dec(23,2)) as Payment2_Amt,

case
    when pr.OverallBillingStatusDesc = 'Cancelled'
        then cast('00000000' as abap.dats)
    else cast(pay.Payment2_Date as abap.dats)
end as Payment2_Date,

case
    when pr.OverallBillingStatusDesc = 'Cancelled' 
        then cast('' as abap.char(10))
    else cast(pay.Payment2_Doc as abap.char(10))
end as Payment2_Doc,
//sum(pay.Payment3_Amt) as Payment3_Amt,
//(pay.Payment3_Amt) as Payment3_Amt,
//pay.Payment3_Date,
//pay.Payment3_Doc,
cast(
    case
        when pr.OverallBillingStatusDesc = 'Cancelled'
            then cast(0 as abap.dec(23,2))
        else cast(pay.Payment3_Amt as abap.dec(23,2))
    end
as abap.dec(23,2)) as Payment3_Amt,

case
    when pr.OverallBillingStatusDesc = 'Cancelled'
        then cast('00000000' as abap.dats)
    else cast(pay.Payment3_Date as abap.dats)
end as Payment3_Date,

case
    when pr.OverallBillingStatusDesc = 'Cancelled'
        then cast('' as abap.char(10))
    else cast(pay.Payment3_Doc as abap.char(10))
end as Payment3_Doc,
//sum(pay.Payment4_Amt) as Payment4_Amt,
//(pay.Payment4_Amt) as Payment4_Amt,
//pay.Payment4_Date,
//pay.Payment4_Doc,
cast(
    case
        when pr.OverallBillingStatusDesc = 'Cancelled'
            then cast(0 as abap.dec(23,2))
        else cast(pay.Payment4_Amt as abap.dec(23,2))
    end
as abap.dec(23,2)) as Payment4_Amt,

case
    when pr.OverallBillingStatusDesc = 'Cancelled'
        then cast('00000000' as abap.dats)
    else cast(pay.Payment4_Date as abap.dats)
end as Payment4_Date,

case
    when pr.OverallBillingStatusDesc = 'Cancelled'
        then cast('' as abap.char(10))
    else cast(pay.Payment4_Doc as abap.char(10))
end as Payment4_Doc,
case
    when pr.OverallBillingStatusDesc = 'Cancelled'
        then cast('00000000' as abap.dats)
    else cast(pay.Payment5_Date as abap.dats)
end as Payment5_Date,

case
    when pr.OverallBillingStatusDesc = 'Cancelled'
        then cast('' as abap.char(10))
    else cast(pay.Payment5_Doc as abap.char(10))
end as Payment5_Doc,

cast(
    case
        when pr.OverallBillingStatusDesc = 'Cancelled'
            then cast(0 as abap.dec(23,2))
        else cast(pay.Payment5_Amt as abap.dec(23,2))
    end
as abap.dec(23,2)) as Payment5_Amt,
//sum(pay.Payment5_Amt) as Payment5_Amt,
pay.payment_type,
//sum(pay.Invoiceamount) as Invoiceamount
(pay.Invoiceamount) as Invoiceamount
//    cast(
//    sum(coalesce( pr.IGST_Amount, 0 ))
//  + sum(coalesce( pr.CGST_Amount, 0 ))
//  + sum(coalesce( pr.SGST_Amount, 0 ))
//  + sum(coalesce(pr.RCM_CGST_Amount,0))
//  + sum(coalesce(pr.RCM_SGST_Amount,0))
//  + sum(coalesce(pr.RCM_IGST_Amount,0))
//as abap.dec(23,2)) as Total_Tax_Amount,
//
//cast(
//    sum(coalesce( pr.IGST_Amount, 0 ))
//  + sum(coalesce( pr.CGST_Amount, 0 ))
//  + sum(coalesce( pr.SGST_Amount, 0 ))
//  + sum(coalesce(pr.RCM_CGST_Amount,0))
//  + sum(coalesce(pr.RCM_SGST_Amount,0))
//  + sum(coalesce(pr.RCM_IGST_Amount,0))
//  + sum(coalesce(pr.TaxableAmount,0))
//as abap.dec(23,2)) as Row_Total_Value,
//
//cast(
//    sum(coalesce( pr.IGST_Amount, 0 ))
//  + sum(coalesce( pr.CGST_Amount, 0 ))
//  + sum(coalesce( pr.SGST_Amount, 0 ))
//  + sum(coalesce(pr.RCM_CGST_Amount,0))
//  + sum(coalesce(pr.RCM_SGST_Amount,0))
//  + sum(coalesce(pr.RCM_IGST_Amount,0))
//  + sum(coalesce(pr.TaxableAmount,0))
//  + sum(coalesce(pr.TDSAmt,0))
//as abap.dec(23,2)) as Total_value

    
}

group by
pr.CompanyCode,
    pr.PostingDate,
    //pr.Created_by,
    bu.PersonFullName,
     pr.CreationDate,
    pr.AccountingDocument,
    pr.AccountingDocumentType,
    pr.OverallBillingStatusDesc,
    pr.BillingDocument,
    pr.AccountingDocumentHeaderText,
    pr.FiscalYear,
    //pr.Duedate,
   // pr.InventoryGL_ExpensiveGL,
    //pr.InventoryGL_ExpensiveGL_text,
    pr.Plant,
    //pr.AssignmentReference,
    pr.SalesDocument,
    //pr.MaterialDocument,
     pr.CustomerAccountGroup,
    pr.PayerParty,
    pr.BusinessPartnerFullName,
    pr.TaxNumber3,
    pr.BusinessPlace,
    pr.CompanyCodeCurrency,
    pr.DueDate,
    pr.SalesOrganization,
//    pr.PurchaseOrderType,
//    pr.PurchasingDocumentTypeName,
    pr.BillToPartyRegion,
//    pr.pannumber,
   // pr.RCM_IGSTRate,
//    pr.PaymentTerms,
//    pr.PaymentTermsName,
//    pr.PurchasingOrganization,
//    pr.ApInvoiceReferenceNo,
//    pr.ApInvoiceDate,
//    pr.CGSTRate,
//    pr.SGSTRate,
//    pr.IGSTRate,
//    pr.RCM_CGSTRate,
//    pr.RCM_SGSTRate,
//    pr.RCM_IGSTRate,
   
//    pr.TaxcodeDescription,
    //pr.TDS_Code,
    pr.DocumentReferenceID,
    pr.CompanyCodeCurrency,
   pay.Payment1_Amt,
pay.Payment1_Date,
pay.Payment1_Doc,
pay.Payment2_Amt,
pay.Payment2_Date,
pay.Payment2_Doc,
pay.Payment3_Amt,
pay.Payment3_Date,
pay.Payment3_Doc,
pay.Payment4_Amt,
pay.Payment4_Date,
pay.Payment4_Doc,
pay.Payment5_Amt,
pay.Payment5_Date,
pay.Payment5_Doc,
pay.payment_type,
pay.Invoiceamount,
pr.ReferenceDocument,
pr.YY1_EMAIL_REFERENCE_SDH
//pr.TDSAmt
