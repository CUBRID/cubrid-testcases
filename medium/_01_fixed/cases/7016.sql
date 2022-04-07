autocommit off;
create class c7016(n char(5), me c7016);
create class c7016_a under c7016(a int);
create class c7016_b under c7016_a(b real);
create vclass c7016_bv as select * from c7016_b;
insert into c7016(n) values('adam') to :a;
insert into c7016_a(n, a) values('a1', 1) to :a1;
insert into c7016_b(n, a, b) values('a2', 2, 2) to :a2;
update object :a set me = :a2;
select z.me{b}.n from c7016 z, c7016_b b order by 1;
select z.me{b}.n from c7016 z, c7016_bv b order by 1;
select name, room{suite_only}.size_in_sq_ft
from public.hotel, public.suite suite_only, table(rooms) as t(room) order by 1,2;
select name, room{all_quarters}.size_in_sq_ft
from public.hotel, all public.quarters all_quarters, table(rooms) as t(room) order by 1,2;
select name, room{all_quarters}.size_in_sq_ft
from public.hotel, public.quarters all_quarters, table(rooms) as t(room) order by 1,2;
rollback;
