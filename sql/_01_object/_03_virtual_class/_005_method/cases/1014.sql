--create vclass with methods(like get_2000(), get_success())

CREATE vclass ddl_0001(
    dummy_column set( int ),
    num                 int,
    name               string
)
METHOD get_2000() int FUNCTION TEST_getInt,
       get_success() string FUNCTION TEST_getString
FILE '$HOME/method_test/myyang';

drop vclass ddl_0001;