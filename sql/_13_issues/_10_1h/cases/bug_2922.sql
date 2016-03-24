create table tbl (a int);
-- single column
create table tbl1 as select null as a from tbl;
-- multi column
create table tbl1 as select null as a, null as b from tbl;
-- one of multi column
create table tbl1 as select tbl.a, null as b from tbl;
-- when function returns null
create table b as select concat_ws(null, '1') as a from tbl;
drop table tbl;

--------------------------------
create table tbl (a int);
create table tbl1 as select a from tbl;
create table tbl2 as select concat_ws('.', '1') as a from tbl;
-- check table schema
--;sc tbl1
select * from tbl1;
--;sc tbl2
select * from tbl2;
drop table tbl, tbl1, tbl2;

-----------------------------
create table tbl (a int);
-- return error
prepare stmt1 from 'create table tbl1 as select ? as a from tbl'
execute stmt1 using null
DEALLOCATE PREPARE stmt1;
-- success
prepare stmt1 from 'create table tbl1 as select ? as a from tbl'
execute stmt1 using 1
DEALLOCATE PREPARE stmt1;
drop tbl, tbl1;

----------------------
create class poo ( a int);
insert into poo values(null);
create class too as select a from poo;
drop poo, too;


create class poo ( a int);
insert into poo values(1);
create class ooo ( b int);
insert into ooo values(1);
create class too as select a from poo difference select b from ooo;
select * from too;
drop poo, ooo, too;

-------------------------------
-- error
create view v1 (n) as select null from db_root;
create view v1 as select null as n from db_root;

-- success
create view v1 (n int) as select null from db_root;
select * from v1;
drop view v1;

-- error
prepare stmt1 from 'create view v1 (n) as select ? from db_root'
execute stmt1 using 1
DEALLOCATE PREPARE stmt1;

prepare stmt1 from 'create view v1 (n int) as select ? from db_root'
execute stmt1 using 1
DEALLOCATE PREPARE stmt1;

prepare stmt1 from 'create view v1 as select ? as n from db_root'
execute stmt1 using 1
DEALLOCATE PREPARE stmt1;
