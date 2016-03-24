--change the default value,method,method's file of a class
 


CREATE CLASS ddl_0001;
ALTER ddl_0001 add col1 string default '*******';
ALTER CLASS ddl_0001 add method method1(int) int function method1 file '$HOME/method' ;
ALTER CLASS ddl_0001 add method method2(varchar(100)) varchar(100) function method2 file '$HOME/method' ;
ALTER CLASS ddl_0001 add method method3(numeric(10)) numeric(10) function method3 file '$HOME/method_an' ;
ALTER CLASS ddl_0001 add method method4(time) timestamp function method4 file '$HOME/meth_time' ;
ALTER CLASS ddl_0001 change file '$HOME/method' as '$HOME/method_an';
ALTER CLASS ddl_0001 change file '$HOME/method_an' as '$HOME/method1';
ALTER CLASS ddl_0001 change file '$HOME/meth_time' as '$HOME/meth_timestamp';
ALTER CLASS ddl_0001 change file '$HOME/method1' as '$HOME/method_an';
ALTER CLASS ddl_0001 change method method1;
ALTER CLASS ddl_0001 change method method2;
ALTER CLASS ddl_0001 change method method3;
ALTER CLASS ddl_0001 change method method4;
ALTER CLASS ddl_0001 modify col1 string default 'abcdefghijklmnopqrstuvwxyz';




drop class ddl_0001;