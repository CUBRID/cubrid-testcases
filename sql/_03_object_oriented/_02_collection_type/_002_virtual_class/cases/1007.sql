-- creating vclass with Collection type column and add attribute whose type is cdt

create vclass ddl_0001(
	st set(int) ,
	mt multiset(date,char(10)),
	qt SEQUENCE(double)

);

alter VCLASS ddl_0001 add ATTRIBUTE st1 set(set);

drop vclass ddl_0001;