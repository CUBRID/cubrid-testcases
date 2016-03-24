--[er]create reverse UNIQUE INDEX on which create vclass and then drop vclass

create vclass ddl_0001(col1 int, col2 string, col3 char(10), col4 varchar(10), col5 date );

create reverse UNIQUE index ddl_0001_index on ddl_0001(col1);


drop vclass ddl_0001;


rollback;
rollback;
rollback;
