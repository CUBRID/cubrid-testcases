-- [er] create two  Unique index using same name

create class ddl_0001(col1 int, col2 string, col3 char(10), col4 varchar(10), col5 object );
create  Unique index ddl_0001_index on ddl_0001(col1);
create  Unique index ddl_0001_index on ddl_0001(col1,col2);

drop class ddl_0001;
rollback;
rollback;
