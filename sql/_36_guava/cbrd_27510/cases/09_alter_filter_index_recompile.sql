/**
 *  This test case verifies CBRD-27510: ALTER ... MODIFY recompiles and rebuilds a filter index whose predicate
 *  reads the modified column.
 *
 *  A filter index keeps its predicate in the catalog as a stream compiled against the column types of the time it
 *  was created. develop recompiled and rebuilt an index when ALTER ... MODIFY changed a column of its key, but not
 *  when the column appeared only in the filter predicate, so the stream kept the old type (the shape of
 *  filtered_index_basicfunction_delete_004). CBRD-27510 plans a predicate stream's comparisons from the domains it
 *  was compiled with, so ALTER now recompiles the predicate and rebuilds the index in that case too, as it does for
 *  a key column.
 *
 *  The rows the filter index holds are pinned before and after the change, after new rows and after an UPDATE, and
 *  they are the develop answers. The catalog's filter_expression after the ALTER is new. The recompiled predicate
 *  reads  cast([dba.fr_t].c as double)+ cast(1 as double)=1  where develop kept the old text [dba.fr_t].c+1=1.
 *
 *  Coverage:
 *    Case 1: a filter predicate over a column the ALTER changes from INT to VARCHAR
 *    Case 2: a key column that the predicate reads too, changed from SMALLINT to CHAR
 *    Case 3: a function index over the column, changed from SMALLINT to VARCHAR
 */
--+ holdcas on;
-- Case 1. The filter index on fr_t(id) keeps the rows where c + 1 = 1. The rows and the catalog's filter_expression
-- are read before the ALTER, and the rows again after it, after new rows and after an UPDATE.
evaluate 'Case 1: a filter predicate over a column the ALTER changes';
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

-- Case 2. The predicate reads a key column too - develop recompiled this index already.
evaluate 'Case 2: a key column the predicate reads too';
drop table if exists fr_k;
create table fr_k (id int, c smallint);
insert into fr_k values (1, 0), (2, 1);
create index i_fr_k on fr_k (c) where c + 1 = 1;
alter table fr_k modify c char(10);
insert into fr_k values (3, '0');
select id, c from fr_k where c > '' and c + 1 = 1 using index i_fr_k(+) order by id;

-- Case 3. A function index over the column.
evaluate 'Case 3: a function index over the column';
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
