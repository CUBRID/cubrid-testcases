-- CBRD-28246: a LEFT JOIN whose ON compares a ci-collation column with a string constant column
-- of a view or derived table on the NULL-supplying side must compile (it never ended before)

drop table if exists ra, rb;
drop view if exists rv;

create table ra (id int primary key, c1 varchar(8) collate utf8_en_ci, c2 varchar(8));
create table rb (id int, c0 varchar(20));
insert into ra values (1, 'ab', ''), (2, 'x', 'a'), (3, 'AB', 'ab'), (4, '', null);
insert into rb values (1, 'q');
create view rv as select 'ab' x1 from rb;

-- view with a literal constant column
select t1.id, t2.x1 from ra t1 left join rv t2 on t1.c1 = t2.x1 order by 1;
select t1.id, t2.x1 from ra t1 left join rv t2 on t1.c1 = t2.x1 where t1.id > 0 order by 1;

-- derived tables with constant expressions
select t1.id, d.x from ra t1 left join (select trim('') x from rb) d on t1.c1 = d.x order by 1;
select t1.id, d.x from ra t1 left join (select 'a' || '' x from rb) d on t1.c1 = d.x order by 1;
select t1.id, d.x from ra t1 left join (select cast('' as varchar(5)) x from rb) d on t1.c1 = d.x order by 1;
select t1.id, d.x from ra t1 left join (select /*+ NO_MERGE */ trim('') x from rb) d on t1.c1 = d.x order by 1;
select t1.id, d.x from ra t1 left join (select trim('') x from rb) d on t1.c1 = d.x and t1.id = 4 order by 1;

-- right outer joins
select t1.id, d.x from (select trim('') x from rb) d right join ra t1 on t1.c1 = d.x order by 1;
select t1.id, d.x from ra t1 right join (select trim('') x from rb) d on t1.c1 = d.x order by 1;

-- same collation: the constant is still reduced
select t1.id, t2.x1 from ra t1 left join rv t2 on t1.c2 = t2.x1 order by 1;

drop view rv;
drop table ra, rb;
