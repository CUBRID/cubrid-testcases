-- create two Unique  index on same attribute and retrieve information from db_index

create class ddl_0001(col1 int, col2 string, col3 char(10), col4 varchar(10), col5 object );
create Unique index u_ddl_0001_col1_col2 on ddl_0001(col1,col2);
create Unique index ddl_0001_index on ddl_0001(col1,col2);

select index_name, is_unique, is_reverse, class_name, key_count
from   db_index
where  class_name = 'ddl_0001' order by index_name;

drop class ddl_0001;
