--create index or unique index on which create class and then drop class
autocommit off;
drop if exists  ddl_0001;
create class ddl_0001(col1 int, col2 string, col3 char(10), col4 varchar(10), col5 object );
create index idx_col1_col2 on ddl_0001(col1,col2) with online;
create index ddl_0001_index on ddl_0001(col1,col2,col3) with online;
create unique index u_idx on ddl_0001(col1,col2,col3,col4) with online;
create unique index ddl_0001_unique on ddl_0001(col1) with online;
create unique index ddl_0001_unique2 on ddl_0001(col1,col2,col3,col4,col5) with online;
drop class ddl_0001;
rollback;
autocommit on;
