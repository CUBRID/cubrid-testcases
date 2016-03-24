-- [er]create a class,add a method and method'f file for this class,change the method'file to a no existing file,the report file not found error

CREATE CLASS ddl_0001;
ALTER CLASS ddl_0001 add method method1(int) int function method1 file '$HOME/method' ;
ALTER CLASS ddl_0001 add method method2(varchar(100)) varchar(100) function method2 file '$HOME/method' ;
ALTER CLASS ddl_0001 change file '$HOME/methodabcd' AS '$HOME/methodabcdefghij';




drop class ddl_0001;