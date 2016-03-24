--+ holdcas on;
set system parameters 'compat_mode=mysql';
select acos(-1) from db_root;
select acos(acos(1)) from db_root;
select acos(acos(0) - field(acos(1),1,0,2,3)) from db_root;
set system parameters 'compat_mode=cubrid';commit;
--+ holdcas off;
