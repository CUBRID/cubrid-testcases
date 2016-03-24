--+ holdcas on;
--test length function with operators ||, +
select length('aaa'||'bbb') from db_root;
set system parameters 'compat_mode=mysql';
select length(concat('aaa','bbb')) from db_root;
set system parameters 'compat_mode=cubrid';
select length('aaa'+'bbb') from db_root;
commit;
--+ holdcas off;
