--+ holdcas on;

set system parameters 'compat_mode=mysql';

set system parameters 'add_column_update_hard_default=yes';

create table t1 (a int);

insert into t1 values (1),(2);

alter table t1 add column b int not null;

select * from t1 order by a asc;

drop table t1;

set system parameters 'compat_mode=cubrid';

commit;

--+ holdcas off;

set system parameters 'add_column_update_hard_default=no';

