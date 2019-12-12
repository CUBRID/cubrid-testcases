--+ holdcas on;
set system parameters 'compat_mode=mysql';

create table tree(g1 int,g2 int,g3 int,text varchar(32))

insert into tree values(1,1,1,'a');
insert into tree values(1,1,2,'a');
insert into tree values(1,2,2,'a');
insert into tree values(1,3,2,'a');
insert into tree values(1,3,3,'a');
insert into tree values(2,1,1,'a');
insert into tree values(2,2,1,'a');
insert into tree values(2,3,1,'a');
insert into tree values(2,3,2,'a');
insert into tree values(3,1,2,'a');
insert into tree values(3,3,1,'a');
insert into tree values(3,3,2,'a');

select g1,g2 as g1,g3 as g1,count(*) as c
	from tree
	group by g1,g2,g3
	order by g1,g2,g3;
	
drop table tree;

set system parameters 'compat_mode=cubrid';commit;
--+ holdcas off;
