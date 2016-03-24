--create classes ,create vclass with union keyword

CREATE CLASS ddl_0001 ( col1 integer);
Create class ddl_0002 ( col1 integer);

Create vclass ddl_0003 ( col1 integer)
as select col1 from ddl_0001
   union
   select col1 from ddl_0002;




drop vclass ddl_0003;
drop class ddl_0002;
drop class ddl_0001;