-- creating vclass with Collection type column and drop attribute whose type is cdt

create vclass ddl_0001(
	st set(int) ,
	mt multiset(date,char(10)),
	qt SEQUENCE(double)

);

alter VCLASS ddl_0001 drop ATTRIBUTE qt;

SELECT * FROM ddl_0001;

drop vclass ddl_0001;