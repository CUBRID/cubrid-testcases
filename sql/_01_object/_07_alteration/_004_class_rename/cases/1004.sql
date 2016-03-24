--create class and rename file

CREATE CLASS ddl_0001;
ALTER CLASS ddl_0001 add method method1( int ) int function method1 file '$HOME/method';

ALTER CLASS ddl_0001 RENAME file '$HOME/method' as '$HOME/method'; 


drop class ddl_0001;