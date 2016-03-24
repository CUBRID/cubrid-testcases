--create a table with three columns, define five methods:get_2000() that its return type is int , get_success() that its return type is string ,  get_null() that its return type is string,get_int(int) that its return type is int, get_string(string) that its return type is string, declare the implemented functions TEST_getInt ,TEST_getString,TEST_getNull, TEST_int_input contained in the file '$HOME/method_test/myyang', drop table at last

CREATE CLASS ddl_0001(
    dummy_column set( int ),
    num                 int,
    name               string
)
METHOD get_2000() int FUNCTION TEST_getInt,
       get_success() string FUNCTION TEST_getString,
       get_null() string FUNCTION TEST_getNull,
       get_int(int) int FUNCTION TEST_int_input,
       get_string(string) string FUNCTION TEST_string_input
FILE '$HOME/method_test/myyang';





drop ddl_0001;