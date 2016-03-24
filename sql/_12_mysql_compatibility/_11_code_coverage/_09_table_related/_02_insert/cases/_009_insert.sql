--+ holdcas on;
-- INSERT  ... DEFAULT + mysql mode 

create table t1 (i1 integer default 0);

insert into t1 default;

insert into t1 values default;

insert into t1 values (2),(4),(5);
select * from t1 order by 1;

set system parameters 'compat_mode=mysql';
insert into t1 values();
select * from t1  order by 1;
set system parameters 'compat_mode=cubrid';

-- should fail
insert into t1_1 values default,(1);

drop table t1;


commit;
--+ holdcas off;
