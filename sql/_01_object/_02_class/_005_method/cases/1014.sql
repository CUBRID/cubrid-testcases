--create a table with three columns, define two  methods:get_2000() that its return type is int , get_success() that its return type is string ,  declare the implemented functions TEST_getInt and TEST_getString contained in the file '$HOME/method_test/myyang', drop table at last

CREATE CLASS ddl_0001(
    dummy_column set( int ),
    num                 int,
    name               string
)
METHOD get_2000() int FUNCTION TEST_getInt,
       get_success() string FUNCTION TEST_getString
FILE '$HOME/method_test/myyang';





drop ddl_0001;