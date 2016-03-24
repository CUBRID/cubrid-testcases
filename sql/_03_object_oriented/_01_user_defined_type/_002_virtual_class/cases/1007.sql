--[er]test create with undefined table

create vclass tb1(
	col1 int,
	col2 tb2
);

drop vclass tb1;

