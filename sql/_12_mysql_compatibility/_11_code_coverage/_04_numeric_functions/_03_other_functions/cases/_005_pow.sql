--+ holdcas on;
SELECT POW(-1,0.5) FROM db_root;

set system parameters 'compat_mode=mysql';
SELECT POW(-1,0.5) FROM db_root;
set system parameters 'compat_mode=cubrid';

create table tbl(null_c int);
insert into tbl values (null);
select pow(null_c, 1) from db_root;
select pow(1, null_c) from db_root;
select pow(null_c, null_c) from db_root;
drop table tbl;
commit;
--+ holdcas off;
