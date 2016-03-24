--create a class,alter class add four methods and the methods' file,alter the class to change the four methods' file

CREATE CLASS ddl_0001;
ALTER CLASS ddl_0001 add method method1(int) int function method1 file '$HOME/method' ;
ALTER CLASS ddl_0001 add method method2(varchar(100)) varchar(100) function method2 file '$HOME/method' ;
ALTER CLASS ddl_0001 add method method3(numeric(10)) numeric(10) function method3 file '$HOME/method_an' ;
ALTER CLASS ddl_0001 add method method4(time) timestamp function method4 file '$HOME/meth_time' ;

ALTER CLASS ddl_0001 change file '$HOME/method' as '$HOME/method_an';
ALTER CLASS ddl_0001 change file '$HOME/method_an' as '$HOME/method1';
ALTER CLASS ddl_0001 change file '$HOME/meth_time' as '$HOME/meth_timestamp';
ALTER CLASS ddl_0001 change file '$HOME/method1' as '$HOME/method_an';




drop class ddl_0001;