create table tree2(id int,treeid int,text varchar(32));
create index idx1 on tree2(id);

insert into tree2 values(1,null,'B');
insert into tree2 values(2,null,'A');
insert into tree2 values(3,1,'BAA');
insert into tree2 values(4,1,'AB');
insert into tree2 values(5,2,'CBA');
insert into tree2 values(6,2,'DBB');
insert into tree2 values(7,6,'CBBA');
insert into tree2 values(8,null,'C');

select * from 
(select * from tree2 where id < 3  
 connect by treeid = prior id using index idx1(+) 
 ) x order by 1;

drop table tree2;
