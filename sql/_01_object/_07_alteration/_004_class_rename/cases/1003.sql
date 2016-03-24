--create class and rename method

CREATE CLASS ddl_0001;
ALTER CLASS ddl_0001 add method method1( int ) int function method1 file '$HOME/method';

ALTER CLASS ddl_0001 RENAME METHOD method1 as method2;


drop class ddl_0001;