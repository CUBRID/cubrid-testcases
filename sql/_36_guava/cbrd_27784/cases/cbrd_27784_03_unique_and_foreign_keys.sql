-- CBRD-27784: unique indexes, primary keys and foreign keys built from runs the merge sorter splits into buckets
--
-- The loader finds a duplicate key as two equal keys next to each other in the sorted stream, and a foreign key is
-- checked against the index the build sorted. Each constraint is built on one table with index_sort_method=compare,
-- with index_build_buffer_size 64K (never split) and with 8M (two runs of 4MB or more, each split), and both builds
-- must end the same way: the same error where a key repeats or has no parent, and otherwise an index that reads
-- back with the same ids in the same positions as the 64K build (0 rows differ) and finds every row.
--
-- Rows: 60000, inserted in id order. Each key ends in or is a CHAR(200), so a sort record takes about 230 bytes. The
-- heap stays under the page threshold of a parallel build.
--
-- Covers:
--   - UNIQUE (k, w) and PRIMARY KEY (k, w) over distinct keys
--   - the same over a key repeated by the first row and a row near the middle, which the 8M build sorts in one run,
--     and by the first row and the last, which it sorts in two
--   - FOREIGN KEY f, a CHAR(200) of 50 values scattered over the rows, to a CHAR(200) primary key: with a row without
--     a parent, and without

drop table if exists tu;
drop table if exists p;
drop table if exists d;

create table tu (id int not null, k int not null, w char(200) not null, f char(200));

insert into tu
  select n, mod (n * 7919, 60013), 'w', lpad (cast (mod (mod (n * 7919, 60013), 50) as varchar), 200, '0')
  from (select rownum as n from db_class a, db_class b, db_class c limit 60000) x
  order by n;

create table p (pk char(200) primary key);
insert into p select distinct f from tu;

-- the 64K build of each index read in index order: the index, the position and the id
create table d (tag varchar(10), r int, id int);

set system parameters 'index_sort_method=compare';

-- distinct keys
set system parameters 'index_build_buffer_size=64K';
create unique index u_kw on tu (k, w);
insert into d select 'u', r, id from (select rownum as r, id from tu where k >= 0 using index u_kw) x;
drop index u_kw on tu;

set system parameters 'index_build_buffer_size=8M';
create unique index u_kw on tu (k, w);
select 'u', count(*) from ((select r, id from d where tag = 'u')
  difference (select rownum, id from tu where k >= 0 using index u_kw)) x;
select count(*) from tu where k >= 0 using index u_kw;
drop index u_kw on tu;

alter table tu add constraint pk_tu primary key (k, w);
select 'pk', count(*) from ((select r, id from d where tag = 'u')
  difference (select rownum, id from tu where k >= 0 using index pk_tu)) x;
select count(*) from tu where k >= 0 using index pk_tu;
alter table tu drop primary key;

-- the key of the first row repeated by the row 30000, then by the row 60000
update tu set k = 7919 where id = 30000;

set system parameters 'index_build_buffer_size=64K';
create unique index u_kw on tu (k, w);
alter table tu add constraint pk_tu primary key (k, w);
set system parameters 'index_build_buffer_size=8M';
create unique index u_kw on tu (k, w);
alter table tu add constraint pk_tu primary key (k, w);

update tu set k = mod (30000 * 7919, 60013) where id = 30000;
update tu set k = 7919 where id = 60000;

set system parameters 'index_build_buffer_size=64K';
create unique index u_kw on tu (k, w);
alter table tu add constraint pk_tu primary key (k, w);
set system parameters 'index_build_buffer_size=8M';
create unique index u_kw on tu (k, w);
alter table tu add constraint pk_tu primary key (k, w);

update tu set k = mod (60000 * 7919, 60013) where id = 60000;

-- a foreign key with a row without a parent
insert into tu values (60001, 60001, 'w', lpad ('99', 200, '0'));

set system parameters 'index_build_buffer_size=64K';
alter table tu add constraint fk_tu foreign key (f) references p (pk);
set system parameters 'index_build_buffer_size=8M';
alter table tu add constraint fk_tu foreign key (f) references p (pk);

-- without it
delete from tu where id = 60001;

set system parameters 'index_build_buffer_size=64K';
alter table tu add constraint fk_tu foreign key (f) references p (pk);
insert into d select 'fk', r, id from (select rownum as r, id from tu where f >= '' using index fk_tu) x;
alter table tu drop foreign key fk_tu;

set system parameters 'index_build_buffer_size=8M';
alter table tu add constraint fk_tu foreign key (f) references p (pk);
select 'fk', count(*) from ((select r, id from d where tag = 'fk')
  difference (select rownum, id from tu where f >= '' using index fk_tu)) x;
select count(*) from tu where f >= '' using index fk_tu;

set system parameters 'index_sort_method=DEFAULT';
set system parameters 'index_build_buffer_size=DEFAULT';

-- the foreign key holds: a row without a parent is refused
insert into tu values (60002, 60002, 'w', lpad ('99', 200, '0'));

-- rows each 64K build found
select tag, count(*) from d group by tag order by 1;

drop table tu;
drop table p;
drop table d;
