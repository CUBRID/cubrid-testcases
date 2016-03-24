--create reverse unique INDEX using same columns and retrieve information from db_index

create class ddl_0001(col1 int, col2 string, col3 char(10), col4 varchar(10), col5 date );

create reverse unique index ru_ddl_0001_col1_col5  on ddl_0001(col1,col5);
create reverse unique index ddl_0001_index on ddl_0001(col1,col5);

select index_name, is_unique, is_reverse, class_name, key_count
from   db_index
where  class_name = 'ddl_0001';

drop class ddl_0001;
