--+ holdcas on;
set system parameters 'compat_mode=mysql';

select acos(1) from db_root;

select acos(1.0001) from db_root;

select acos(0) from db_root;

select acos('123') from db_root;

select acos('a') from db_root;

select acos(NULL) from db_root;

select acos(123456789012345.12345) from db_root;

set system parameters 'compat_mode=cubrid';
commit;
--+ holdcas off;
