-- [er] add query having character value to int column to vclass
 
CREATE CLASS ddl_0001;
CREATE VCLASS ddl_0002;
ALTER ddl_0002 add col11 int;
ALTER VCLASS ddl_0002 add query select to_char( count(*) ) from all ddl_0001;




drop vclass ddl_0002;
drop class ddl_0001;
