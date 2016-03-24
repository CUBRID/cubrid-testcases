--create calss and add  different return type method 


create class ddl_0001;

ALTER CLASS ddl_0001 ADD METHOD method1(int) int function method1 file '$HOME/method' ;
ALTER CLASS ddl_0001 ADD METHOD method2(varchar(100)) varchar(100) function method2 file '$HOME/method' ;
ALTER CLASS ddl_0001 ADD METHOD method3(numeric(10)) numeric(10) function method3 file '$HOME/method_an' ;
ALTER CLASS ddl_0001 ADD METHOD method4(time) timestamp function method4 file '$HOME/meth_time' ;





drop class ddl_0001;
