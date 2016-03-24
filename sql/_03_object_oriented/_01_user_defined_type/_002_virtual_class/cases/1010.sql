--[er]test create using a vclass with method

create vclass tb2(
	col1 char(8)
)
method vclass get_2000() int function TEST_getInt
file '$HOME/method_test/myyang';

create vclass tb1(
	col1 int,
	col2 tb2
);

drop vclass tb2;
drop vclass tb1;

