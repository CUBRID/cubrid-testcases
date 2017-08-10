--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';

create table ai (i integer auto_increment);
insert into ai values(null);
insert into ai select null from ai;
insert into ai select null from ai;
insert into ai select null from ai;
insert into ai select null from ai;
insert into ai select null from ai;
insert into ai select null from ai;

create table t(
	i int,
	e1 enum('a', 'b'),
	e2 enum('Yes', 'No', 'Cancel'),
	e3 enum ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'),
	e4 enum('x', 'y', 'z', 't'));
insert into t select i, ((i % 2) +1), ((i % 3)+1), ((i % 7)+1), ((i % 4) + 1) from ai;
drop table ai;

select * from t order by 1, 2, 3, 4, 5;

create index i_t_e1 on t(e1);
create index i_t_e2 on t(e2);
create index i_t_e3 on t(e3);
create index i_t_e4 on t(e4);
create index i_t_e1_e2_e3_e4 on t(e1, e2, e3, e4);
create index i_t_e2_e3 on t(e2, e3);

describe t;

select /*+ recompile */ * from t where e1 < 2;
select /*+ recompile */ * from t where e2 < 3;
select /*+ recompile */ * from t where e3 > 'Friday';
select /*+ recompile */ * from t where e4 < 5;
select /*+ recompile */ e2, e3 from t order by e2, e3;
select /*+ recompile */ * from t order by e1, e2, e3, e4;

drop table t;
set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
