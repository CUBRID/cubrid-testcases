-- [er]create class and rename attribute using exist name

CREATE CLASS ddl_0001;
ALTER ddl_0001 add col1 integer;
ALTER ddl_0001 add col2 varchar(10);
ALTER CLASS ddl_0001 rename col2 as col1;





drop class ddl_0001;

