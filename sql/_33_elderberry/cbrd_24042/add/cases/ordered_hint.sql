-- refer to sql/_22_news_service_mysql_compatibility/_03_hint_rewriting/cases/_01_qualified_names.sql

create table tj (id int, val string);
create table tk (id int, val string);

create index tj_id on tj(id);
create index tk_id on tk(id);

insert into tj values (1, 'value a1');
insert into tj values (2, 'value a2');
insert into tj values (3, 'value a3');
insert into tk values (1, 'value b1');
insert into tk values (2, 'value b2');
insert into tk values (3, 'value b3');
update statistics on all classes;

-- subquery tests
select /*+ recompile ordered  */ * from (select a.val as av, b.val as bv from tj a use index (tj_id) inner join tj b use index (tj_id) on a.id = b.id) sq order by av, bv;
select /*+ recompile ordered */ * from (select x.id as id, tk.val as val from tj x use index (tj_id) inner join tk on x.id = tk.id) sq order by sq.id;

-- drop tables
drop table tj;
drop table tk;

