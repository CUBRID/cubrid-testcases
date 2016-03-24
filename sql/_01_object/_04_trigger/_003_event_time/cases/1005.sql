-- [er]create table ddl_0001 and then create a trigger DEFERRED UPDATE on ddl_0001

CREATE CLASS ddl_0001 ( n int );

CREATE TRIGGER ddl_0001_01
 DEFERRED UPDATE on ddl_0001
 IF old.n = 100
  EXECUTE PRINT 'ddl_0001_01';




drop ddl_0001;