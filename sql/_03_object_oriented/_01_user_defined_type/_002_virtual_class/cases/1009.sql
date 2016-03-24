--test alter using to alter default value of a column 

create vclass tb2(
	col1 char(8)
);


create vclass tb1(
	col1 int,
	col2 tb2
);


alter vclass tb2 modify col1 char(8) default 'aaa'; 

drop vclass tb2;
drop vclass tb1;

