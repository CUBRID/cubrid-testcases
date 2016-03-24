--create a table with three columns, define a class method get_2000() that its return type is int, declare the implemented function TEST_getInt contained in the file '$HOME/method_test/myyang', drop table at last

CREATE CLASS ddl_0001(
    dummy_column set( int ),
    num                 int,
    name               string
)
METHOD CLASS get_2000() int FUNCTION TEST_getInt
FILE '$HOME/method_test/myyang';





drop ddl_0001;
