--
create table tb(a int, b date);
insert into tb values (1, date'02/21/2011');
insert into tb values (2, date'02/20/2011');
insert into tb values (3, date'02/19/2011');
insert into tb values (4, date'02/18/2011');
create index idx on tb(a);
create index idx2 on tb(b);

prepare x from 'select * from tb where a in (1, ?) order by a'
execute x using 3
execute x using '2'
execute x using 5
drop prepare x;

select * from tb where b in ('02/20/2011', '02/18/2011', '02/17/2011', date'2010-01-01', cast('2011-02-19' as varchar(255)))  order by a;

$int, $3, $date, $2011-02-19
select * from tb where a in (1, ?) or b in ('02/18/2011', ?)  order by a;
$varchar, $2, $varchar, $2011-02-18
select * from tb where a in (1, ?) or b in ('02/22/2011', ?)  order by a;

prepare x from 'select * from tb where b in (''02/20/2011'', ?) order by a'
execute x using '02/21/2011'
execute x using date'02/19/2011'
drop prepare x;

drop table tb;

create table t (i1 int, i2 int, i3 int);
create index i_t_123 on t(i1, i2, i3);
select /*+ recompile */ * from t where i1=4 and i2 in (i1);

drop table t;