--test create using self reference
create class tb1(
	col1 int,
	col2 tb1
);

drop class tb1;
