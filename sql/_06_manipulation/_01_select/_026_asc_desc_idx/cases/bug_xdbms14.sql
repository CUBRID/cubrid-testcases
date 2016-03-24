--Test create index with asc/desc
create class ddl_0001(col1 int, col2 string, col3 char(10), col4 varchar(10), col5 object );
create index ddl_0001_idx1 on ddl_0001(col1 asc);
create index ddl_0001_idx2 on ddl_0001(col1 desc); 
select * from db_index where index_name like 'ddl_0001_idx%' order by 1;

drop class ddl_0001;
