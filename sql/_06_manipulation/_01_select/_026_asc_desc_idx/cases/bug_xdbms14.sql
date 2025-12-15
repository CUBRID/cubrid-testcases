--Test create index with asc/desc
create class ddl_0001(col1 int, col2 string, col3 char(10), col4 varchar(10), col5 object );
create index ddl_0001_idx1 on ddl_0001(col1 asc);
create index ddl_0001_idx2 on ddl_0001(col1 desc); 
SELECT index_name, is_unique, is_reverse, class_name, owner_name, key_count, is_primary_key, is_foreign_key, filter_expression, have_function, comment, status FROM db_index where index_name like 'ddl_0001_idx%' order by 1;

drop class ddl_0001;
