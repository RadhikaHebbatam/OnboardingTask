
--a)PropertyId and PropertyName for owner 1426
	SELECT   P.Name as PropertyName ,
			 OP.PropertyId ,
			 OP.OwnerId
	FROM     OwnerProperty OP join Property P on OP.PropertyId=P.Id 
	WHERE    OwnerId=1426

--b)Current Home Value for all properties Listed above

    SELECT   OP.PropertyId ,
	         OP.OwnerId,
	         P.Name as PropertyName ,			 
			 PHV.Value as CurrentValue
	FROM     OwnerProperty OP join Property P on OP.PropertyId=P.Id 
	         join PropertyHomeValue PHV on PHV.PropertyId=OP.PropertyId
			 join PropertyHomeValueType PHVT on PHV.HomeValueTypeId=PHVT.Id
	WHERE    OwnerId=1426 and PHV.HomeValueTypeId=1 and PHV.IsActive=1 
	ORDER BY PropertyName

	/*For each property in question a), return the following:                                                                      
    Using rental payment amount, rental payment frequency, tenant start date and tenant end date to write a query that returns the sum of all payments from start date to end date. 
     Display the yield
    */	

 SELECT *,  ((QR.TotalRent/QR.PropertyValue)*100) AS Yield FROM
(
  SELECT   OP.PropertyId ,   
	                 P.Name as PropertyName ,
			         TP.PaymentAmount AS RentPayment,
			         TPF.Name as Frequency,
			         CONVERT(date,TP.StartDate) AS StartDate,
			         CONVERT(date,TP.EndDate) AS EndDate,
					 (CASE TPF.Name
			         WHEN 'Weekly' THEN (TP.PaymentAmount * DATEDIFF(Week,StartDate,EndDate))
				     WHEN 'Fortnightly' THEN (TP.PaymentAmount * (DATEDIFF(Week,StartDate,EndDate)/2))
				     ELSE (TP.PaymentAmount * DATEDIFF(Month,StartDate,EndDate))
		             END) AS TotalRent,
					 PHV.Value AS PropertyValue 
	                 FROM     OwnerProperty OP join Property P on OP.PropertyId=P.Id 
	                 join TenantProperty TP on TP.PropertyId=OP.PropertyId
			         join TenantPaymentFrequencies TPF on TPF.Id=TP.PaymentFrequencyId
					 join PropertyHomeValue PHV on PHV.PropertyId=OP.PropertyId
			         join PropertyHomeValueType PHVT on PHV.HomeValueTypeId=PHVT.Id
	                 WHERE    OwnerId =1426 and PHV.HomeValueTypeId=1 and PHV.IsActive=1
) AS QR

/* d: Display all jobs available */

SELECT J.JobDescription,
       JS.Status 
FROM   Job J inner join JobStatus JS on J.JobStatusId=JS.ID 
WHERE  JS.Status='Open'

/*e: Display all property names, current tenants first and last names and rental payments 
per week/ fortnight/month for the properties in question a). */

   SELECT    OP.PropertyId ,
	         OP.OwnerId,
	         P.Name as PropertyName ,			 
			 PS.FirstName,
			 PS.LastName,
			 TP.PaymentAmount as RentPayment,
			 TPF.Name as Frequency		        
			       
	FROM     OwnerProperty OP join Property P on OP.PropertyId=P.Id 
	         join TenantProperty TP on TP.PropertyId=OP.PropertyId
			 join TenantPaymentFrequencies TPF on TPF.Id=TP.PaymentFrequencyId
			 Join Tenant T on TP.TenantId=T.Id
			 join Person PS on T.Id=PS.Id       
	WHERE    OwnerId=1426  and T.IsActive=1 and PS.IsActive=1 
	ORDER BY PropertyName