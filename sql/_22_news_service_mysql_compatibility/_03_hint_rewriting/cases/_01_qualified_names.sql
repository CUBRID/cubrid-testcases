--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';

-- create and populate tables
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

-- simple tests
select /*+ recompile ordered */ a.*, b.* from tj a use    index (tj_id) inner join tj b use    index (tj_id) on a.id = b.id order by a.id;
select /*+ recompile ordered */ a.*, b.* from tj a use    index (tj_id) inner join tj b force  index (tj_id) on a.id = b.id order by a.id;
select /*+ recompile ordered */ a.*, b.* from tj a use    index (tj_id) inner join tj b ignore index (tj_id) on a.id = b.id order by a.id;
select /*+ recompile ordered */ a.*, b.* from tj a force  index (tj_id) inner join tj b use    index (tj_id) on a.id = b.id order by a.id;
select /*+ recompile ordered */ a.*, b.* from tj a force  index (tj_id) inner join tj b force  index (tj_id) on a.id = b.id order by a.id;
select /*+ recompile ordered */ a.*, b.* from tj a force  index (tj_id) inner join tj b ignore index (tj_id) on a.id = b.id order by a.id;
select /*+ recompile ordered */ a.*, b.* from tj a ignore index (tj_id) inner join tj b use    index (tj_id) on a.id = b.id order by a.id;
select /*+ recompile ordered */ a.*, b.* from tj a ignore index (tj_id) inner join tj b force  index (tj_id) on a.id = b.id order by a.id;
select /*+ recompile ordered */ a.*, b.* from tj a ignore index (tj_id) inner join tj b ignore index (tj_id) on a.id = b.id order by a.id;

select /*+ recompile ordered */ * from tj x use    index (tj_id) inner join tk on x.id = tk.id order by tk.id;
select /*+ recompile ordered */ * from tj x force  index (tj_id) inner join tk on x.id = tk.id order by tk.id;
select /*+ recompile ordered */ * from tj x ignore index (tj_id) inner join tk on x.id = tk.id order by tk.id;

select /*+ recompile ordered */ * from tj use    index (tk_id) inner join tk on tj.id = tk.id order by tj.id;
select /*+ recompile ordered */ * from tj force  index (tk_id) inner join tk on tj.id = tk.id order by tj.id;
select /*+ recompile ordered */ * from tj ignore index (tk_id) inner join tk on tj.id = tk.id order by tj.id;

select /*+ recompile ordered */ * from tj x use    index (tk_id) inner join tk on x.id = tk.id order by x.id;
select /*+ recompile ordered */ * from tj x force  index (tk_id) inner join tk on x.id = tk.id order by x.id;
select /*+ recompile ordered */ * from tj x ignore index (tk_id) inner join tk on x.id = tk.id order by x.id;

-- subquery tests
select /*+ recompile ordered  */ * from (select /*+ NO_MERGE */ a.val as av, b.val as bv from tj a use index (tj_id) inner join tj b use index (tj_id) on a.id = b.id) sq order by av, bv;
select /*+ recompile ordered */ * from (select /*+ NO_MERGE */ x.id as id, tk.val as val from tj x use index (tj_id) inner join tk on x.id = tk.id) sq order by sq.id;
select /*+ recompile ordered */ * from (select tj.id as id, tk.val as val from tj use index (tk_id) inner join tk on tj.id = tk.id) sq order by sq.id;

-- drop tables
drop table tj;
drop table tk;

commit;

set system parameters 'dont_reuse_heap_file=no';
--+ holdcas off;
