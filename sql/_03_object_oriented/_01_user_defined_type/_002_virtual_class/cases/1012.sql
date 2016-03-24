--test vclass constraint using unique as attribute of column
create vclass tb2(
	col1 char(8) unique
);


drop vclass tb2;
