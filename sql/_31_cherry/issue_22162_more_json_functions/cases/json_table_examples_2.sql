-- Examples from https://docs.oracle.com/database/121/SQLRF/functions092.htm#SQLRF56973

drop table if exists j_purchaseorder;
CREATE TABLE j_purchaseorder (id INT not null, name varchar(10), po_document json);

-- CBRD-22399
INSERT INTO j_purchaseorder   VALUES ( 1, 'example' , '{
    "POINT": 1600,
    "Reference": "ABULL-20140421",
    "Requestor": "Alexis Bull",
    "User": "ABULL",
    "CostCenter": "A50",
    "ShippingInstructions": {
        "name": "Alexis Bull",
        "Address": {
            "street": "200 Sporting Green",
            "city": "South San Francisco",
            "state": "CA",
            "zipCode": 99236,
            "country": "United States of America"
        },
        "Phone": [{
            "type": "Office",
            "number": "909-555-7307"
        }, {
            "type": "Mobile",
            "number": "415-555-1234"
        }]
    },
    "Special Instructions": null,
    "AllowPartialShipment": true,
    "LineItems": [{
        "ItemINT": 1,
        "Part": {
            "Description": "One Magic Christmas",
            "UnitPrice": 19.95,
            "UPCCode": 13131092899
        },
        "Quantity": 9.0
    }, {
        "ItemINT": 2,
        "Part": {
            "Description": "Lethal Weapon",
            "UnitPrice": 19.95,
            "UPCCode": 85391628927
        },
        "Quantity": 5.0
    }]
}');

SELECT jt.phones FROM j_purchaseorder, 
JSON_TABLE( po_document, '$.ShippingInstructions' 
    COLUMNS   (phones json  PATH '$.Phone')
    ) AS jt;
    
SELECT jt.* FROM j_purchaseorder,
JSON_TABLE(po_document, '$.ShippingInstructions.Phone[*]'
COLUMNS (id FOR ORDINALITY,
         phone_type VARCHAR(10) PATH '$.type',
         phone_num VARCHAR(20) PATH '$.number'))
AS jt order by 1;

SELECT requestor, has_zip 
FROM j_purchaseorder, 
JSON_TABLE(po_document, '$' 
COLUMNS 
  (requestor VARCHAR(32) PATH '$.Requestor', 
   has_zip VARCHAR(5) EXISTS PATH '$.ShippingInstructions.Address.zipCode')) 
AS jt;

SELECT requestor 
FROM j_purchaseorder, 
JSON_TABLE(po_document, '$' 
COLUMNS 
  (requestor VARCHAR(32) PATH '$.Requestor', 
   has_zip INT EXISTS PATH '$.ShippingInstructions.Address.zipCode')) AS jt 
WHERE has_zip = 1 ;

SELECT * 
FROM JSON_TABLE('[1,2,["a","b"]]', '$' 
COLUMNS (outer_value_0 INT PATH '$[0]', 
         outer_value_1 INT PATH '$[1]', 
		 outer_value_2 VARCHAR(20) PATH '$[2]')) AS jt ;
		 
SELECT * 
FROM JSON_TABLE('[1,2,["a","b"]]', '$' 
COLUMNS (outer_value_0 INT PATH '$[0]', 
         outer_value_1 INT PATH '$[1]', 
         NESTED PATH '$[2]' 
         COLUMNS (nested_value_0 VARCHAR(1) PATH '$[0]', 
                  nested_value_1 VARCHAR(1) PATH '$[1]'))) as jt; 
				  
SELECT * 
FROM JSON_TABLE('{"a":100, "b":200, "c":{"d":300, "e":400}}', '$' 
COLUMNS (outer_value_0 INT PATH '$.a', 
         outer_value_1 INT PATH '$.b', 
         NESTED PATH '$.c' 
         COLUMNS (nested_value_0 INT PATH '$.d', 
                  nested_value_1 INT PATH '$.e')))
as jt; 

SELECT jt.* 
FROM j_purchaseorder, 
JSON_TABLE(po_document, '$' 
COLUMNS 
  (requestor VARCHAR(32) PATH '$.Requestor', 
   NESTED PATH '$.ShippingInstructions.Phone[*]' 
     COLUMNS (phone_type VARCHAR(32) PATH '$.type', 
              phone_num VARCHAR(20) PATH '$.number'))) 
AS jt order by 1,2 desc;
 

-- CBRD-22414
select id,name, json_pretty(po_document) from j_purchaseorder;
select json_pretty(
    json_extract( json_extract(po_document, '$.ShippingInstructions'), '$.Phone')
) from j_purchaseorder; 

drop table if exists j_purchaseorder;

