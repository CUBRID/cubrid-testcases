--+ holdcas on;
-- create a table to be used for tests --
create table t(id integer, textlabel varchar(255), description varchar(4096));
insert into t(id, textlabel, description)
    values
	(10, 'aab', 'the textbook'),
	(11, 'xab', 'book descr'),
	(12, 'xxy', 'book chapters'),
	(13, 'xa0', 'author names'),
	(14, 'xa1', 'xa1'),
	(15, 'xab', 'xab'),
	(16, 'aff', 'syntax descr'),
	(17, 'afg', 'operators list');

-- use create table like again, with a populated table --
create index i_t_id on t(id);
create index idx_t_description on t(description) where description = textlabel;
update statistics on t;
show indexes from t;

select /*+ recompile */  * from t where description > '' using index idx_t_description(+);

-- alter table change/modify --
set system parameters 'alter_table_change_type_strict=no';
alter table t change description descr character varying(1024);
set system parameters 'alter_table_change_type_strict=yes';

select /*+ recompile */  * from t where descr > '' using index idx_t_description(+);

-- alter index --
alter index idx_t_description on t rebuild;

drop index idx_t_description on t;

-- try a few particular index predicates --
create index idx_t_description on t(descr);
select /*+ recompile */  * from t where descr > '' using index idx_t_description(+);
drop index idx_t_description on t;

create index idx_t_description on t(descr) where true;
select /*+ recompile */  * from t where descr > '' using index idx_t_description(+) order by id;
select /*+ recompile */  * from t order by id;
drop index idx_t_description on t;

create index idx_t_description on t(descr) where textlabel = lower(descr);
select /*+ recompile */  * from t where descr > '' using index idx_t_description(+) order by id;
select /*+ recompile */  * from t where textlabel = lower(descr) order by id;
drop index idx_t_description on t;

-- usage tests --
-- insert/update/replace/delete/truncate --

create reverse index r_t_textlabel on t(textlabel) where id > 15;

-- insert row oudside the index --
insert into t(id, textlabel, descr) values (9, '00n', 'n-record');
select /*+ recompile */  * from t order by id desc;
select /*+ recompile */  * from t where textlabel > '' using index r_t_textlabel(+) order by id desc;
select /*+ recompile */  * from t where textlabel > '' difference select /*+ recompile */  * from t where textlabel > '' using index r_t_textlabel(+);

-- insert into the index --
insert into t(id, textlabel, descr) values(18, 'xkb', 'x-window system keyboard device');
select /*+ recompile */  * from t order by id desc;
select /*+ recompile */  * from t where textlabel > '' using index r_t_textlabel(+) order by id desc;
select /*+ recompile */  * from t where textlabel > '' difference select /*+ recompile */  * from t where textlabel > '' using index r_t_textlabel(+);

-- update a row to bring it into the index --
update t set id = id + 10 where id < 10;
select /*+ recompile */  * from t order by id desc ;
select /*+ recompile */  * from t where textlabel > '' using index r_t_textlabel(+) order by id desc;
select /*+ recompile */  * from t where textlabel > '' difference select /*+ recompile */  * from t where textlabel > '' using index r_t_textlabel(+);

-- update a row to take it outside the index --
update t set id = id - 10 where id > 17;
select /*+ recompile */  * from t order by id desc;
select /*+ recompile */  * from t where textlabel > '' using index r_t_textlabel(+) order by id desc;
select /*+ recompile */  * from t where textlabel > '' difference select /*+ recompile */  * from t where textlabel > '' using index r_t_textlabel(+);

-- update a row and keep it outside the index --
update t set id = id/2 where id < 10;
select /*+ recompile */  * from t order by id desc,textlabel asc;
select /*+ recompile */  * from t where textlabel > '' using index r_t_textlabel(+) order by id desc;
select /*+ recompile */  * from t where textlabel > '' difference select /*+ recompile */  * from t where textlabel > '' using index r_t_textlabel(+);

-- update a row and keep it in the index --
update t set id = id+4 where id > 5;
select /*+ recompile */  * from t order by id desc,2;
select /*+ recompile */  * from t where textlabel > '' using index r_t_textlabel(+) order by id desc;
select /*+ recompile */  * from t where textlabel > '' difference select /*+ recompile */  * from t where textlabel > '' using index r_t_textlabel(+);

-- replace a row and keep it in the index --
replace into t values (21,'afg','operators list'), (22,'afg','operators list');
select /*+ recompile */  * from t order by id desc,textlabel asc;
select /*+ recompile */  * from t where textlabel > '' using index r_t_textlabel(+) order by id desc;
select /*+ recompile */  * from t where textlabel > '' difference select /*+ recompile */  * from t where textlabel > '' using index r_t_textlabel(+);

-- replace a row to move it outside the index --
replace into t values (22,'afg','operators list'), (3,'afg','operators list');
select /*+ recompile */  * from t order by id desc,textlabel asc;
select /*+ recompile */  * from t where textlabel > '' using index r_t_textlabel(+) order by id desc;
select /*+ recompile */  * from t where textlabel > '' difference select /*+ recompile */  * from t where textlabel > '' using index r_t_textlabel(+);

-- truncate --
truncate table t;
update statistics on t;
show indexes from t;
select /*+ recompile */  * from t where textlabel > '' using index r_t_textlabel(+);
select /*+ recompile */  * from t where textlabel > '' difference select /*+ recompile */  * from t where textlabel > '' using index r_t_textlabel(+);

-- re-populate the table with a few rows --
insert into t(id, textlabel, descr)
    values
	(9, '00n', 'n-record'),
	(10, 'aab', 'the textbook'),
	(11, 'xab', 'book descr'),
	(12, 'xxy', 'book chapters'),
	(13, 'xa0', 'author names'),
	(14, 'xa1', 'xa1'),
	(15, 'xab', 'xab'),
	(16, 'aff', 'syntax descr'),
	(17, 'afg', 'operators list'),
	(18, 'xkb', 'x-window system keyboard device');

create index idx_t_description on t(descr) where descr = textlabel;
	
-- try a few select /*+ recompile */ s (inspect the output for every of them) --
select /*+ recompile */  * from t order by id;

select /*+ recompile */  * from t where descr = textlabel order by id;
select /*+ recompile */  * from t where descr> '' using index idx_t_description(+) order by id;
select /*+ recompile */  * from t where descr = textlabel difference select /*+ recompile */  * from t where descr > '' using index idx_t_description(+);

set system parameters 'alter_table_change_type_strict=no';
drop table t;

commit;
--+ holdcas off;
