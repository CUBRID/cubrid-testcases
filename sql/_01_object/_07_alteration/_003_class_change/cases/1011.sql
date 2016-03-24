--create a class,alter class add four methods and method's file,alter the class to change four methods


CREATE CLASS ddl_0001;
ALTER CLASS ddl_0001 add method method1(int) int function method1 file '$HOME/method' ;
ALTER CLASS ddl_0001 add method method2(varchar(100)) varchar(100) function method2 file '$HOME/method' ;
ALTER CLASS ddl_0001 add method method3(numeric(10)) numeric(10) function method3 file '$HOME/method_an' ;
ALTER CLASS ddl_0001 add method method4(time) timestamp function method4 file '$HOME/meth_time' ;

ALTER CLASS ddl_0001 change method method1;
ALTER CLASS ddl_0001 change method method2;
ALTER CLASS ddl_0001 change method method3;
ALTER CLASS ddl_0001 change method method4;




drop class ddl_0001;