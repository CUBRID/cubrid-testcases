create table tree(id int,parentid int,text varchar(32));

prepare stm from 'insert tree values(?,?,?);'
execute stm using 1,null,'A'
execute stm using 2,null,'B'
execute stm using 3,1,'AA'
execute stm using 4,1,'AB'
execute stm using 5,2,'BA'
execute stm using 6,2,'BB'
execute stm using 7,3,'A--'
execute stm using 8,3,'A--'
deallocate prepare stm
execute stm using 9,4,'ABA';

drop table tree;