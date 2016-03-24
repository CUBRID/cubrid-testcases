autocommit off;
create class small(i int, s char(20), l varchar(255)) ;
create class medium(i int, s char(20), l varchar(255));
create class large(i int, s char(20), l varchar(255));
insert into small values (NULL, 'null', '');
insert into small values (0, 'zero', 'varchar(255)');
insert into small values (1, 'one', 'varchar(255)');
insert into small values (2,'two', 'varchar(255)');
insert into small values (3,'three', 'varchar(255)');
insert into small values (4,'four', 'varchar(255)');
insert into small values (5,'five', 'varchar(255)');
insert into small values (6,'six', 'varchar(255)');
insert into small values (7,'seven', 'varchar(255)');
insert into small values (8,'eight', 'varchar(255)');
insert into small values (9,'nine', 'varchar(255)');
insert into medium select i, s, l from small;
insert into medium select i+10, 'one '+s, l from small;
insert into medium select i+20, 'two '+s, l from small;
insert into medium select i+30, 'three '+s, l from small;
insert into medium select i+40, 'four '+s, l from small;
insert into medium select i+50, 'five '+s, l from small;
insert into medium select i+60, 'six '+s, l from small;
insert into medium select i+70, 'seven '+s, l from small;
insert into medium select i+80, 'eight '+s, l from small;
insert into medium select i+90, 'nine '+s, l from small;
insert into large select i, s, l from medium;
insert into large select i+100, 'one zero '+s, l from medium where i<10;
insert into large select i+100, 'one '+s, l from medium where i>=10;
insert into large select i+200, 'two zero '+s, l from medium where i<10;
insert into large select i+200, 'two '+s, l from medium where i>=10;
insert into large select i+300, 'three zero '+s, l from medium where i<10;
insert into large select i+300, 'three '+s, l from medium where i>=10;
insert into large select i+400, 'four zero '+s, l from medium where i<10;
insert into large select i+400, 'four '+s, l from medium where i>=10;
insert into large select i+500, 'five zero '+s, l from medium where i<10;
insert into large select i+500, 'five '+s, l from medium where i>=10;
insert into large select i+600, 'six zero '+s, l from medium where i<10;
insert into large select i+600, 'six '+s, l from medium where i>=10;
insert into large select i+700, 'seven zero '+s, l from medium where i<10;
insert into large select i+700, 'seven '+s, l from medium where i>=10;
insert into large select i+800, 'eight zero '+s, l from medium where i<10;
insert into large select i+800, 'eight '+s, l from medium where i>=10;
insert into large select i+900, 'nine zero '+s, l from medium where i<10;
insert into large select i+900, 'nine '+s, l from medium where i>=10;
select inst_num(), i from small order by 1,2;
select inst_num(), i from small where inst_num()<=5 order by 1,2;
select inst_num(), i from small where inst_num()>5 order by 1,2;
select inst_num(), i from small where inst_num() between 3 and 8 order by 1,2;
select inst_num(), i from small where inst_num()<=5
union select inst_num(), i from small where inst_num()>5 order by 1,2;
select inst_num(), i from small where i is not null and (inst_num()<2 or inst_num()>9) order by 1,2;
select inst_num(), i from small where i=1 and (inst_num()<2 or inst_num()>9) order by 1,2;
select inst_num(), i from small where i in (1, 3, 5, 7, 9) and inst_num() in (1, 3, 5, 7, 9) order by 1,2;
select inst_num(), i from small where mod(inst_num(), 2)=1 order by 1,2;
select inst_num(), small.i, medium.i from small, medium where small.i=medium.i and (inst_num()<2 or inst_num()>9) order by 1,2;
select inst_num(), small.i, medium.i from small, medium where small.i=medium.i and small.i<10
  and (inst_num()<2 or inst_num()>9) order by 1,2;
select inst_num(), small.i, medium.i, large.i from small, medium, large
where small.i=medium.i and medium.i=large.i and small.i<10
  and (inst_num()<2 or inst_num()>9) order by 1,2;
select inst_num(), i from (select i from small where i>5 and inst_num()<5) as t(i) order by 1,2;
select inst_num(), i from (select i from small where i>5 and inst_num()<5) as t(i)
where inst_num()<3 order by 1,2;
select inst_num(), i from (select i
      from small
      where i in (select i from small where mod(inst_num(), 2)=1)
      order by 1) S
where (inst_num()<2 or inst_num()>9)  order by 1,2;
select inst_num(), small.i, medium.i from small, medium, large
where small.i=medium.i and small.i+medium.i<large.i
  and inst_num()>=10 and inst_num()<=19 order by 1,2,3;
select inst_num(), i from small
where (i in (1, 3, 5, 7, 9) or i in (2, 4, 6, 8, 10)) and inst_num()<5 ;
select inst_num(), small.i, t.i from small, (select inst_num() from medium where inst_num()<10) as t(i)
where small.i=t.i and inst_num()<10
order by 1,2, 3 ;
select inst_num(), i from small where i=(select i from medium where i=small.i and inst_num() = 1) order by 1,2;
select inst_num(), i from small where inst_num()<=5
order by i ;
select inst_num(), i from small where inst_num()<=5 order by 1,2;
select inst_num(), i from medium where inst_num()<=10 union
select inst_num(), i from medium where inst_num()>10 and inst_num()<20
order by 2;
create vclass inst_view as (select * from medium where inst_num()<20);
select * from inst_view order by 1,2;
select * from inst_view where inst_num()<5 order by 1,2;
select * from inst_view where inst_num()>5 order by 1,2;
drop view inst_view;
create vclass inst_view(i, j) as (
	select small.i, medium.i
	from small, medium
	where small.i=medium.i and small.i<10
	  and (inst_num()<2 or inst_num()>9));
select inst_num(), small.i, inst_view.i from small, inst_view where small.i=inst_view.i or small.i=inst_view.j order by 1,2;
drop view inst_view;
rollback;
