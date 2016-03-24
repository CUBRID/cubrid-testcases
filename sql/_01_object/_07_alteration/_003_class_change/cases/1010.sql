--create a class,alter class add one method and method's file,alter the class to change the method
CREATE CLASS ddl_0001;
ALTER CLASS ddl_0001 add method method1( int ) int function method1 file '$HOME/method';
ALTER CLASS ddl_0001 change method method1;




drop class ddl_0001;