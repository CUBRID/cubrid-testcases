--+ holdcas on;
set system parameters 'compat_mode=mysql';

create table tbl (c varchar (22) not null);
create index i_tbl_c on tbl (c);
insert tbl values ('%');
insert tbl values ('\\');

--need to compare with mysql's result
select /*+ recompile */ * from tbl where c like '\\%';
select /*+ recompile */ * from tbl where c like '\\%' escape '\\';

drop table tbl;

set system parameters 'compat_mode=cubrid';
commit;
--+ holdcas off;
