--[er]test create with a vclass not previously defined

create vclass tb1(
	col1 int,
	col2 tb2
);

create vclass tb2(
	col1 int
);

drop vclass tb2;
drop vclass tb1;

