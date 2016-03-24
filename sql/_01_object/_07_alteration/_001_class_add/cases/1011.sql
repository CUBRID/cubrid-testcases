-- create class,create vclass,alter vclass by adding an int attribute , alter vclass by adding a count function selecting query

CREATE CLASS ddl_0001;
CREATE VCLASS ddl_0002;
alter vclass ddl_0002 add attribute col1 int;
ALTER VCLASS ddl_0002 add query select count(*) from ddl_0001;




drop vclass ddl_0002;
drop class ddl_0001;