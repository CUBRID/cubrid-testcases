set system parameters 'create_table_reuseoid=no';
--+ holdcas on;
drop table if exists tbl;
create table tbl (id int) partition by range (id + 1) (partition p0 values less than (2), partition p1 values less than MAXVALUE);
insert into tbl values (22);
select tbl into :x from tbl;
update object :x set id = 44;
select * from tbl;
drop tbl;
commit;

--+ holdcas off;

set system parameters 'create_table_reuseoid=yes';
