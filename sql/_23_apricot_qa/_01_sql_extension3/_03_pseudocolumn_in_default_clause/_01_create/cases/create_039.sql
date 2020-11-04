--insert into a table (test default value of USER and CURRENT_USER)
--trigger: 1) before insert  2) after insert
--trigger action: insert into 2 tables.


create table aaa(col1 int primary key auto_increment, col2 char(3) default USER);
create table aaa_actions(col1 int primary key auto_increment, col2 varchar default CURRENT_USER);

--create trigger
create trigger trig_bef_ins before insert on aaa
execute insert into aaa_actions values default;


insert into aaa values default;
insert into aaa values default;
insert into aaa values default;

select if (aaa.col2 = a1.col2, 'ok', 'nok') from aaa inner join aaa_actions a1 on aaa.col1=a1.col1;

drop trigger trig_bef_ins;
drop table aaa_actions, aaa;
