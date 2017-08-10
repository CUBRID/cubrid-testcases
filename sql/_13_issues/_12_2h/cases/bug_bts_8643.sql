create table s1 (a int, b varchar(100));
create table s2 (a int, b varchar(100));

insert into s1 values (1, 'a');
insert into s1 values (2, 'b');

insert into s2 values (1, 'a');
insert into s2 values (2, 'b');
select /* +recompile */ * from
(select b from s1) t1,
(select b from s2) t2
where t1.b=t2.b;

select /*+recompile */ * from
(select b from s1) t1,
(select b from s2) t2
where t2.b=cast (t1.b as varchar(50));

drop table s1,s2;

