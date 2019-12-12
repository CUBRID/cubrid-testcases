--Test the bug 743

create class ta(a int primary key, b int);
create class tb(a int, b int);
insert into ta(a, b) values(1, 1);
insert into ta(a, b) values(2, 2);
insert into tb(a, b) values(1, 2);
create index idx_a on tb(a);
alter table tb add constraint fk_tb_a foreign key (a) references ta;
update tb set a=2 where b =2;

drop class tb;
drop class ta;
