-- [er]create table ddl_0001, create trigger based on before select ddl_0001 event

CREATE CLASS ddl_0001( n int );

CREATE TRIGGER ddl_0001_01
BEFORE SELECT ddl_0001
IF 5 < ( INSERT INTO ddl_0002 values( 1 ) )
 EXECUTE REJECT;




drop ddl_0001;