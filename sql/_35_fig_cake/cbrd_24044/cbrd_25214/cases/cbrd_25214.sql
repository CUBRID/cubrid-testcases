/* Description
This scenario verified CBRD-25214 issue.
Remove join predicate already logically evaluated.
*/

drop table if exists ta;
drop table if exists tb;
drop table if exists tp;
create table ta (cola int, colb int);
create table tb (cola int, colb int);
insert into ta values(1,2);
insert into ta values(2,2);
insert into ta values(3,2);

insert into tb values(1,2);
insert into tb values(2,2);
insert into tb values(3,2);
insert into tb values(4,2);
insert into tb values(5,2);
insert into tb values(6,2);

create index idx_tb on tb(cola,colb);
create index idx_ta on ta(cola,colb);

create table tp(cola int, colb int ) 
partition by range(colb)
(
    partition b_2 values less than (3),
    partition b_3 values less than (4) 
);

insert into tp values(1,2),(2,2),(3,2),(1,3),(2,3),(3,3),(4,3);
create index idx_tp on tp(cola,colb);

update statistics on ta, tb, tp;

set trace on;
select 'remove b.cola = c.cola -1';
select /*+ recompile */ * from ta a, ta b, tb c
where a.cola = b.cola
   and a.cola = c.cola
   and b.cola = c.cola;
show trace;

select 'remove b.cola = c.cola -2';
select /*+ recompile Ordered */ * from ta a, tb c, ta b
where a.cola = c.cola
   and a.cola = b.cola
   and b.cola = c.cola; 
show trace;

select 'remove a.cola = c.cola -3';
select /*+ recompile */ * from ta a, ta b, tb c
where a.cola = b.cola
   and b.cola = c.cola
   and a.cola = c.cola; 
show trace;

select 'remove b.colb = c.colb -4';
select /*+ recompile */ * from ta a, ta b, tb c
where a.cola = b.cola
   and b.cola = c.cola
   and a.colb = c.colb
   and b.colb = c.colb; 
show trace;

select 'remove b.cola = c.cola -5';
select /*+ recompile */ * from ta a, ta b, tb c
where a.cola = b.cola
   and b.colb = c.colb
   and a.cola = c.cola
   and b.cola = c.cola; 
show trace;

select 'remove b.cola = c.cola -6';
select /*+ recompile */ * from ta a, ta b, tb c
where a.cola = b.cola
   and a.colb = c.colb
   and a.cola = c.cola
   and b.cola = c.cola; 
show trace;

select 'remove a.cola = b.colb -7';
select /*+ recompile */ * from ta a, ta b
where a.cola = b.cola
   and a.colb = b.colb
   and a.colb = b.cola
   and a.cola = b.colb; 
show trace;

select 'remove a.colb = b.cola -8';
select /*+ recompile */ * from ta a, ta b
where a.cola = b.cola
   and a.colb = b.colb
   and a.cola = b.colb
   and a.colb = b.cola;
show trace;

select 'remove b.cola = c.cola, e.cola = f.cola, e.cola = b.cola -9';
select /*+ recompile Ordered */ * from ta a, ta b, tb c, tb d, tb e, tb f
where a.cola = b.cola
   and a.cola = c.cola
   and b.cola = c.cola
   and b.cola = f.cola
   and c.cola = d.cola
   and d.cola = e.cola
   and e.cola = f.cola
   and e.cola = b.cola; 
show trace;

select 'remove outer join and a.cola = c.cola -10';
select /*+ recompile */ * from ta a, ta b, tb c
where a.cola = b.cola(+)
   and a.cola = c.cola(+)
   and b.cola = c.cola;
show trace;

select /*+ recompile */ * from ta a left outer join ta b on a.cola = b.cola 
left outer join tb c on b.cola = c.cola 
where b.cola = c.cola;
show trace;

select 'remove outer join and b.cola = c.cola -11';
select /*+ recompile */ * from ta a, ta b, tb c
where a.cola = b.cola(+)
   and b.cola = c.cola(+)
   and a.cola = c.cola;
show trace;

select /*+ recompile */ * from ta a left outer join ta b on a.cola = b.cola
left outer join tb c on b.cola = c.cola
where a.cola = c.cola;
show trace;

select 'remove a.cola = c.cola -12';
select /*+ recompile */ * from ta a, ta b, tb c
where a.cola = b.cola(+)
   and a.cola = c.cola(+)
   and b.cola = c.cola(+);
show trace;

select /*+ recompile */ * from ta a left outer join ta b on a.cola = b.cola
left outer join tb c on a.cola = c.cola and b.cola = c.cola;
show trace;

select 'remove b.cola = c.cola -13';
select /*+ recompile */ * from ta a, ta b, tb c
where a.cola = b.cola(+)
   and b.cola = c.cola(+)
   and a.cola = c.cola(+);
show trace;

select /*+ recompile */ * from ta a left outer join ta b on a.cola = b.cola
left outer join tb c on b.cola = c.cola and a.cola = c.cola;
show trace;

select 'remove b.cola = c.cola -14';
select /*+ recompile */ * from ta a, ta b, tb c
where a.cola = b.cola(+)
   and b.colb = c.colb(+)
   and a.cola = c.cola(+)
   and b.cola = c.cola(+); 
show trace;

select /*+ recompile */ * from ta a left outer join ta b on a.cola = b.cola
left outer join tb c on b.colb = c.colb and a.cola = c.cola and b.cola = c.cola;
show trace;

select 'remove b.cola = c.cola -15';
select /*+ recompile */ * from ta a, ta b, tb c
where a.cola = b.cola(+)
   and a.colb = c.colb(+)
   and a.cola = c.cola(+)
   and b.cola = c.cola(+); 
show trace;

select /*+ recompile */ * from ta a left outer join ta b on a.cola = b.cola
left outer join tb c on a.colb = c.colb and a.cola = c.cola and b.cola = c.cola;
show trace;

select 'remove b.cola = c.cola -16';
select /*+ recompile */ * from (select * from ta) a, (select * from ta) b, (select * from tb) c
where a.cola = b.cola
   and a.cola = c.cola
   and b.cola = c.cola; 
show trace;

select 'change a.colb = b.cola to a.cola = b.cola,a.colb = c.cola to a.cola = c.cola,remove b.cola = c.cola -17';
select /*+ recompile */ * from 
(select cola as colb, colb as cola from ta) a, 
(select * from ta) b, 
(select * from tb) c
where a.colb = b.cola
   and a.colb = c.cola
   and b.cola = c.cola;
show trace;

select 'change a.cola = b.cola to b.cola = 1, a.cola = c.cola to c.cola = 1, b, c cross join, a cross join, remove b.cola = c.cola -18';
select /*+ recompile */ * from 
(select 1 as cola, colb from ta) a, 
(select * from ta) b, 
(select * from tb) c
where a.cola = b.cola
   and a.cola = c.cola
   and b.cola = c.cola; 
show trace;

select 'remove b.cola = c.cola -19';
select /*+ recompile */ * from tp__p__b_2 a, tp__p__b_2 b, tp__p__b_3 c 
where a.cola = b.cola
   and a.cola = c.cola
   and b.cola = c.cola; 
show trace;


select 'Join conditions are not removed. -1';
select /*+ recompile */ * from ta a, ta b, tb c
where a.cola = b.cola
   and b.colb = c.colb
   and a.cola = c.cola;
show trace;

select 'Join conditions are not removed. -2';
select /*+ recompile */ * from ta a, ta b, tb c
where a.cola = b.cola
   and a.colb = c.colb
   and a.cola = c.cola;
show trace;

select 'Join conditions are not removed. remove outer join -3';
select /*+ recompile */ * from ta a, ta b, tb c
where a.cola = b.cola(+)
   and b.cola = c.cola(+)
   and a.colb = c.colb;
show trace;

select /*+ recompile */ * from ta a left outer join ta b on a.cola = b.cola
left outer join tb c on b.cola = c.cola 
where a.colb = c.colb;
show trace;

select 'Join conditions are not removed. -4';
select /*+ recompile */ * from ta a, ta b, tb c
where a.cola = b.cola(+)
   and b.cola = c.cola(+)
   and a.colb = c.colb(+);
show trace;

select /*+ recompile */ * from ta a left outer join ta b on a.cola = b.cola
left outer join tb c on b.cola = c.cola and a.colb = c.colb;
show trace;

select 'Join conditions are not removed. -5';
select /*+ recompile */ * from tp__p__b_2 a, tp__p__b_2 b, tp__p__b_3 c 
where a.cola = b.cola
   and a.cola = c.cola
   and b.colb = c.colb;
show trace;


drop table ta;
drop table tb;
drop table tp;
