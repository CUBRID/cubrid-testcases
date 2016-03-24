-- [er]create table ddl_0001,create trigger based on BEFORE SELECT ON ddl_0001(n) event and use NULL IS function

CREATE CLASS ddl_0001( n int );

CREATE TRIGGER ddl_0001_01
BEFORE SELECT ON ddl_0001(n)
IF NULL IS ( INSERT INTO ddl_0002 values( 1 ) )
 EXECUTE REJECT;




drop ddl_0001;