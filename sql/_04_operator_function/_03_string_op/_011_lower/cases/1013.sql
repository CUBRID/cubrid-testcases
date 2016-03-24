--+ holdcas on;
--test lower function with operators ||, +
select lower('A'||'B'+'C') from db_root order by 1;
set system parameters 'compat_mode=mysql';
select lower(concat('A','B')+'C') from db_root order by 1;
set system parameters 'compat_mode=cubrid';
commit;
--+ holdcas off;
