drop table if exists t6;
create table t6(name json);
insert into t6 select json_object('name', 'stuff', 'value', 'third option');
insert into t6 select json_object('name', 'stuff', 'value', 'awesome stuff');
insert into t6 select json_object('name', 'stuff', 'value', 'way cooler stuff');

drop view if exists v1;
drop view if exists v2;
drop view if exists v3;
create view v3 as (select json_extract(name, '') from t6);
create view v2 as (select json_extract('{"a":"b"}', '') from t6);  
create view v1 as (select json_extract(name, '') as c from t6);

select * from t6;
select * from v1;
select * from v2;
select * from v3;

drop table if exists voucher;
CREATE TABLE `voucher` (
`id` varchar(32) NOT NULL COMMENT 'ID',
`vals` string NOT NULL,
 PRIMARY KEY (`id`));
INSERT INTO `voucher` VALUES ('1', '{\"period\":90,\"amount\":5.45}');
INSERT INTO `voucher` VALUES ('2', '{\"period\":90,\"amount\":3.99}');
--issue block CBRD-21701
--create table t9 as (select replace(vals, '\'), json_object('a', 2, 'c', 2), json_extract('{
--  "firstName": "John",
--  "lastName" : "doe",
--  "age"      : 26,
--  "address"  : {
--    "streetAddress": "naist street",
--    "city"         : "Nara",
--    "postalCode"   : "630-0192"
--  },
--  "phoneNumbers": [
--    {
--      "type"  : "iPhone",
--      "number": "0123-4567-8888"
--    },
--    {
--      "type"  : "home",
--      "number": "0123-4567-8910"
--    }
--  ]
--}','') from voucher);
--show create table t9;
drop view if exists v4;
create view v4 as (select json_extract(vals, '/period') as json_col from voucher); 
select * from v4;
drop view if exists v5;
create view v5 as (select json_extract(json_array(vals), '/period') as json_col from voucher);
select * from v5;
drop table if exists t5;
create table t5(id int primary key auto_increment, name json default '[{
    "SalesOrderNumber": "SO43659",
    "OrderDate": "2011-05-31T00:00:00",
    "D": [{
        "UnitPrice": 24.99,
        "OrderQty": 1
    }]
}, {
    "SalesOrderNumber": "SO43659",
    "D": [{
        "UnitPrice": 34.40
    }, {
        "UnitPrice": 134.24,
        "OrderQty": 5
    }]
}]');

create table t5(id int primary key auto_increment, name json default '[{
    "SalesOrderNumber": "SO43659",
    "OrderDate": "2011-05-31T00:00:00",
    "D": [{
        "UnitPrice": 24.99,
        "OrderQty": 1
    }]
}, {
    "SalesOrderNumber": "SO43659",
    "D": [{
        "UnitPrice": 34.40
    }, {
        "UnitPrice": 134.24,
        "OrderQty": 5
    }]
}]');
show create table t5;
insert into t5(id) values (1),(2),(4);
drop view if exists v_t5;
create view v_t5 as select * from t5;
select * from v_t5 order by name;
drop view if exists v_nest_v1;
create view v_nest_v1 as select '[{
    "name": "John"
}, {
    "name": "Jane",
    "surname": "Doe"
}]' as c;
select * from v_nest_v1;
drop view if exists v_nest_v2;
create view v_nest_v2 as select json_extract(json_extract(c, '/1'), '/surname') as b from v_nest_v1 where cast(json_extract( json_extract(c, '/0'), '/name') as varchar)='John';
select * from v_nest_v2;
show create view v_nest_v2;

drop view if exists v_nest_v1;
drop view if exists v_nest_v2;
drop table if exists t5;
drop view if exists v5;
drop view if exists v4;
drop view if exists v1;
drop view if exists v2;
drop view if exists v3;
drop table if exists voucher;
drop table if exists t6;

