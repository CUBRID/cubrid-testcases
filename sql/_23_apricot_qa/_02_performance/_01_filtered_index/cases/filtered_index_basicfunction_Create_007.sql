--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
-- create a table to be used for tests --
create table t(id integer, textlabel varchar(255), description varchar(4096));
create unique index idx1 on t(id);
create index idx2 on t(textlabel, description) where least(id,1000)>char_length(textlabel);
-- use create table like to duplicate the index definition --
-- should also create a new index with the new table --
create table other_t like t;

update statistics on t;
show indexes from t;
update statistics on other_t;
show indexes from other_t;

-- populate the table with a few rows --
insert into t(id, textlabel, description)
    values
	(10, 'aab', 'the textbook'),
	(11, 'xab', 'book description'),
	(12, 'xxy', 'book chapters'),
	(13, 'xa0', 'author names'),
	(14, 'xa1', 'xa1'),
	(15, 'xab', 'xab'),
	(16, 'aff', 'syntax description'),
	(17, 'afg', 'operators list');

--Test use create table like again, with a populated table --
create table the_other_t like t;
update statistics on the_other_t;
show indexes from the_other_t;
--Test 
drop unique index on t(id);
--Test 
drop index on t(textlabel, description) where least(id,1000)>char_length(textlabel);
--Test try alter table add index --
alter table t add index idx_t_id(id) where id > 10;
--Test 
alter table t add index idx_t_id_text(textlabel, id) where id > 10;
--Test 
create index idx3 on t(textlabel) where char_length(textlabel) > 3;
--Test 
create index idx_t_descr on t(description) where description = textlabel;
--Test 

-- same column and table as idx_t_id, no predicate
create index idx_tid on t(id);
--Test 
drop index idx_t_id on t;
--Test 
drop index idx_t_id_text on t;
--Test 
drop index on t(textlabel) where char_length(textlabel) > 3;
--Test 
drop index idx_t_descr on t;

-- multiple partial indexes with different predicates --
create index idx_tdesc on t(description) where description < textlabel;
--Test 
create index idx_tdescr on t(description desc) where description > textlabel;
--Test 
select index_name, class_name, key_count, filter_expression from db_index where class_name ='t' order by index_name;
--Test 
drop index idx_tdesc on t;
--Test 
drop index idx_tdescr on t;

-- test all functions with non-deterministic results --
--Test  all the following queries should return an error --
create index idx_t_description on t(description) where char_length(description) < (select max(id) from t);
drop index idx_t_description on t;
--Test 
create index idx_t_description on t(description) where char_length(description) * rand() < 4;
drop index idx_t_description on t;
--Test 
create index idx_t_description on t(description) where cahr_length(description) < char_length(current_user());
drop index idx_t_description on t;
--Test 
create index idx_t_description on t(description) where cahr_length(description) < char_length(current_database());
drop index idx_t_description on t;
--Test 
create index idx_t_description on t(description) where cahr_length(description) < char_length(version());
drop index idx_t_description on t;
--Test 
create index idx_t_description on t(description) where char_length(description) * drandom() < 4;
drop index idx_t_description on t;
--Test 
create index idx_t_description on t(description) where char_length(description) * drand() < 4;
drop index idx_t_description on t;
--Test 
create index idx_t_description on t(description) where char_length(description) * random() < 4;
drop index idx_t_description on t;
--Test 
create index idx_t_description on t(description) where char_length(description) * rand() < 4;
drop index idx_t_description on t;
--Test 
create index idx_t_description on t(description) where char_length(description) < year(curdate());
drop index idx_t_description on t;
--Test 
create index idx_t_description on t(description) where char_length(description) < year(current_date);
drop index idx_t_description on t;
--Test 
create index idx_t_description on t(description) where char_length(description) < year(current_datetime);
drop index idx_t_description on t;
--Test 
create index idx_t_description on t(description) where char_length(description) < minute(current_time);
drop index idx_t_description on t;
--Test 
create index idx_t_description on t(description) where char_length(description) < minute(current_timestamp);
drop index idx_t_description on t;
--Test 
create index idx_t_description on t(description) where char_length(description) < minute(curtime());
drop index idx_t_description on t;
--Test 
create index idx_t_description on t(description) where char_length(description) < minute(localtime);
drop index idx_t_description on t;
--Test 
create index idx_t_description on t(description) where char_length(description) < minute(localtimestamp);
drop index idx_t_description on t;
--Test 
create index idx_t_description on t(description) where char_length(description) < minute(now());
drop index idx_t_description on t;
--Test 
create index idx_t_description on t(description) where char_length(description) < minute(sys_date);
drop index idx_t_description on t;
--Test 
create index idx_t_description on t(description) where char_length(description) < year(sysdate);
drop index idx_t_description on t;
--Test 
create index idx_t_description on t(description) where char_length(description) < minute(sysdatetime);
drop index idx_t_description on t;
--Test 
create index idx_t_description on t(description) where char_length(description) < minute(systime);
drop index idx_t_description on t;
--Test 
create index idx_t_description on t(description) where char_length(description) < minute(systimestamp);
drop index idx_t_description on t;
--Test 
create index idx_t_description on t(description) where char_length(description) < minute(utc_time());
drop index idx_t_description on t;
--Test 
create index idx_t_description on t(description) where char_length(description) < year(utc_date());
drop index idx_t_description on t;
--Test 
create index idx_t_description on t(description) where char_length(description) < char_length(clob_from_file('qa_repository/files/unload/mdb.tar.gz'));
drop index idx_t_description on t;
--Test 
create index idx_t_description on t(description) where char_length(description) < octet_length(blob_from_file('qa_repository/files/unload/mdb.tar.gz'));
drop index idx_t_description on t;
--Test 
create index idx_t_description on t(description) where char_length(description) < char_length(current_user);
drop index idx_t_description on t;
--Test 
create index idx_t_description on t(description) where char_length(description) < char_length(schema());
drop index idx_t_description on t;
--Test 
create index idx_t_description on t(description) where char_length(description) < char_length(user);
drop index idx_t_description on t;
--Test 
create index idx_t_description on t(description) where char_length(description) < char_length(list_dbs());
drop index idx_t_description on t;
--Test 
create index idx_t_description on t(description) where char_length(description) < char_length(database());
drop index idx_t_description on t;
--Test 
create index idx_t_description on t(description) where char_length(description) < char_length(current_user);
drop index idx_t_description on t;
--Test 
create index idx_t_description on t(description) where char_length(description) = index_cardinality('t', 'idx_t_descr', 0);
drop index idx_t_description on t;
--Test 
create index idx_t_description on t(description) where char_length(description) = row_count();
drop index idx_t_description on t;
--Test 
create serial function_number start with 10 increment by 1;
create index idx_t_description on t(description) where char_length(description) = incr(function_number);
drop index idx_t_description on t;
--Test 
create index idx_t_description on t(description) where char_length(description) = decr(function_number);
drop index idx_t_description on t;
drop serial function_number;
--Test 
create index idx_t_description on t(description) where char_length(description) = avg(id);
drop index idx_t_description on t;
--Test 
create index idx_t_description on t(description) where char_length(description) = count(id);
drop index idx_t_description on t;
--Test 
create index idx_t_description on t(description) where char_length(description) = max(id);
drop index idx_t_description on t;
--Test 
create index idx_t_description on t(description) where char_length(description) = min(id);
drop index idx_t_description on t;
--Test 
create index idx_t_description on t(description) where char_length(description) = stddev(id);
drop index idx_t_description on t;
--Test 
create index idx_t_description on t(description) where char_length(description) = sum(id);
drop index idx_t_description on t;
--Test 
create index idx_t_description on t(description) where char_length(description) = variance(id);
drop index idx_t_description on t;
--Test 
create index idx_t_description on t(description) where char_length(description) = var_pop(id);
drop index idx_t_description on t;
--Test 
create index idx_t_description on t(description) where char_length(description) = var_samp(id);
drop index idx_t_description on t;
--Test 

-- create some multi-key index --
create index idx_t_multy on t(textlabel, description) where char_length(description) > octet_length(textlabel);
drop index idx_t_multy on t;
--Test 
create index idx_t_prefix_multy on t(textlabel, description(10)) where char_length(description) > octet_length(textlabel);
drop index idx_t_prefix_multy on t;
--Test 
create reverse unique index on t(id, textlabel) where id > 12;
drop reverse unique index on t(id, textlabel) where id > 12;
--Test 
-- test automatic index update when a column/table is being changed --
-- rename table --
rename table other_t to othert;
update statistics on othert;
show indexes from othert;
drop table othert;

--Test 
rename table the_other_t to theothert;
update statistics on theothert;
show indexes from theothert;
drop table theothert;

--Test 
rename table t to table_t;
update statistics on table_t;
show indexes from table_t;
drop table table_t;

set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
