create table foo (a char(10));
insert into foo values ('%ccab');
insert into foo values ('%_cab');
insert into foo values ('acab');
insert into foo values ('cab');
select * from foo where a like '%%_cab' escape '%';

create table foo1 (a char(10));
insert into foo1 values ('%cab');
insert into foo1 values ('%_ab'); 
insert into foo1 values('acab');
insert into foo1 values ('cab');
select * from foo1 where a like '%%cab' escape '%';
select * from foo1 where a like '%%_ab' escape '%';
select * from foo1 where a like '%cab' escape '';

create table foo2 (a char(10));
insert into foo2 values ('xyz%cab');
insert into foo2 values ('xyz%_ab');
insert into foo2 values ('xyz%_cab');
select * from foo2 where a like 'xyz%%cab' escape '%';
select * from foo2 where a like 'xyz%%_ab' escape '%';
select * from foo2 where a like 'xyz_%cab' escape '_';

select * from foo2 where a like 'x%u%_ab' escape 'u';
select * from foo2 where a like 'x%%cab' escape '';

create table foo3 (a char(10));
insert into foo3 values ('xyz_cab');
insert into foo3 values ('xyz_%ab');
insert into foo3 values ('xyz%_cab');
select * from foo3 where a like 'xyz_cab' escape 'z';
select * from foo3 where a like 'xyz__%ab' escape '_';

drop foo;
drop foo1;
drop foo2;
drop foo3;


