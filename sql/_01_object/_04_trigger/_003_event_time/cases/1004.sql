--create two tables ddl_0001,ddl_0002, create a trigger after insert  ddl_0002,the trigger's action is that inserting some data to ddl_0001 after insert ddl_0002 with obj variable
CREATE CLASS ddl_0001(
 col1 int,
 col2 string
);
CREATE CLASS ddl_0002(
 col1 int,
 col2 string
);

CREATE TRIGGER ddl_0003
AFTER INSERT ON ddl_0002
 EXECUTE INSERT INTO ddl_0001( col1, col2 ) VALUES( obj.col1 ,to_char( obj.col1 ) );




drop trigger ddl_0003;
drop ddl_0002;
drop ddl_0001;