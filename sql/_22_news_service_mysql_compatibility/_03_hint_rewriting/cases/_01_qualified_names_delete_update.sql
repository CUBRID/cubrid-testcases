--+ holdcas on;

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

-- update tests
update /*+ recompile */ tj a use index (tj_id) inner join tj b use index (tj_id) on a.id = b.id set a.id = b.id;
update /*+ recompile */ tj x use index (tj_id) inner join tk on x.id = tk.id set x.id = tk.id;
update /*+ recompile */ tj   use index (tk_id) inner join tk on tj.id = tk.id set tj.id = tk.id;
update /*+ recompile */ tj x use index (tk_id) inner join tk on x.id = tk.id set x.id = tk.id;

-- delete tests
delete /*+ recompile */ from  a,  b using tj a use index (tj_id) inner join tj b use index (tj_id) on a.id = b.id where a.id > 100;
delete /*+ recompile */ from  x, tk using tj x use index (tj_id) inner join tk on x.id = tk.id where x.id > 100;
delete /*+ recompile */ from tj, tk using tj   use index (tk_id) inner join tk on tj.id = tk.id where tj.id > 100;
delete /*+ recompile */ from  x, tk using tj x use index (tk_id) inner join tk on x.id = tk.id where x.id > 100;

-- drop tables
drop table tj;
drop table tk;

commit;

--+ holdcas off;
