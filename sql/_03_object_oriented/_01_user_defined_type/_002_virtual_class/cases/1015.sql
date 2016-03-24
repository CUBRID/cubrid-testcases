--[er]test add constraint using alter statement

create vclass tb2(
	col1 char(8)
);

create vclass tb1(
	col1 int,
	col2 tb2
);

alter vclass tb2 add constraint aaa unique(col1);

drop vclass tb2;
drop vclass tb1;

