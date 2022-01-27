create table tree2(id int,treeid int,text varchar(32));

insert into tree2 values(1,null,'B');
insert into tree2 values(2,null,'A');
insert into tree2 values(3,1,'BAA');
insert into tree2 values(4,1,'AB');
insert into tree2 values(5,2,'CBA');
insert into tree2 values(6,2,'DBB');
insert into tree2 values(7,6,'CBBA');
insert into tree2 values(8,null,'C');

select * from tree2 where isnull(treeid)  order by 1;

drop table tree2;
