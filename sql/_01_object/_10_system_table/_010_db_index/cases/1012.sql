--create unique index on which create class and then query from db_index

create class ddl_0001(col1 int, col2 string, col3 char(10), col4 varchar(10), col5 object );
create unique index u_ddl_0001_col1_col2_col3_col4  on ddl_0001(col1,col2,col3,col4);
create unique index ddl_0001_unique on ddl_0001(col1);
create unique index ddl_0001_unique2 on ddl_0001(col1,col2,col3,col4,col5);

select index_name, is_unique, is_reverse, class_name, key_count
from   db_index
where  class_name = 'ddl_0001';

drop class ddl_0001;
