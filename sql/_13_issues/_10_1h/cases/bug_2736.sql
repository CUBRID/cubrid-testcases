--+ holdcas on;
set system parameters 'compat_mode=cubrid';
select 'aaa\
', char_length('aaa\
');
set system parameters 'compat_mode=mysql';
select 'aaa\
', char_length('aaa\
');
set system parameters 'compat_mode=cubrid';
commit;
--+ holdcas off;
