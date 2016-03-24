--+ holdcas on;

set system parameters 'alter_table_change_type_strict=yes';

create table t1 (i1 int);
insert into t1 values (1),(-2147483648),(2147483647);

--[er]
alter table t1 change i1 s1 char(4);


drop table t1;

set system parameters 'alter_table_change_type_strict=no';

commit;

--+ holdcas off;

