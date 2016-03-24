--+ holdcas on;
--test length function with operators ||, +, -, *, /
select length('aaa'||'bbb')*20 from db_root;
select length('aaa'||'bbb')/2 from db_root;
select length('aaa'||'bbb')+22 from db_root;
select length('aaa'||'bbb')-3 from db_root order by 1;
set system parameters 'compat_mode=mysql';
select length(concat('aaa','bbb'))*20 from db_root;
select length(concat('aaa','bbb'))/2 from db_root;
select length(concat('aaa','bbb'))+22 from db_root;
select length(concat('aaa','bbb'))-3 from db_root order by 1;
set system parameters 'compat_mode=cubrid';
commit;
--+ holdcas off;
