--+ holdcas on;

set system parameters 'dont_reuse_heap_file=yes';

create table t(id int, val int, fk int);
create table u(id int, val int, text string);
create index _t_id on t(id);
create index _t_val on t(val);
create index _u_id on u(id);
create index _u_val on u(val);
create index _u_r_text on u(right(text, 2));

insert into t values (1, 100, 1);
insert into t values (2, 200, 1);
insert into t values (3, 300, 2);
insert into t values (4, 300, 3);

insert into u values (1, 1000, '1000 text');
insert into u values (2, 2000, '2000 text');
insert into u values (3, 3000, '3000 text');
insert into u values (3, 3001, '3001 text');

update statistics on all classes;

--------------------------------
-- SELECT tests
--------------------------------
select /*+ recompile */ * from t where id > 1 using index _t_id;
select /*+ recompile */ * from t use index (_t_id) where id > 1;

select /*+ recompile */ * from t where id > 1 using index _t_val;
select /*+ recompile */ * from t use index (_t_val) where id > 1;

select /*+ recompile */ * from u where id < 100 and right(text, 2) < 'zz' using index _u_id, _u_r_text;
select /*+ recompile */ * from u use index (_u_id, _u_r_text) where id < 100 and right(text, 2) < 'zz';

select /*+ recompile */ * from u where id < 100 and right(text, 2) < 'zz' using index _u_id(+), _u_r_text;
select /*+ recompile */ * from u force index (_u_id) where id < 100 and right(text, 2) < 'zz' using index _u_r_text;

--------------------------------
-- JOIN tests
--------------------------------
select /*+ recompile */ * from t inner join u on t.fk = u.id where t.id < 2 using index _u_id(-);
select /*+ recompile */ * from t inner join u ignore index (_u_id) on t.fk = u.id where t.id < 2;

select /*+ recompile */ * from t inner join u on t.fk = u.id where right(text, 2) < 'zz' using index _u_id(+);
select /*+ recompile */ * from t inner join u force index (_u_id) on t.fk = u.id where right(text, 2) < 'zz';

select /*+ recompile */ * from t inner join u on t.fk = u.id where right(text, 2) < 'zz' and u.id < 100 using index _t_val(+), _u_id;
select /*+ recompile */ * from t force index (_t_val) inner join u use index (_u_id) on t.fk = u.id where right(text, 2) < 'zz' and u.id < 100;

--------------------------------
-- SUBSELECT tests
--------------------------------
select /*+ recompile */ * 
from 
	t inner join 
	(select /*+ NO_MERGE */ * from u where right(text, 2) < 'zz' using index _u_id(+)) x 
		on t.fk = x.id 
where 
	t.id < 100 
using index 
	_t_val(+);
	
select /*+ recompile */ * 
from 
	t force index (_t_val) inner join 
	(select /*+ NO_MERGE */ * from u force index (_u_id) where right(text, 2) < 'zz') x 
		on t.fk = x.id 
where 
	t.id < 100;

drop table t;
drop table u;

set system parameters 'dont_reuse_heap_file=no';

commit;

--+ holdcas off;
