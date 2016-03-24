--+ holdcas on;
select sqrt(12345678901234512345) from db_root;

SELECT SQRT(-1) FROM db_root;

set system parameters 'compat_mode=mysql';
SELECT SQRT(-1) FROM db_root;
set system parameters 'compat_mode=cubrid';

create table tbl(null_c int);
insert into tbl values (null);
select sqrt(null_c) from db_root;
drop table tbl;
commit;
--+ holdcas off;
