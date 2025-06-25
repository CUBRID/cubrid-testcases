-- This scenario varifies CBRD-26120 issue.
-- When querying system catalog classes, check if the case-sensitive behavior has been resolved.

drop table if exists tbl;
create table tbl(col int);

evaluate 'upper case';
select 'DB_ATTRIBUTE' from DB_ATTRIBUTE limit 1;
select 'DB_CLASS' from DB_CLASS limit 1;
select '_DB_ATTRIBUTE' from _DB_ATTRIBUTE limit 1;
select '_DB_CLASS' from _DB_CLASS limit 1;
select 'TBL' from TBL;

evaluate 'lower case';
select 'db_attribute' from db_attribute limit 1;
select 'db_class' from db_class limit 1;
select '_db_attribute' from _db_attribute limit 1;
select '_db_class' from _db_class limit 1;
select 'tbl' from tbl;

evaluate 'mixed case';
select 'db_attrIBute' from db_attrIBute limit 1;
select 'db_Class' from db_Class limit 1;
select '_db_Attribute' from _db_Attribute limit 1;
select '_db_clASs' from _db_clASs limit 1;
select 'tBL' from tBL;

drop table if exists tbl;
