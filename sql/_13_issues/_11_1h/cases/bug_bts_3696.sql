create table a(id int primary key,text varchar(32),fkid int);
create table b(id int primary key,text varchar(32),fkid int);

insert into a value(1,'a',2);
insert into b value(2,'a',1);

alter table a add constraint fk_1 foreign key(fkid) references b(id) on delete cascade;
alter table b add constraint fk_2 foreign key(fkid) references a(id) on delete cascade;

select * from a;
select * from b;

delete from b;

select * from a;
select * from b;

alter table a drop constraint fk_1;
alter table b drop constraint fk_2;

drop table a;
drop table b;


