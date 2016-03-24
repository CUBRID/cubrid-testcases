-- [er]create unique index on vclass and retrieve information from db_index_key
create vclass ddl_0001(col1 int, col2 string, col3 char(10), col4 varchar(10), col5 object );
create unique index u_idx  on ddl_0001(col1,col2);

select index_name, class_name, key_attr_name, key_order
from   db_index_key
where  class_name = 'ddl_0001';

drop vclass ddl_0001;
