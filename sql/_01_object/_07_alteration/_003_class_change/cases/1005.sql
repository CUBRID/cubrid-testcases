-- [er]create a class,change the class' method file,but the file does not exist 

CREATE CLASS ddl_0001;
ALTER CLASS ddl_0001 change file '$HOME/method' as '$HOME/method_an';





drop class ddl_0001;