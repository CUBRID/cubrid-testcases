--[er]create exsiting reverse unique index name  on which create class and then drop class

create class ddl_0001(col1 int, col2 string, col3 char(10), col4 varchar(10), col5 object );
create Reverse unique index ddl_0001_index on ddl_0001(col1,col2);
create Reverse unique index ddl_0001_index on ddl_0001(col1,col2,col3);


drop class ddl_0001;
rollback;
rollback;
rollback;
