--+ holdcas on;
-- workspace#368 (map #312, dpin-18b, D-368-05; develop defect #359): ALTER ... MODIFY compiles anew and rebuilds a
-- filter index whose predicate reads the column, as it does an index whose key holds the column - the catalog kept the
-- predicate's stream compiled against the column's old type (filtered_index_basicfunction_delete_004). The rows the
-- filtered index holds and the predicate text are pinned before and after the change and after new rows.
drop table if exists fr_t;
create table fr_t (id int not null, c int);
insert into fr_t values (1, 0), (2, 1), (3, 0);
create index i_fr_t on fr_t (id) where c + 1 = 1;
select id, c from fr_t where id > 0 and c + 1 = 1 using index i_fr_t(+) order by id;
select index_name, filter_expression from db_index where class_name = 'fr_t';
alter table fr_t modify c varchar(10);
select id, c from fr_t where id > 0 and c + 1 = 1 using index i_fr_t(+) order by id;
insert into fr_t values (4, '0'), (5, '7');
select id, c from fr_t where id > 0 and c + 1 = 1 using index i_fr_t(+) order by id;
update fr_t set c = '0' where id = 2;
select id, c from fr_t where id > 0 and c + 1 = 1 using index i_fr_t(+) order by id;
select index_name, filter_expression from db_index where class_name = 'fr_t';
-- a key column the predicate reads too
drop table if exists fr_k;
create table fr_k (id int, c smallint);
insert into fr_k values (1, 0), (2, 1);
create index i_fr_k on fr_k (c) where c + 1 = 1;
alter table fr_k modify c char(10);
insert into fr_k values (3, '0');
select id, c from fr_k where c > '' and c + 1 = 1 using index i_fr_k(+) order by id;
-- a function index over the column
drop table if exists fr_f;
create table fr_f (id int, c smallint);
insert into fr_f values (1, 5), (2, -7);
create index i_fr_f on fr_f (abs (c));
alter table fr_f modify c varchar(10);
insert into fr_f values (3, '-7');
select id, c from fr_f where abs (c) = 7 order by id;
select index_name, have_function from db_index where class_name = 'fr_f';
drop table fr_t;
drop table fr_k;
drop table fr_f;
--+ holdcas off;
