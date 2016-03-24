--create class and add superclass for it and  add attributes on subclass and resolve inheritance conflict


CREATE CLASS ddl_0001;
CREATE CLASS ddl_0002;
CREATE CLASS ddl_0003;

ALTER CLASS ddl_0001 ADD SUPERCLASS ddl_0002,ddl_0003 ;

ALTER CLASS ddl_0001 ADD ATTRIBUTE col1 int unique;
ALTER CLASS ddl_0001 ADD ATTRIBUTE col2 varchar(100) NOT NULL;

ALTER CLASS ddl_0003 ADD ATTRIBUTE col3 int unique;
ALTER CLASS ddl_0003 ADD ATTRIBUTE col4 timestamp NOT NULL;
ALTER CLASS ddl_0003 ADD ATTRIBUTE ddl5 double;

CREATE CLASS ddl_0004;

ALTER CLASS ddl_0004  ADD SUPERCLASS ddl_0001,ddl_0002,ddl_0003
 INHERIT col3 of ddl_0001,
 col3 of ddl_0003 as col3_modify_1,
 col4 of ddl_0001,
 col4 of ddl_0003 as col4_modify_3,
 ddl5 of ddl_0001,
 ddl5 of ddl_0003 as ddl5_modify_5 ;

ALTER CLASS ddl_0002 ADD METHOD method1(numeric(10)) numeric(10) function Method_1 file '$HOME/method1' ;
ALTER CLASS ddl_0002 ADD METHOD method2(varchar(10)) int function Method_2 file '$HOME/method1' ;




drop class ddl_0004;
drop class ddl_0001;
drop class ddl_0002;
drop class ddl_0003;
