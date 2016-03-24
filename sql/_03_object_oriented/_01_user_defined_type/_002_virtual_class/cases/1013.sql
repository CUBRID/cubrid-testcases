--test create using self reference
create vclass tb1(
	col1 int,
	col2 tb1
);

drop vclass tb1;
