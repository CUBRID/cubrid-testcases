-- create class,create trigger based on this class,drop this trigger, drop this class

CREATE CLASS ddl_0001
(
       aa_no numeric(8,0) NOT NULL unique,
       aa set(ddl_0001)
);
CREATE TRIGGER ddl_0002
  STATUS ACTIVE
  PRIORITY 0.000000
  BEFORE UPDATE ON ddl_0001(aa_no)
  EXECUTE PRINT '********** aa_update_del trigger **********';





DROP TRIGGER ddl_0002;
DROP CLASS ddl_0001;
