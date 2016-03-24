-- [er] create index and unique index using same attributes

create class ddl_0001(col1 int, col2 string, col3 char(10), col4 varchar(10), col5 object );
create index ddl_0001_index on ddl_0001(col2,col3);
create unique index ddl_0001_unique on ddl_0001(col2,col3);


drop class ddl_0001;
rollback;
rollback;
