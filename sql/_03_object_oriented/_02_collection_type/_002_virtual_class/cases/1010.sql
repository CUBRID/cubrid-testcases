-- creating vclass with Collection type column and rename attribute whose type is cdt

create vclass ddl_0001(
	st set(int) ,
	mt multiset(date,char(10)),
	qt SEQUENCE(double)

);

alter VCLASS ddl_0001 rename ATTRIBUTE qt as qt1;

SELECT * FROM ddl_0001;

drop vclass ddl_0001;