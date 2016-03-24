--+ holdcas on;
drop table if exists tbl;
create table tbl (id int) partition by range (id + 1) (partition p0 values less than (2), partition p1 values less than MAXVALUE);
insert into tbl values (-1);
insert into tbl values (3);
insert into tbl values (99) into :xx;
select :xx.id from db_root;
delete from tbl where id = 99;
select :xx.id from db_root;
update object :xx set id = 999;

drop table tbl;

create table tbl (id int) partition by range (id + 1) (partition p0 values less than (2), partition p1 values less than MAXVALUE);
commit;
insert into tbl values (-1);
commit;
insert into tbl values (3);
commit;
insert into tbl values (99) into :xx;
commit;
select :xx.id from db_root;
commit;
select :xx.id from db_root;
commit;
delete from tbl where id = 99;
commit;
select :xx.id from db_root;
commit;
update object :xx set id = 999;
commit;
drop table tbl;

commit;
--+ holdcas off;

