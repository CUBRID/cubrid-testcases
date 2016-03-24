--create table ddl_0001,create an unique index on ddl_0001(aa_no, num);create another table ddl_0002,create two triggers bofore update on ddl_0001(aa_no),create two triggers after update on ddl_0001(aa_no)

CREATE CLASS ddl_0001
(
       aa_no numeric(8,0) NOT NULL,
       num numeric(8,0) NOT NULL
);
create unique index u_ddl_0001_aa_no_num on ddl_0001(aa_no, num);
CREATE CLASS ddl_0002
(
       aa_no numeric(8,0) NOT NULL unique,
       aa set(ddl_0001)
);
CREATE TRIGGER ddl_0002_01
  STATUS ACTIVE
  PRIORITY 0.000000
  BEFORE UPDATE ON ddl_0001(aa_no)
  EXECUTE PRINT '********** aa_update_del trigger **********';
CREATE TRIGGER ddl_0002_02
  STATUS ACTIVE
  PRIORITY 0.000000
  BEFORE UPDATE ON ddl_0001(aa_no)
  EXECUTE update ddl_0002 set aa=aa-{obj} where aa_no=obj.aa_no;
CREATE TRIGGER ddl_0002_03
  STATUS ACTIVE
  PRIORITY 0.000000
  AFTER UPDATE ON ddl_0001(aa_no)
  EXECUTE PRINT '********** aa_update_ins trigger **********';
CREATE TRIGGER ddl_0002_04
  STATUS ACTIVE
  PRIORITY 0.000000
  AFTER UPDATE ON ddl_0001(aa_no)
  EXECUTE update ddl_0002 set aa=aa+{obj} where aa_no=obj.aa_no;




drop trigger ddl_0002_01;
drop trigger ddl_0002_02;
drop trigger ddl_0002_03;
drop trigger ddl_0002_04;
drop class ddl_0001;
drop class ddl_0002;
