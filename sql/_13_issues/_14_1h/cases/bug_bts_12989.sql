autocommit off;
drop table if exists tb1;
create table tb1(id int primary key,col int);
insert into tb1 values(1,60),(2,80),(3,70);

CREATE TRIGGER trg1 DEFERRED UPDATE ON tb1 if (obj.col > 100) EXECUTE UPDATE tb1 SET col=100 WHERE id=obj.id;

update tb1 set col=120 where id=2;
select * from tb1 order by 1,2;
commit;
select * from tb1 order by 1,2;

drop table tb1;
create table tb1(id int primary key,col int);
insert into tb1 values(1,60),(2,80),(3,70);

CREATE TRIGGER trg1 DEFERRED UPDATE ON tb1 if (obj.col > 100) EXECUTE UPDATE tb1 SET col=100 WHERE id=obj.id;

update tb1 set col=120 where id=2;
select * from tb1 order by 1,2;
commit;

select * from tb1 order by 1,2;
drop table tb1;

create table tb2(id int primary key,col int);
insert into tb2 values(4,60),(5,80),(6,70);

CREATE TRIGGER trg1 DEFERRED UPDATE ON tb2 if (obj.col > 100) EXECUTE UPDATE tb2 SET col=100 WHERE id=obj.id;

update tb2 set col=120 where id=4;
select * from tb2 order by 1,2;
commit;

update tb2 set col=120 where id=5;
EXECUTE DEFERRED TRIGGER trg1;

select * from tb2 order by 1,2;
commit;

update tb2 set col=120 where id=6;
EXECUTE DEFERRED TRIGGER trg1;

select * from tb2 order by 1,2;
rollback;
select * from tb2 order by 1,2;
drop table tb2;

create table tb2(id int primary key,col int);
insert into tb2 values(4,60),(5,80),(6,70);

CREATE TRIGGER trg1 DEFERRED UPDATE ON tb2 if (obj.col > 100) EXECUTE UPDATE tb2 SET col=100 WHERE id=obj.id;

update tb2 set col=120 where id=4;
select * from tb2 order by 1,2;
commit;
select * from tb2 order by 1,2;
drop table tb2;

autocommit on;
