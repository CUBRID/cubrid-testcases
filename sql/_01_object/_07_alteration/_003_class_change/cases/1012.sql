--create a class,alter class add one method and the method's file,alter the class to change the  method's file


CREATE CLASS ddl_0001;
ALTER CLASS ddl_0001 add method method1(int) int function method1 file '$HOME/method' ;
ALTER CLASS ddl_0001 change file '$HOME/method' As '$HOME/method_none';




drop class ddl_0001;