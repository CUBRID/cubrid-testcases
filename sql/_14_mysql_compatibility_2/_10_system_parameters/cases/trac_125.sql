--+ holdcas on;
set system parameters 'compat_mode=mysql';
select '\\' from db_root;
create view v as select '\\' a from db_root;
select * from v;
drop view v;
set system parameters 'compat_mode=cubrid';
commit;
--+ holdcas off;
