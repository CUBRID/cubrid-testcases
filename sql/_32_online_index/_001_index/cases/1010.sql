-- create index on same attribute


create class ddl_0001(col1 int, col2 string, col3 char(10), col4 varchar(10), col5 object );
create index idx on ddl_0001(col1,col2,col1) with online;

drop class ddl_0001;
rollback;
rollback;
