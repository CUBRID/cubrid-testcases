-- creating vclass with Collection type column and rename the vclass and then drop it 

create vclass ddl_0001(
	st set(int) ,
	mt multiset(date,char(10)),
	qt SEQUENCE(double)

);

rename VCLASS ddl_0001 as ddl_00011;

SELECT * FROM ddl_00011;

drop vclass ddl_00011;