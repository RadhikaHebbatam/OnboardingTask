SELECT  p.Name,
        (PS.FirstName) as CurrentOwner,
        CONCAT(A.Number,' ',A.Street,' ',A.Suburb,' ', A.City,' ',A.Region,' ',A.PostCode) as PropertAddress,
		CONCAT(p.Bedroom ,' Bedrooms ',p.Bathroom,' Bathrooms') as PropertyDetails,
		CONCAT('$',PRV.Amount,' Per '+ TPF.Name) as Frequency,
		PE.Description,PE.Amount,PE.Date

FROM  Property P
inner join  OwnerProperty OP on p.id=OP.PropertyId 
inner join Owners O on OP.OwnerId=O.Id
inner join Person PS on O.id=PS.Id
inner join Address A on P.AddressId=A.AddressId
inner join PropertyRentalPayment PRV on PRV.PropertyId =P.Id
inner join TenantPaymentFrequencies TPF on TPF.id=PRV.FrequencyType
inner join PropertyExpense PE on PE.PropertyId=P.Id
where P.Name='Property A'