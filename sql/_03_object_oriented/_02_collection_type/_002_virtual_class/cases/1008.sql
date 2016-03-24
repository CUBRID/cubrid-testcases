-- creating vclass with Collection type column and change attribute whose type is cdt

create vclass ddl_0001(
	st set(int) ,
	mt multiset(date,char(10)),
	qt SEQUENCE(double)

);

alter VCLASS ddl_0001 modify st set(int) DEFAULT {1};

drop vclass ddl_0001;