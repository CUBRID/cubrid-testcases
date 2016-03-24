--+ holdcas on;
--test CHAR_LENGTH with operators ||, +
select char_length('ch'||'nch') from db_root;
set system parameters 'compat_mode=mysql';
select char_length(concat('ch','nch')) from db_root;
set system parameters 'compat_mode=cubrid';
select char_length('ch'+'nch') from db_root order by 1;
commit;
--+ holdcas off;
