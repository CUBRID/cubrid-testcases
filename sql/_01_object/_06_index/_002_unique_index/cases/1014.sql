--[er]create unique index on vclass

create vclass ddl_0001(col1 int, col2 string, col3 char(10), col4 varchar(10), col5 object );
create unique index u_idx on ddl_0001(col1,col2);

drop ddl_0001;
rollback;
rollback;
