CREATE PROCEDURE INVOICES_TOTAL_AMOUNT

AS
BEGIN

	SELECT ltrim(Replace(regexp_substr(ORDER_REF, '[^-]+', 1, 1),'PO',''), '0')  Order_Reference,
	to_char(TO_DATE(ORDER_DATE, 'dd-mm-YYYY','NLS_DATE_LANGUAGE = American'),'MON-YYYY') ORDER_PERIOD,
	INITCAP(SUPPLIER_NAME) SUPPLIER_NAME,
	TO_CHAR(NVL(ORDER_TOTAL_AMOUNT,0), '99G999G999G9999', 'NLS_NUMERIC_CHARACTERS=",."') ORDER_TOTAL_AMOUNT,
	ORD_STATUS.DESCRIPTION ORDER_STATUS,
	INVOICE_REFERENCE,
	TO_CHAR(SUM(NVL(INVOICE_AMOUNT,0)), '99G999G999G9999', 'NLS_NUMERIC_CHARACTERS=",."') INVOICE_TOTAL_AMOUNT,
	CASE INV_STATUS.DESCRIPTION WHEN 'Paid' THEN 'OK'
	WHEN 'Pending' THEN 'To follow up'
	ELSE 'To verify' END ACTION
	from XXBCM_ORDER ORDER
	LEFT JOIN XXBCM_SUPPLIER SUPPLIER ON SUPPLIER.SUPPLIER_ID = ORDER.SUPPLIER_ID
	LEFT JOIN XXBCM_INVOICE INVOICE ON INVOICE.ORDER_ID =ORDER.ORDER_ID
	LEFT JOIN XXBCM_ORDER_STATUS ORD_STATUS ON ORD_STATUS.ORDER_STATUS_ID = ORDER.ORDER_STATUS
	LEFT JOIN XXBCM_INVOICE_STATUS INV_STATUS ON INV_STATUS.INVOICE_STATUS_ID = INVOICE.INVOICE_STATUS
	GROUP BY
		ORDER_REF,ORDER_DATE,SUPPLIER_NAME,ORD_STATUS.DESCRIPTION,INVOICE_REFERENCE,INVOICE_AMOUNT,INV_STATUS.DESCRIPTION
	order by TO_DATE(ORDER_DATE, 'dd-mm-YYYY','NLS_DATE_LANGUAGE = American') DESC;

END;