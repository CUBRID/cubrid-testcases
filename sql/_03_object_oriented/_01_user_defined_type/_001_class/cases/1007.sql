--[er]test create with undefined table

create class tb1(
	col1 int,
	col2 tb2
);

drop class tb1;

