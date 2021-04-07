-- tests for CUBRIDSUS-4719
--+ holdcas on;

-- VARCHAR
create table t (a varchar(10));

create index i_t_a on t(a);

insert into t values ('1234567890');

select /*+ recompile */ a from t where a like '1234567890ABCDEF%';

prepare stmt from 'select /*+ recompile */ a from t where a like ?+''%'''
execute stmt using '1234567890ABCDEF';

prepare stmt from 'select /*+ recompile */ a from t where a not like ?+''%'''
execute stmt using '1234567890ABCDEF';

prepare stmt from 'select /*+ recompile */ a from t where a like cast ((?+''%'') as varchar(11))'
execute stmt using '1234567890ABCDEF';

prepare stmt from 'select /*+ recompile */ a from t where a like cast ((?+''%'') as varchar(10))'
execute stmt using '1234567890ABCDEF';

drop t;

-- CHAR
create table t2 (a char(10));

create index i_t2_a on t2(a);

insert into t2 values ('1234567890');

select /*+ recompile */ a from t2 where a like '1234567890ABCDEF%';

prepare stmt from 'select /*+ recompile */ a from t2 where a like ?+''%'''
execute stmt using '1234567890ABCDEF';

prepare stmt from 'select /*+ recompile */ a from t2 where a not like ?+''%'''
execute stmt using '1234567890ABCDEF';

prepare stmt from 'select /*+ recompile */ a from t2 where a like cast ((?+''%'') as char(11))'
execute stmt using '1234567890ABCDEF';

prepare stmt from 'select /*+ recompile */ a from t2 where a like cast ((?+''%'') as char(11))'
execute stmt using '123456789';

prepare stmt from 'select /*+ recompile */ a from t2 where a like cast ((?+''%'') as varchar(11))'
execute stmt using '1234567890ABCDEF';

prepare stmt from 'select /*+ recompile */ a from t2 where a like cast ((?+''%'') as varchar(11))'
execute stmt using '123456789';

drop prepare stmt;
drop t2;

commit;

--+ holdcas off;

