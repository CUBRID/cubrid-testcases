--create class,create vclass,alter vclass by adding an attribute,alter vclass by adding a query,drop vclass and class

CREATE CLASS ddl_0001;
CREATE VCLASS ddl_0002;

ALTER ddl_0002 add col11 varchar(100);

ALTER VCLASS ddl_0002
   add query select to_char( count(*) ) from all ddl_0001;




drop vclass ddl_0002;
drop  ddl_0001;