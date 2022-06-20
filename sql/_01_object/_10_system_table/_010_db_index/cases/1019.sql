-- create reverse unique INDEX with same column that are already user by unique index and retrieve information from db_index
create class ddl_0001(col1 int, col2 string, col3 char(10), col4 varchar(10), col5 date );

create unique index u_ddl_0001_col1 on ddl_0001(col1);
create reverse unique index ddl_0001_index on ddl_0001(col1);

select index_name, is_unique, is_reverse, class_name, key_count
from   db_index
where  class_name = 'ddl_0001' order by index_name;

drop class ddl_0001;


