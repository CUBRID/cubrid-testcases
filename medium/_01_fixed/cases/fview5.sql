autocommit off;
create table phone1
(number int, name string);
insert into phone1 values (2660000, 'Who');
insert into phone1 values (3437297, 'Uni');
insert into phone1 values (4592222, 'Gatti');
create table phone2
(number int, name string);
insert into phone2 values (4444444, 'Hut');
insert into phone2 values (3456789, 'Pages');
create table phone3
(number int, name string);
insert into phone3 values (2661896, 'Bee');
insert into phone3 values (911, 'Help');
create view phone
(number, name, low int, high int) as
select number, name, 0,  399  from phone1,
select number, name, 400, 799 from phone2,
select number, name, 800, 999 from phone3;
select name,number from phone where number = 3437297;
select name,number from phone where number = 3437297 and low <= 297 and high >= 297;
select name,number from phone where number = 3437297 and 297 between low and high;
select name,number from phone where 297 between low and high;
select name,number from phone where number = 911 and 911 between low and high;
rollback;
