-- This issue verifies CBRD-24897.
-- Query rewriter can lose parent paths of a name in qo_collect_name_spec().
-- Rewritten query should include commented phrase. 

drop table if exists target_info, target_list_info, object_info;

create table object_info (id int, status int, name varchar);
insert into object_info
values (1, 0, 'object_1'), (2, 0, 'object_2'), (3, 0, 'object_3'), (4, 0, 'object_4'), (5, 0, 'object_5');

create table target_info (id int, status int, target object_info);
insert into target_info (id, status)
values (1, 0), (2, 0), (3, 0), (4, 0), (5, 0);
update target_info as t set t.target = (select o from object_info as o where o.id = t.id);

create table target_list_info (id int, status int, target_list set (object_info));
insert into target_list_info (id, status)
values (1, 0);
update target_list_info as t set t.target_list = set (select o from object_info as o);

-- No path expressions
-- expected: o.[name] 
select /*+ recompile */ o.id, o.name from object_info as o where o.name = 'object_1' and o.status = 0;

-- expected: nvl(o.[name], '')
select /*+ recompile */ o.id, o.name from object_info as o where nvl (o.name, '') = 'object_2' and o.status = 0;

-- expected: {o.[name]} 
select /*+ recompile */ o.id, o.name from object_info as o where {o.name} = {'object_3'} and o.status = 0;

-- expected: {o.[name]}
select /*+ recompile */ o.id, o.name from object_info as o where {o.name} subseteq set {'object_4'} and o.status = 0;

-- path expressions
-- expected: t.target.[name]
select /*+ recompile */ t.target.id, t.target.name from target_info as t where t.target.name = 'object_1' and t.status = 0;

-- expected: nvl(t.target.[name], '') - AS-IS: nvl([name], '')
select /*+ recompile */ t.target.id, t.target.name from target_info as t where nvl (t.target.name, '') = 'object_2' and t.status = 0;

-- expected: {t.target.[name]} - AS-IS: {[name]}
select /*+ recompile */ t.target.id, t.target.name from target_info as t where {t.target.name} = {'object_3'} and t.status = 0;

-- expected: {t.target.[name]} - AS-IS: {[name]}
select /*+ recompile */ t.target.id, t.target.name from target_info as t where {t.target.name} subseteq set {'object_4'} and t.status = 0;

-- expected: nvl(l.o.[name], '') - AS-IS: nvl([name], '')
select /*+ recompile */ l.o.id, l.o.name from target_list_info as t, table (t.target_list) as l (o) where nvl (l.o.name, '') = 'object_5' and t.status = 0;


drop table if exists target_info, target_list_info, object_info;

