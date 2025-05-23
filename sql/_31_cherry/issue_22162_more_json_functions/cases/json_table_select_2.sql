--+ holdcas on;
drop view if exists jtv;
create view jtv as select jt.* from
json_table( '{"date1":"2018-10-18"}', '$'  columns (
    col1 varchar(50) path '$.date1'
)) as jt;

--CBRD-22436
select * from jtv;
show create view jtv;
drop view if exists jtv;


-- CBRD-22438
set @jdoc='[{"a":1},{"a":2}]';
select * from json_table ( @jdoc, '$[*]' columns ( code int path '$.a' )) as jt;
prepare s from 'select * from json_table ( ? , ''$[*]'' columns ( code int path ''$.a'' )) as jt;';
execute s using @jdoc;
deallocate prepare s;

drop table if exists tbl;
drop view if exists v1;
create table tbl as select * from json_table ( @jdoc, '$[*]' columns ( code int path '$.a' )) as jt;
create view v1 as select * from json_table ( @jdoc, '$[*]' columns ( code int path '$.a' )) as jt;


set @jdoc='[
    {"AddressType":1, "AdrressCode":"Code 1", "AdreessDetail":"aaaa", "AddressZipCode":"100010"},
    {"AddressType":2, "AdrressCode":"Code 2", "AdreessDetail":"bbbb", "AddressZipCode":"200020"},
    {"AddressType":5, "AdrressCode":"Code 1", "AdreessDetail":"xxxx", "AddressZipCode":"500050"}
]';

prepare s from 'select * from json_table ( ? , ''$[*]'' COLUMNS(
    AddressType INT PATH ''$.AddressType'',
    AdrressCode VARCHAR(50) PATH ''$.AdrressCode'')) AS Address;';
execute s using @jdoc;
deallocate prepare s;

drop table if exists t;
create table t as SELECT * FROM JSON_TABLE( @jdoc, '$[*]' COLUMNS(
    rowid FOR ORDINALITY,
    AddressType INT PATH '$.AddressType' DEFAULT '111' ON EMPTY DEFAULT '999' ON ERROR,
    AdrressCode VARCHAR(50) PATH '$.AdrressCode' DEFAULT 'Code XXX' ON EMPTY DEFAULT 'Code 999' ON ERROR,
    AdreessDetail VARCHAR(100) PATH '$.AdreessDetail',
    AddressZipCode CHAR(6) PATH '$.AddressZipCode'
)) AS Address;

--CBRD-23556
create table t as SELECT * FROM JSON_TABLE( @jdoc, '$[*]' COLUMNS(
    rowid FOR ORDINALITY,
    AddressType INT PATH '$.AddressType' DEFAULT '999' ON ERROR DEFAULT '111' ON EMPTY,
    AdrressCode VARCHAR(50) PATH '$.AdrressCode' DEFAULT 'Code 999' ON ERROR DEFAULT 'Code XXX' ON EMPTY,
    AdreessDetail VARCHAR(100) PATH '$.AdreessDetail',
    AddressZipCode CHAR(6) PATH '$.AddressZipCode'
)) AS Address;

SELECT * FROM JSON_TABLE ('{"a":1}', '$' 
COLUMNS ( 
col1 INT PATH '$.a', 
col2 INT PATH '$.b', 
col3 INT PATH '$.c' DEFAULT '0' ON EMPTY DEFAULT '1' ON ERROR)) as jt;

SELECT * FROM JSON_TABLE ('{"a":1}', '$' 
COLUMNS ( 
col1 INT PATH '$.a', 
col2 INT PATH '$.b', 
col3 INT PATH '$.c' DEFAULT '0' ON ERROR DEFAULT '1' ON EMPTY)) as jt;

SELECT * FROM JSON_TABLE ('{"a":1}', '$' 
COLUMNS ( 
col1 INT PATH '$.a', 
col2 INT PATH '$.b', 
col3 INT PATH '$.c' DEFAULT '0' ON EMPTY DEFAULT '1' ON ERROR DEFAULT '2' ON EMPTY)) as jt;

SELECT * FROM JSON_TABLE ('{"a":1}', '$' 
COLUMNS ( 
col1 INT PATH '$.a', 
col2 INT PATH '$.b', 
col3 INT PATH '$.c' DEFAULT '0' ON ERROR DEFAULT '1' ON EMPTY DEFAULT '2' ON ERROR)) as jt;
drop variable @jdoc;
drop table if exists t;


--+ holdcas off;
