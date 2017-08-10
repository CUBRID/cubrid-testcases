--+ holdcas on;
set system parameters 'compat_mode=mysql';

create table tree(id int auto_increment, parentid int, text varchar(32));

insert into tree(parentid,text) values(null,'A');
insert into tree(parentid,text) values(null,'B');
insert into tree(parentid,text) values(null,'C');
insert into tree values(4,null,'D');
insert into tree values(null,null,'E');
insert into tree values(null,null,'F');
insert into tree values(1,null,'G');
insert into tree(parentid,text) values(null,'H');

select * from tree order by 1, 3;

drop table tree;

set system parameters 'compat_mode=cubrid';
commit;
--+ holdcas off;
