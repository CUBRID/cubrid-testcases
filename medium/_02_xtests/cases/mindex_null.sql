autocommit off;
--set optimization: level 257;
create table nulltest (i int, j int)
method class set_cost(string, string) function qo_set_cost;
create index i_nulltest_i_j on nulltest(i, j);
insert into nulltest values(1, 1);
insert into nulltest values(2, 2);
insert into nulltest values(0, NULL);
insert into nulltest values(NULL, 0);
call set_cost('iscan', '0') on class nulltest;
select * from nulltest a, nulltest b where a.i = b.i order by a.i, a.j;
select * from nulltest a, nulltest b where a.i = b.i and a.j=b.j order by a.i,
a.j;
select * from nulltest where i < 1 order by i;
select * from nulltest where i = 0 order by i;
rollback;
