--create vclass with get_2000()

CREATE vclass ddl_0001(
    dummy_column set( int ),
    num                 int,
    name               string
)
METHOD get_2000() int FUNCTION TEST_getInt
FILE '$HOME/method_test/myyang';

drop vclass ddl_0001;