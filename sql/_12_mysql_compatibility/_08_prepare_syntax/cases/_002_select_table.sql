create table tree(id int,parentid int,text varchar(32));

insert into tree values(1,null,'A');
insert into tree values(2,null,'B');
insert into tree values(3,1,'AA');
insert into tree values(4,1,'AB');
insert into tree values(5,2,'BA');
insert into tree values(6,2,'BB');
insert into tree values(7,3,'AAA');
insert into tree values(8,3,'AAB');

prepare stm from 'select * from tree order by id'
execute stm
deallocate prepare stm;

prepare stm from 'select * from tree where id>? order by id'
execute stm using 3
deallocate prepare stm;

prepare stm from 'select * from tree where text like ''%''+?+''%'' order by id'
execute stm using 'AA'
deallocate prepare stm;

prepare stm from 'select * from tree where text like ''%''+?+''%'' and id>? order by id'
execute stm using 'AA',2
deallocate prepare stm;

prepare stm from 'select * from tree start with parentid=? connect by prior id=parentid'
execute stm using 'AA'
deallocate prepare stm;

drop table tree;
