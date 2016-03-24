--Create common index and retrieve information from db_index_key

create class ddl_0001(col1 int, col2 string, col3 char(10), col4 varchar(10), col5 object );
create index i_ddl_0001_col1_col2 on ddl_0001(col1,col2);
create index ddl_0001_index on ddl_0001(col1,col2,col3);
create unique index u_ddl_0001_col1_col2_col3_col4  on ddl_0001(col1,col2,col3,col4);
create unique index ddl_0001_unique on ddl_0001(col1);
create unique index ddl_0001_unique2 on ddl_0001(col1,col2,col3,col4,col5);

select index_name, class_name, key_attr_name, key_order
from   db_index_key
where  class_name = 'ddl_0001' order by 1,2,3;

drop class ddl_0001;
