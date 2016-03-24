--create a table with class method and retrieve info from db_class

CREATE CLASS ddl_0001(
    dummy_column set( int ),
    num                 int,
    name               string
)
METHOD CLASS get_2000() int FUNCTION TEST_getInt
FILE '$HOME/method_test/myyang';

select class_name, owner_name, class_type, is_system_class, partitioned
from   db_class
where class_name = 'ddl_0001';



drop ddl_0001;