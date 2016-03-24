-- create classes,alter class by adding superclass,alter classes by adding attribute,alter class by adding specify column of super class,drop classes

CREATE CLASS ddl_0001;
CREATE CLASS ddl_0002;
CREATE CLASS ddl_0003;

ALTER CLASS ddl_0001  aDD SUPERCLASS ddl_0002,ddl_0003 ;

ALTER CLASS ddl_0001 ADD ATTRIBUTE col1 int unique;
ALTER CLASS ddl_0001 ADD ATTRIBUTE col2 varchar(100) NOT NULL;

ALTER CLASS ddl_0003 ADD ATTRIBUTE col3 int unique;
ALTER CLASS ddl_0003 ADD ATTRIBUTE col4 timestamp NOT NULL;
ALTER CLASS ddl_0003 ADD ATTRIBUTE ddl5 double;

CREATE CLASS ddl_0004;

ALTER CLASS ddl_0004  add superclass ddl_0001,ddl_0002,ddl_0003
 inherit col3 of ddl_0001,
 col3 of ddl_0003 as col3_modify_1,
 col4 of ddl_0001,
 col4 of ddl_0003 as col4_modify_3,
 ddl5 of ddl_0001,
 ddl5 of ddl_0003 as ddl5_modify_5 ;




drop class ddl_0004;
drop class ddl_0003;
drop class ddl_0002;
drop class ddl_0001;
