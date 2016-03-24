--create reverse on which create class and then drop class

create class ddl_0001(col1 int, col2 string, col3 char(10), col4 varchar(10), col5 object );

create reverse index r_idx_col1 on ddl_0001(col1);
create reverse index r_idx_col1_col5 on ddl_0001(col1,col5);
create reverse index ddl_0001_index on ddl_0001(col1,col2,col3);


drop class ddl_0001;


rollback;
rollback;
rollback;
