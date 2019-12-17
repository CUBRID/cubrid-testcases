
--CBRD-22417, CBRD-22434
select jt.* from json_table( '{"date":""}', '$' columns ( "date" datetime path '$.date' ) ) as jt;  
select jt.* from json_table( '{"date":""}', '$' columns ( "date" date path '$.date' ) ) as jt;  
select jt.* from json_table( '{"date":""}', '$' columns ( "date" varchar(20) path '$.date' ) ) as jt;


drop table if exists tbl1, tbl2, tbl3;

create table tbl1 ( id int , jdoc json);
insert into tbl1 values ( 111, '{ 
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
    }'
);
select jt.phones from tbl1, json_table( jdoc, '$.Phone[*]' columns ( phones json  PATH '$.type' ) ) AS jt order by 1 desc;
select jt.phones from tbl1, json_table( jdoc, '$' columns ( phones json  PATH '$.Phone' ) ) AS jt ;

CREATE TABLE tbl2 (i int, j json);
insert into tbl2 values (222, '{"a":"b"}');
select tbl1.id, tbl2.*, jt.*,  jt2.* 
from tbl1, tbl2, 
JSON_TABLE( j, '$'  COLUMNS( 
    id1 FOR ORDINALITY,
	name json PATH '$.a')
) as jt, 
JSON_TABLE( jdoc, '$.Phone[*]'
    COLUMNS (id2 FOR ORDINALITY,
         phone_type VARCHAR(10) PATH '$.type',
         phone_num VARCHAR(20) PATH '$.number'))
AS jt2 order by id2;

-- CBRD-22417 
SELECT *
FROM JSON_TABLE(
    '[{"AddressType":1, "AdrressCode":"Code 1", "AdreessDetail":"aaaa", "AddressZipCode":"100010"},
    {"AddressType":2, "AdrressCode":"Code 2", "AdreessDetail":"bbbb", "AddressZipCode":"200020"},
    {"AddressType":5, "AdrressCode":"Code 1", "AdreessDetail":"xxxx", "AddressZipCode":"500050"}]',
 '$[*]' COLUMNS(
 rowid FOR ORDINALITY,
 AddressType INT PATH '$.AddressType' DEFAULT '111' ON EMPTY DEFAULT '999' ON ERROR,
 AdrressCode VARCHAR(50) PATH '$.AdrressCode' DEFAULT 'Code XXX' ON EMPTY DEFAULT 'Code 999' ON ERROR,
 AdreessDetail VARCHAR(100) PATH '$.AdreessDetail',
 AddressZipCode CHAR(6) PATH '$.AddressZipCode'
)) AS Address order by rowid;

SELECT *
FROM JSON_TABLE(
    '[{"AddressType":1, "AdrressCode":"Code 1", "AdreessDetail":"aaaa", "AddressZipCode":"100010"},
    {"AddressType":2, "AdrressCode":"Code 2", "AdreessDetail":"bbbb", "AddressZipCode":"200020"},
    {"AddressType":5, "AdrressCode":"Code 1", "AdreessDetail":"xxxx", "AddressZipCode":"500050"}]',
 '$[*]' COLUMNS(
 rowid FOR ORDINALITY,
 AddressType INT PATH '$.AddressType' DEFAULT '111' ON EMPTY DEFAULT '999' ON ERROR,
 AdrressCode VARCHAR(50) PATH '$.AdrressCode' DEFAULT 'Code XXX' ON EMPTY DEFAULT 'Code 999' ON ERROR,
 AdreessDetail VARCHAR(100) PATH '$.AdreessDetail',
 AddressZipCode CHAR(6) PATH '$.AddressZipCode'
)) AS Address
union all
SELECT *
FROM JSON_TABLE(
    '[{"AddressType":1, "AdrressCode":"Code 1", "AdreessDetail":"aaaa", "AddressZipCode":"100010"},
    {"AddressType":2, "AdrressCode":"Code 2", "AdreessDetail":"bbbb", "AddressZipCode":"200020"},
    {"AddressType":5, "AdrressCode":"Code 1", "AdreessDetail":"xxxx", "AddressZipCode":"500050"}]',
 '$[*]' COLUMNS(
 rowid FOR ORDINALITY,
 AddressType INT PATH '$.AddressType' DEFAULT '111' ON EMPTY DEFAULT '999' ON ERROR,
 AdrressCode VARCHAR(50) PATH '$.AdrressCode' DEFAULT 'Code XXX' ON EMPTY DEFAULT 'Code 999' ON ERROR,
 AdreessDetail VARCHAR(100) PATH '$.AdreessDetail',
 AddressZipCode CHAR(6) PATH '$.AddressZipCode'
)) AS Address order by rowid;

create table tbl3 as
SELECT Address.* FROM JSON_TABLE(
    '[{"AddressType":1, "AdrressCode":"Code 1", "AdreessDetail":"aaaa", "AddressZipCode":"100010"},
    {"AddressType":2, "AdrressCode":"Code 2", "AdreessDetail":"bbbb", "AddressZipCode":"200020"},
    {"AddressType":5, "AdrressCode":"Code 1", "AdreessDetail":"xxxx", "AddressZipCode":"500050"}]',
 '$[*]' COLUMNS(
 rowid FOR ORDINALITY,
 AddressType INT PATH '$.AddressType' DEFAULT '111' ON EMPTY DEFAULT '999' ON ERROR,
 AdrressCode VARCHAR(50) PATH '$.AdrressCode' DEFAULT 'Code XXX' ON EMPTY DEFAULT 'Code 999' ON ERROR,
 AdreessDetail VARCHAR(100) PATH '$.AdreessDetail',
 AddressZipCode CHAR(6) PATH '$.AddressZipCode'
)) AS Address;


select * from tbl1 order by 1;
select * from tbl2 order by 1;
select * from tbl3 order by rowid;


drop table if exists tbl1, tbl2, tbl3;

