--create unique index on which create class and then drop class

create class ddl_0001(col1 int, col2 string, col3 char(10), col4 varchar(10), col5 object );
create unique index u_idx on ddl_0001(col1,col2,col3,col4);
create unique index ddl_0001_unique on ddl_0001(col1);
create unique index ddl_0001_unique2 on ddl_0001(col1,col2,col3,col4,col5);

drop class ddl_0001;
rollback;
rollback;
