--create reverse index on class and then retrieve information from db_index

create class ddl_0001(col1 int, col2 string, col3 char(10), col4 varchar(10), col5 object );

create reverse index ri_ddl_0001_col1  on ddl_0001(col1);
create reverse index ri_ddl_0001_col1_col5 on ddl_0001(col1,col5);
create reverse index ddl_0001_index on ddl_0001(col1,col2,col3);

select index_name, is_unique, is_reverse, class_name, key_count
from   db_index
where  class_name = 'ddl_0001' order by index_name;

drop class ddl_0001;
