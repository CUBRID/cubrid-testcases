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
deallocate prepare stm;

prepare stm from 'update tree set text=''AA-'' where text=''A--'';'
execute stm
deallocate prepare stm;

prepare stm from 'update tree set text=? where id=?;'
execute stm using 'AAA',7
execute stm using 'AAB',8
deallocate prepare stm;

prepare stm from 'select id,parentid,text,level from tree start with parentid is null connect by parentid=prior id order by id;'
execute stm
deallocate prepare stm;

prepare stm from 'select id,parentid,text,level from tree where level=? start with parentid is null connect by parentid=prior id order by id;'
execute stm using 2
deallocate prepare stm;

prepare stm from 'delete from tree where id>2'
execute stm
deallocate prepare stm;

prepare stm from 'delete from tree where id=?'
execute stm using 1
execute stm using '2'
deallocate prepare stm;

drop table tree;