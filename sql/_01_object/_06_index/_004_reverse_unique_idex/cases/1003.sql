--create reverse unique INDEX using same columns on which create class and then drop class

create class ddl_0001(col1 int, col2 string, col3 char(10), col4 varchar(10), col5 date );

create reverse unique index ru_idx on ddl_0001(col1,col5);
create reverse unique index ddl_0001_index on ddl_0001(col1,col5);


drop class ddl_0001;


rollback;
rollback;
rollback;
