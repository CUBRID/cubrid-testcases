-- set state
--+ holdcas on;

-- create tables
create table ta (id int, v string);
create index ta_id on ta(id);
create index ta_v on ta(v);

create table tb (id int, v string);
create index tb_id on tb(id);

-- populate tables
insert into ta values (1, 'value 1');
insert into ta values (2, 'value 2');
insert into ta values (3, 'value 3');

insert into tb values (1, 'value 1 occ 1');
insert into tb values (1, 'value 1 occ 2');
insert into tb values (1, 'value 1 occ 3');
insert into tb values (2, 'value 2 occ 1');
insert into tb values (2, 'value 2 occ 1');
insert into tb values (1, 'value 3 occ 1');
update statistics on all classes;

-- simple tests
select /*+ recompile */ * from ta where id > 0 using index ta_id keylimit 0, 2 order by ta.id;
select /*+ recompile */ * from ta where id > 0 using index ta_id(+) keylimit 0, 2 order by ta.id;

select /*+ recompile */ * from ta where id > 0 using index ta_id(+), ta_id keylimit 0, 2 order by ta.id;
select /*+ recompile */ * from ta where id > 0 using index ta_id(-), ta_id keylimit 0, 2 order by ta.id;
select /*+ recompile */ * from ta where id > 0 using index ta_id(+), ta_id(+) keylimit 0, 2 order by ta.id;
select /*+ recompile */ * from ta where id > 0 using index ta_id(-), ta_id(+) keylimit 0, 2 order by ta.id;

select /*+ recompile */ * from ta where id > 0 using index ta_id keylimit 0, 2, ta_id(+) order by ta.id;
select /*+ recompile */ * from ta where id > 0 using index ta_id keylimit 0, 2, ta_id(-) order by ta.id;
select /*+ recompile */ * from ta where id > 0 using index ta_id(+) keylimit 0, 2, ta_id(+) order by ta.id;
select /*+ recompile */ * from ta where id > 0 using index ta_id(+) keylimit 0, 2, ta_id(-) order by ta.id;

select /*+ recompile */ * from ta where id > 0 using index ta_id, ta_id keylimit 0, 2, ta_id order by ta.id;
select /*+ recompile */ * from ta where id > 0 using index ta_id, ta_id(+) keylimit 0, 2, ta_id order by ta.id;

select /*+ recompile */ * from ta where id > 0 using index ta_id(+), ta_id keylimit 0, 2, ta_id(+) order by ta.id;
select /*+ recompile */ * from ta where id > 0 using index ta_id(-), ta_id keylimit 0, 2, ta_id(-) order by ta.id;
select /*+ recompile */ * from ta where id > 0 using index ta_id(+), ta_id(+) keylimit 0, 2, ta_id(+) order by ta.id;
select /*+ recompile */ * from ta where id > 0 using index ta_id(-), ta_id(+) keylimit 0, 2, ta_id(-) order by ta.id;

-- join tests
select /*+ recompile ORDERED */ * from tb inner join ta on ta.id = tb.id where ta.id > 0 and tb.id > 0 using index tb_id(+) keylimit 0, 2 order by ta.id;
select /*+ recompile ORDERED */ * from tb inner join ta on ta.id = tb.id where ta.id > 0 and tb.id > 0 using index tb_id, tb_id(+) keylimit 0, 2 order by ta.id;
select /*+ recompile ORDERED */ * from tb inner join ta on ta.id = tb.id where ta.id > 0 and tb.id > 0 using index tb_id(+), tb_id(+) keylimit 0, 2 order by ta.id;
select /*+ recompile ORDERED */ * from tb inner join ta on ta.id = tb.id where ta.id > 0 and tb.id > 0 using index tb_id(-), tb_id(+) keylimit 0, 2 order by ta.id;
select /*+ recompile ORDERED */ * from tb inner join ta on ta.id = tb.id where ta.id > 0 and tb.id > 0 using index tb_id(+) keylimit 0, 2, tb_id order by ta.id;
select /*+ recompile ORDERED */ * from tb inner join ta on ta.id = tb.id where ta.id > 0 and tb.id > 0 using index tb_id(+) keylimit 0, 2, tb_id(+) order by ta.id;
select /*+ recompile ORDERED */ * from tb inner join ta on ta.id = tb.id where ta.id > 0 and tb.id > 0 using index tb_id(+) keylimit 0, 2, tb_id(-) order by ta.id;
select /*+ recompile ORDERED */ * from tb inner join ta on ta.id = tb.id where ta.id > 0 and tb.id > 0 using index tb_id, tb_id(+) keylimit 0, 2, tb_id order by ta.id;
select /*+ recompile ORDERED */ * from tb inner join ta on ta.id = tb.id where ta.id > 0 and tb.id > 0 using index tb_id(-), tb_id(+) keylimit 0, 2, tb_id(+) order by ta.id;
select /*+ recompile ORDERED */ * from tb inner join ta on ta.id = tb.id where ta.id > 0 and tb.id > 0 using index tb_id(+), tb_id(+) keylimit 0, 2, tb_id(-) order by ta.id;

-- subselect test
select /*+ recompile */ * from (select * from ta where id > 0 using index ta_id(-), ta_id, ta_id(+) keylimit 0, 2, ta_id(+)) x order by x.id;

-- stress test
select /*+ recompile */ * from ta where id > 0 using index ta_id, ta_id(+), ta_id(-), ta_id keylimit 0, 2, ta_id, ta_id(+), ta_id(-) order by ta.id;

-- USE/USING INDEX syntax
select /*+ recompile */ * from ta use index (ta_id) where id > 0 using index ta_id(+) keylimit 0, 2 order by ta.id;
select /*+ recompile */ * from ta force index (ta_id) where id > 0 using index ta_id(+) keylimit 0, 2 order by ta.id;
select /*+ recompile */ * from ta ignore index (ta_id) where id > 0 using index ta_id(+) keylimit 0, 2 order by ta.id;

-- cleanup
drop table ta;
drop table tb;

-- restore state
--+ holdcas off;
commit;
