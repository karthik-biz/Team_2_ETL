#!/bin/bash
mysql -u karthik -p101332649 << EOF
USE ACTIANS_DWPROD;

UPDATE ACTIANS_DWPROD.customers prod
JOIN ACTIANS_DWSTAGE.customers stage ON prod.src_customerNumber = stage.customerNumber
   SET prod.customerName = stage.customerName,
       prod.contactLastName = stage.contactLastName,
       prod.contactFirstName = stage.contactFirstName,
       prod.phone = stage.phone1,
       prod.addressLine1 = stage.addressLine1,
       prod.addressLine2 = stage.addressLine2,
       prod.city = stage.city,
       prod.state = stage.state,
       prod.postalCode = stage.postalCode,
       prod.country = stage.country,
       prod.salesRepEmployeeNumber = stage.salesRepEmployeeNumber,
       prod.creditLimit = stage.creditLimit,
       prod.src_update_timestamp = stage.update_timestamp,
       prod.dw_update_timestamp = CURRENT_TIMESTAMP;
       
INSERT INTO ACTIANS_DWPROD.customers
(
  src_customerNumber,
  customerName,
  contactLastName,
  contactFirstName,
  phone,
  addressLine1,
  addressLine2,
  city,
  state,
  postalCode,
  country,
  salesRepEmployeeNumber,
  creditLimit,
  src_create_timestamp,
  src_update_timestamp,
  dw_create_timestamp,
  dw_update_timestamp
)
SELECT c.*,
       CURRENT_TIMESTAMP AS dw_create_timestamp,
       CURRENT_TIMESTAMP AS dw_update_timestamp
FROM ACTIANS_DWSTAGE.customers stage LEFT JOIN ACTIANS_DWPROD.customers prod ON stage.customerNumber=prod.src_customerNumber
WHERE prod.src_customerNumber IS NULL;

UPDATE ACTIANS_DWPROD.offices prod
JOIN ACTIANS_DWSTAGE.offices stage ON prod.officeCode = stage.officeCode
   SET prod.city = stage.city,
       prod.phone = stage.phone,
       prod.addressLine1 = stage.addressLine1,
       prod.addressLine2 = stage.addressLine2,
       prod.state = stage.state,
       prod.country = stage.country,
       postalCode = stage.postalCode,
       prod.territory = stage.territory,
       prod.src_update_timestamp = stage.update_timestamp,
       prod.dw_update_timestamp = CURRENT_TIMESTAMP;
       
INSERT INTO ACTIANS_DWPROD.offices
(
  officeCode,
  city,
  phone,
  addressLine1,
  addressLine2,
  state,
  country,
  postalCode,
  territory,
  src_create_timestamp,
  src_update_timestamp,
  dw_create_timestamp,
  dw_update_timestamp
)
SELECT c.*,
       CURRENT_TIMESTAMP AS dw_create_timestamp,
       CURRENT_TIMESTAMP AS dw_update_timestamp
FROM ACTIANS_DWSTAGE.offices stage LEFT JOIN ACTIANS_DWPROD.offices prod on stage.officeCode=prod.officeCode
WHERE prod.officeCode IS NULL;

UPDATE ACTIANS_DWPROD.productlines prod
JOIN ACTIANS_DWSTAGE.productlines stage ON prod.productLine = stage.productLine
   SET prod.textDescription = stage.textDescription,
       prod.htmlDescription = stage.htmlDescription,
       prod.image = stage.image,
       prod.src_update_timestamp = stage.update_timestamp,
       prod.dw_update_timestamp = CURRENT_TIMESTAMP;
       
INSERT INTO ACTIANS_DWPROD.productlines
(
  productline,
  textDescription,
  htmlDescription,
  image,
  src_create_timestamp,
  src_update_timestamp,
  dw_create_timestamp,
  dw_update_timestamp
)
SELECT A.*,
       CURRENT_TIMESTAMP AS dw_create_timestamp,
       CURRENT_TIMESTAMP AS dw_update_timestamp
FROM ACTIANS_DWSTAGE.productlines stage LEFT JOIN ACTIANS_DWPROD.productlines prod ON stage.productLine=prod.productLine
WHERE prod.productLine IS NULL;

UPDATE ACTIANS_DWPROD.payments prod
JOIN ACTIANS_DWSTAGE.payments stage ON prod.checkNumber = stage.checkNumber
   SET prod.paymentDate = stage.paymentDate,
       prod.amount = stage.amount,
       prod.src_update_timestamp = stage.update_timestamp,
       prod.dw_update_timestamp = CURRENT_TIMESTAMP;
INSERT INTO ACTIANS_DWPROD.payments
(
  dw_customer_id,
  src_customerNumber,
  checkNumber,
  paymentDate,
  amount,
  src_create_timestamp,
  src_update_timestamp,
  dw_create_timestamp,
  dw_update_timestamp
)
SELECT c.dw_customer_id,
       stage.customerNumber,
       stage.checkNumber,
       stage.paymentDate,
       stage.amount,
       stage.create_timestamp,
       stage.update_timestamp,
       CURRENT_TIMESTAMP AS dw_create_timestamp,
       CURRENT_TIMESTAMP AS dw_update_timestamp
FROM ACTIANS_DWSTAGE.payments stage LEFT JOIN ACTIANS_DWPROD.payments prod ON stage.checkNumber=prod.checkNumber
  JOIN ACTIANS_DWPROD.customers c ON stage.customerNumber = c.src_customerNumber
WHERE prod.checkNumber IS NULL;

UPDATE ACTIANS_DWPROD.employees prod
JOIN ACTIANS_DWSTAGE.employees stage ON prod.employeeNumber = stage.employeeNumber
JOIN ACTIANS_DWPROD.offices o ON stage.officeCode = o.officeCode
JOIN ACTIANS_DWPROD.temp t ON stage.employeeNumber = t.employeeNumber
   SET prod.lastName = stage.lastName,
       prod.firstName = stage.firstName,
       prod.extension = stage.extension,
       prod.email = stage.email,
       prod.officeCode = o.officeCode,
       prod.reportsTo = stage.reportsTo,
       prod.jobTitle = stage.jobTitle,
       prod.dw_office_id = o.dw_office_id,
       prod.dw_reporting_employee_id = t.dw_reporting_employee_id,
       prod.src_update_timestamp = stage.update_timestamp,
       prod.dw_update_timestamp = CURRENT_TIMESTAMP;
       
INSERT INTO ACTIANS_DWPROD.employees
(
  employeeNumber,
  lastName,
  firstName,
  extension,
  email,
  officeCode,
  reportsTo,
  jobTitle,
  dw_office_id,
  dw_reporting_employee_id,
  src_create_timestamp,
  src_update_timestamp,
  dw_create_timestamp,
  dw_update_timestamp
)
SELECT stage.employeeNumber,
       stage.lastName,
       stage.firstName,
       stage.extension,
       stage.email,
       stage.officeCode,
       stage.reportsTo,
       stage.jobTitle,
       b.dw_office_id,
       c.dw_employee_id,
       stage.create_timestamp,
       stage.update_timestamp,
       CURRENT_TIMESTAMP AS dw_create_timestamp,
       CURRENT_TIMESTAMP AS dw_update_timestamp
FROM ACTIANS_DWPROD.temp stage LEFT JOIN ACTIANS_DWPROD.employees prod ON stage.employeeNumber=prod.employeeNumber
  JOIN ACTIANS_DWPROD.offices b ON stage.officeCode = b.officeCode
  LEFT JOIN ACTIANS_DWPROD.temp c ON stage.reportsTo = c.employeeNumber
WHERE prod.employeeNumber IS NULL;

UPDATE ACTIANS_DWPROD.products prod
JOIN ACTIANS_DWSTAGE.products stage ON prod.productCode = stage.productCode
JOIN ACTIANS_DWPROD.productlines pl ON pl.productLine = stage.productLine
   SET prod.productName = stage.productName,
       prod.productLine = stage.productLine,
       prod.productScale = stage.productScale,
       prod.productVendor = stage.productVendor,
       prod.productDescription = stage.productDescription,
       prod.quantityInStock = stage.quantityInStock,
       prod.buyPrice = stage.buyPrice,
       prod.MSRP = stage.MSRP,
       prod.dw_product_line_id = pl.dw_product_line_id,
       prod.src_update_timestamp = stage.update_timestamp,
       prod.dw_update_timestamp = CURRENT_TIMESTAMP;
INSERT INTO ACTIANS_DWPROD.products
(
  src_productCode,
  productName,
  productLine,
  productScale,
  productVendor,
  productDescription,
  quantityInStock,
  buyPrice,
  MSRP,
  dw_product_line_id,
  src_create_timestamp,
  src_update_timestamp,
  dw_create_timestamp,
  dw_update_timestamp
)
SELECT stage.productCode,
       stage.productName,
       stage.productLine,
       stage.productScale,
       stage.productVendor,
       stage.productDescription,
       stage.quantityInStock,
       stage.buyPrice,
       stage.MSRP,
       B.dw_product_line_id,
       stage.create_timestamp,
       stage.update_timestamp,
       CURRENT_TIMESTAMP AS dw_create_timestamp,
       CURRENT_TIMESTAMP AS dw_update_timestamp
FROM ACTIANS_DWSTAGE.products stage LEFT JOIN ACTIANS_DWPROD.products prod ON stage.productCode=prod.src_productCode
  JOIN ACTIANS_DWPROD.productlines B ON stage.productLine = B.productline
WHERE prod.src_productCode IS NULL;

UPDATE ACTIANS_DWPROD.orders prod
JOIN ACTIANS_DWSTAGE.orders stage ON prod.src_orderNumber = stage.orderNumber
JOIN ACTIANS_DWPROD.customers c ON stage.customerNumber = c.customerNumber
   SET prod.dw_customer_id = c.dw_customer_id prod.orderDate = stage.orderDate,
       prod.requiredDate = stage.requiredDate,
       prod.shippedDate = stage.shippedDate,
       prod.status = stage.status,
       prod.comments = stage.comments,
       prod.src_customerNumber = stage.customerNumber,
       prod.src_update_timestamp = stage.update_timestamp,
       prod.dw_update_timestamp = CURRENT_TIMESTAMP;
INSERT INTO ACTIANS_DWPROD.orders
(
  dw_customer_id,
  src_orderNumber,
  orderDate,
  requiredDate,
  shippedDate,
  status,
  comments,
  src_customerNumber,
  src_create_timestamp,
  src_update_timestamp,
  dw_create_timestamp,
  dw_update_timestamp,
  cancelledDate
)
SELECT C.dw_customer_id,
       stage.orderNumber,
       stage.orderDate,
       stage.requiredDate,
       stage.shippedDate,
       stage.status,
       stage.comments,
       stage.customerNumber,
       stage.create_timestamp,
       stage.update_timestamp,
       CURRENT_TIMESTAMP AS dw_create_timestamp,
       CURRENT_TIMESTAMP AS dw_update_timestamp,
       stage.cancelledDate
FROM ACTIANS_DWSTAGE.orders stage LEFT JOIN ACTIANS_DWPROD.orders prod ON stage.orderNumber=prod.src_orderNumber
  JOIN ACTIANS_DWPROD.customers C ON stage.customerNumber = C.src_customerNumber
WHERE prod.src_orderNumber IS NULL;

UPDATE ACTIANS_DWPROD.orderdetails prod
JOIN ACTIANS_DWSTAGE.orderdetails stage ON prod.src_orderNumber = stage.orderNumber AND prod.src_productCode = stage.productCode
   SET prod.quantityOrdered = stage.quantityOrdered,
       prod.priceEach = stage.priceEach,
       prod.orderLineNumber = stage.orderLineNumber,
       prod.src_update_timestamp = stage.update_timestamp,
       prod.dw_update_timestamp = CURRENT_TIMESTAMP;
       
INSERT INTO ACTIANS_DWPROD.orderdetails
(
  dw_order_id,
  dw_product_id,
  src_orderNumber,
  src_productCode,
  quantityOrdered,
  priceEach,
  orderLineNumber,
  src_create_timestamp,
  src_update_timestamp,
  dw_create_timestamp,
  dw_update_timestamp
)
SELECT o.dw_order_id,
       p.dw_product_id,
       stage.*,
       CURRENT_TIMESTAMP AS dw_create_timestamp,
       CURRENT_TIMESTAMP AS dw_update_timestamp
FROM ACTIANS_DWSTAGE.orderdetails stage LEFT JOIN ACTIANS_DWPROD.orderdetails prod on stage.orderNumber=prod.src_orderNumber and stage.productCode=prod.src_productCode
  JOIN ACTIANS_DWPROD.orders o ON o.src_orderNumber = stage.orderNumber
  JOIN ACTIANS_DWPROD.products p ON stage.productCode = p.src_productCode
WHERE prod.src_orderNumber IS NULL AND prod.src_productCode IS NULL;

