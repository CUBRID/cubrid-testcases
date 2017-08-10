--insert into a table (test default value of SYSDATE and SYSDATETIME)
--trigger: 1) before insert  2) after insert
--trigger action: insert into 2 tables.



create table c38(col1 int primary key auto_increment, col2 date default SYSDATE, col3 datetime default sysdatetime);
create table c38_actions1(col1 int primary key auto_increment, col2 date default SYSDATE);
create table c38_actions2(col1 int primary key auto_increment, col2 datetime default SYSDATETIME);

--create trigger
create trigger trig_bef_ins before insert on c38
execute insert into c38_actions1 values default;

create trigger trig_aft_ins after insert on c38
execute insert into c38_actions2 values default;

insert into c38 values default;
insert into c38 values default;
insert into c38 values default;

select if (c38.col2 = a1.col2, 'ok', 'nok') from c38 inner join c38_actions1 a1 on c38.col1=a1.col1;
select if (abs(c38.col3 - a2.col2) < 1000, 'ok', 'nok') from c38 inner join c38_actions2 a2 on c38.col1=a2.col1;

drop trigger trig_bef_ins;
drop trigger trig_aft_ins;
drop table c38_actions1, c38_actions2, c38;
