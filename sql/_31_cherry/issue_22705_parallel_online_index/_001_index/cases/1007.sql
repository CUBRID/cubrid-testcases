-- [er] create two index using same attribute
drop if exists ddl_0001;
create class ddl_0001(col1 int, col2 string, col3 char(10), col4 varchar(10), col5 object );
create index ddl_0001_index on ddl_0001(col1) with online parallel 1;
create index ddl_0001_index1 on ddl_0001(col1) with online parallel 2;
drop class ddl_0001;
