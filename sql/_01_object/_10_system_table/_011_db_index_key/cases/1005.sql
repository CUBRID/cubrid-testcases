--Create class and modify default index, retrieve information from db_index_key

CREATE CLASS ddl_0001(
   col1       smallint,
   col2       smallint,
   col3       smallint NOT NULL,
   col4       smallint DEFAULT 2 NOT NULL,
   col5       smallint DEFAULT 2 Not Null,
   col6       smallint UNIQUE,
   col7       smallint UNIQUE NOT NULL,
   col8       smallint SHARED NULL,
   col9       smallint SHARED 1 NOT NULL
);

select index_name, is_unique, is_reverse, class_name, key_count
from   db_index
where  class_name = 'ddl_0001';

alter class ddl_0001 drop constraint "u_ddl_0001_col6" ;
alter class ddl_0001 add unique u_ddl_0001_col1_col2_col3 (col1,col2,col3) ;
create index i_ddl_0001_col1 on ddl_0001(col1) ;

select index_name, class_name, key_attr_name, key_order
from   db_index_key
where  class_name = 'ddl_0001'
order by index_name, key_order;

drop class ddl_0001;
