autocommit off;
create class small(id int auto_increment primary key, i int, s char(20), l varchar(255)) ;
create class medium(id int auto_increment primary key, i int, s char(20), l varchar(255));
create class large(id int auto_increment primary key, i int, s char(20), l varchar(255));
insert into small(i, s, l) values (NULL, 'null', '');
insert into small(i, s, l) values (0, 'zero', 'varchar(255)');
insert into small(i, s, l) values (1, 'one', 'varchar(255)');
insert into small(i, s, l) values (2,'two', 'varchar(255)');
insert into small(i, s, l) values (3,'three', 'varchar(255)');
insert into small(i, s, l) values (4,'four', 'varchar(255)');
insert into small(i, s, l) values (5,'five', 'varchar(255)');
insert into small(i, s, l) values (6,'six', 'varchar(255)');
insert into small(i, s, l) values (7,'seven', 'varchar(255)');
insert into small(i, s, l) values (8,'eight', 'varchar(255)');
insert into small(i, s, l) values (9,'nine', 'varchar(255)');
insert into medium(i, s, l) select i, s, l from small order by id;
insert into medium(i, s, l) select i+10, 'one '+s, l from small order by id;
insert into medium(i, s, l) select i+20, 'two '+s, l from small order by id;
insert into medium(i, s, l) select i+30, 'three '+s, l from small order by id;
insert into medium(i, s, l) select i+40, 'four '+s, l from small order by id;
insert into medium(i, s, l) select i+50, 'five '+s, l from small order by id;
insert into medium(i, s, l) select i+60, 'six '+s, l from small order by id;
insert into medium(i, s, l) select i+70, 'seven '+s, l from small order by id;
insert into medium(i, s, l) select i+80, 'eight '+s, l from small order by id;
insert into medium(i, s, l) select i+90, 'nine '+s, l from small order by id;
insert into large(i, s, l) select i, s, l from medium order by id;
insert into large(i, s, l) select i+100, 'one zero '+s, l from medium where i<10 order by id;
insert into large(i, s, l) select i+100, 'one '+s, l from medium where i>=10 order by id;
insert into large(i, s, l) select i+200, 'two zero '+s, l from medium where i<10 order by id;
insert into large(i, s, l) select i+200, 'two '+s, l from medium where i>=10 order by id;
insert into large(i, s, l) select i+300, 'three zero '+s, l from medium where i<10 order by id;
insert into large(i, s, l) select i+300, 'three '+s, l from medium where i>=10 order by id;
insert into large(i, s, l) select i+400, 'four zero '+s, l from medium where i<10 order by id;
insert into large(i, s, l) select i+400, 'four '+s, l from medium where i>=10 order by id;
insert into large(i, s, l) select i+500, 'five zero '+s, l from medium where i<10 order by id;
insert into large(i, s, l) select i+500, 'five '+s, l from medium where i>=10 order by id;
insert into large(i, s, l) select i+600, 'six zero '+s, l from medium where i<10 order by id;
insert into large(i, s, l) select i+600, 'six '+s, l from medium where i>=10 order by id;
insert into large(i, s, l) select i+700, 'seven zero '+s, l from medium where i<10 order by id;
insert into large(i, s, l) select i+700, 'seven '+s, l from medium where i>=10 order by id;
insert into large(i, s, l) select i+800, 'eight zero '+s, l from medium where i<10 order by id;
insert into large(i, s, l) select i+800, 'eight '+s, l from medium where i>=10 order by id;
insert into large(i, s, l) select i+900, 'nine zero '+s, l from medium where i<10 order by id;
insert into large(i, s, l) select i+900, 'nine '+s, l from medium where i>=10 order by id;
-- INST_NUM is evaluated before ORDER BY. Force a stable primary-key scan so heap page placement does not affect it.
select inst_num(), i from small using index pk_small_id(+) order by 1,2;
select inst_num(), i from small where inst_num()<=5 using index pk_small_id(+) order by 1,2;
select inst_num(), i from small where inst_num()>5 using index pk_small_id(+) order by 1,2;
select inst_num(), i from small where inst_num() between 3 and 8 using index pk_small_id(+) order by 1,2;
-- Keep a heap-scan check whose result does not depend on physical row order.
with heap_scan(n) as
(
  select /*+ MATERIALIZE */ inst_num()
  from small using index none
)
select count(*), min(n), max(n) from heap_scan;
select inst_num(), i from small where inst_num()<=5
using index pk_small_id(+)
union select inst_num(), i from small where inst_num()>5 using index pk_small_id(+) order by 1,2;
select inst_num(), i from small where i is not null and (inst_num()<2 or inst_num()>9)
using index pk_small_id(+) order by 1,2;
select inst_num(), i from small where i=1 and (inst_num()<2 or inst_num()>9)
using index pk_small_id(+) order by 1,2;
select inst_num(), i from small where i in (1, 3, 5, 7, 9) and inst_num() in (1, 3, 5, 7, 9)
using index pk_small_id(+) order by 1,2;
select inst_num(), i from small where mod(inst_num(), 2)=1 using index pk_small_id(+) order by 1,2;
select /*+ ORDERED */ inst_num(), small.i, medium.i from small, medium
where small.i=medium.i and (inst_num()<2 or inst_num()>9)
using index small.pk_small_id(+), medium.pk_medium_id(+) order by 1,2;
select /*+ ORDERED */ inst_num(), small.i, medium.i from small, medium
where small.i=medium.i and small.i<10 and (inst_num()<2 or inst_num()>9)
using index small.pk_small_id(+), medium.pk_medium_id(+) order by 1,2;
select /*+ ORDERED */ inst_num(), small.i, medium.i, large.i from small, medium, large
where small.i=medium.i and medium.i=large.i and small.i<10
  and (inst_num()<2 or inst_num()>9)
using index small.pk_small_id(+), medium.pk_medium_id(+), large.pk_large_id(+) order by 1,2;
select inst_num(), i from
  (select i from small where i>5 and inst_num()<5 using index pk_small_id(+)) as t(i)
order by 1,2;
select inst_num(), i from
  (select i from small where i>5 and inst_num()<5 using index pk_small_id(+)) as t(i)
where inst_num()<3 order by 1,2;
select inst_num(), i from (select i
      from small s1
      where i in (select i from small s2 where mod(inst_num(), 2)=1 using index s2.pk_small_id(+))
      using index s1.pk_small_id(+)
      order by 1) S
where (inst_num()<2 or inst_num()>9)  order by 1,2;
select /*+ ORDERED */ inst_num(), small.i, medium.i from small, medium, large
where small.i=medium.i and small.i+medium.i<large.i
  and inst_num()>=10 and inst_num()<=19
using index small.pk_small_id(+), medium.pk_medium_id(+), large.pk_large_id(+) order by 1,2,3;
select inst_num(), i from small
where (i in (1, 3, 5, 7, 9) or i in (2, 4, 6, 8, 10)) and inst_num()<5
using index pk_small_id(+);
select /*+ ORDERED */ inst_num(), small.i, t.i from small,
  (select inst_num() from medium where inst_num()<10 using index pk_medium_id(+)) as t(i)
where small.i=t.i and inst_num()<10
using index small.pk_small_id(+)
order by 1,2, 3 ;
select inst_num(), i from small
where i=(select i from medium where i=small.i and inst_num() = 1 using index pk_medium_id(+))
using index pk_small_id(+) order by 1,2;
select inst_num(), i from small where inst_num()<=5
using index pk_small_id(+)
order by i ;
select inst_num(), i from small where inst_num()<=5 using index pk_small_id(+) order by 1,2;
select inst_num(), i from medium where inst_num()<=10 using index pk_medium_id(+) union
select inst_num(), i from medium where inst_num()>10 and inst_num()<20 using index pk_medium_id(+)
order by 2;
create vclass inst_view as
  (select i, s, l from medium where inst_num()<20 using index pk_medium_id(+));
select * from inst_view order by 1,2;
select * from inst_view where inst_num()<5 order by 1,2;
select * from inst_view where inst_num()>5 order by 1,2;
drop view inst_view;
create vclass inst_view(i, j) as (
	select /*+ ORDERED */ small.i, medium.i
	from small, medium
	where small.i=medium.i and small.i<10
	  and (inst_num()<2 or inst_num()>9)
	using index small.pk_small_id(+), medium.pk_medium_id(+));
select /*+ ORDERED */ inst_num(), small.i, inst_view.i from small, inst_view
where small.i=inst_view.i or small.i=inst_view.j
using index small.pk_small_id(+) order by 1,2;
drop view inst_view;
rollback;
