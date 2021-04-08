--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
create table foo (a int, b int, c int, d int);
create index i_foo_a_b_c_d_d_d on foo (a, b, c desc, d desc);

select c, d
from foo f
where 1=1 and f.a = 1 and f.b = 1
using index i_foo_a_b_c_d_d_d
order by c desc, d desc limit 1;

drop table foo;



create table foo (a int, b int, c int not null, d int not null);
create index i_foo_a_b_c_d_d_d on foo (a, b, c desc, d desc);

select c, d
from foo f
where 1=1 and f.a = 1 and f.b = 1
using index i_foo_a_b_c_d_d_d
order by c desc, d desc limit 1;

drop table foo;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
