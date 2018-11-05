--alter class attribute and create index


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
alter class ddl_0001 drop constraint "u_ddl_0001_col6" ;
alter class ddl_0001 add unique u_idx(col1,col2,col3) with online ;
create index idx_col1 on ddl_0001(col1) ;




drop class ddl_0001;
rollback;
rollback;
