--[er]create table ddl_0001,create trigger based on after insert on ddl_0001 event

CREATE CLASS ddl_0001( n int );

CREATE TRIGGER ddl_0001_01
AFTER INSERT ON ddl_0001
If new.n < ( SELECT count(*) FROM ddl_0002 )
 EXECUTE REJECT;




drop ddl_0001;