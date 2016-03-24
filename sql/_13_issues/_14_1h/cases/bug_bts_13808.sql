
--+ holdcas on;

drop table if exists foo;
drop table if exists std01;
drop table if exists std02;
drop table if exists pnt;
create table foo (a int);
insert into foo select rownum from db_class x, db_class y, db_class z, db_class w limit 10000;

drop table if exists pnt, std01, std02;
create table pnt (a int, b int, c char(100), d int, primary key (b,c,a));
create table std01 under pnt;
create table std02 under pnt;

insert into pnt select a, 1, '0', rownum from foo where mod (a, 3) = 0;
insert into std01 select a, 1, '1', rownum from foo where mod (a, 3) = 1;
insert into std02 select a, 1, '2', rownum from foo where mod (a, 3) = 2;

delete from all pnt where mod(a, 3) in (0,1);


drop table if exists foo;
drop table if exists std01;
drop table if exists std02;
drop table if exists pnt;

--+ holdcas off;
commit;
