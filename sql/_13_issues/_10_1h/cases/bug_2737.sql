--+ holdcas on;
set system parameters 'compat_mode=mysql';
create table test02(col_char varchar(100), col_nchar nchar varying(100));
select * from test02 where col_nchar like N'%';
drop table test02;
set system parameters 'compat_mode=cubrid';
commit;
--+ holdcas off;
