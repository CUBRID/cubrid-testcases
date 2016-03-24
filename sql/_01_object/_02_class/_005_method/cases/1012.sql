--create a table with three columns, define seven class methods:get_2000() that its return type is int , get_success() that its return type is string ,  get_null() that its return type is string,get_int(int) that its return type is int, get_string(string) that its return type is string, get_string2(string,string) that its return type is string, get_set() that its return type is SET, declare the implemented functions TEST_getInt ,TEST_getString,TEST_getNull, TEST_int_input,TEST_string_input2,TEST_getSet contained in the file '$HOME/method_test/myyang', drop table at last

CREATE CLASS ddl_0001(
    dummy_column set( int ),
    num                 int,
    name               string
)
METHOD CLASS get_2000() int FUNCTION TEST_getInt,
       CLASS get_success() string FUNCTION TEST_getString,
       CLASS get_null() string FUNCTION TEST_getNull,
       CLASS get_int(int) int FUNCTION TEST_int_input,
       CLASS get_string(string) string FUNCTION TEST_string_input,
       CLASS get_string2(string,string) string FUNCTION TEST_string_input2,
       CLASS get_set() SET FUNCTION TEST_getSet
FILE '$HOME/method_test/myyang';





drop ddl_0001;