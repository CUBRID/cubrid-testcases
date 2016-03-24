--+ holdcas on;
--test upper function with operators ||, +
select upper('a'||'B'+'c') from db_root order by 1;
set system parameters 'compat_mode=mysql';
select upper(concat('a','B')+'c') from db_root order by 1;
set system parameters 'compat_mode=cubrid';
commit;
--+ holdcas off;
