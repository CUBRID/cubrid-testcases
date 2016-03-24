--test add attrubute with vclass

create vclass tb2(
	col1 char(8)
);

create vclass tb1(
	col1 int,
	col2 tb2
);

alter vclass tb2 add attribute col2 string;

drop vclass tb2;
drop vclass tb1;

