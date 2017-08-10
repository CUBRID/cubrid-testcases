--insert into a table (test default value of CURRENT_TIMESTAMP, UNIX_TIMESTAMP() and SYSTIMESTAMP)
--trigger: 1) before insert  2) after insert
--trigger action: insert into 2 tables.



create table c37(col1 int primary key auto_increment, col2 timestamp default CURRENT_TIMESTAMP);
create table c37_actions1(col1 int primary key auto_increment, col2 timestamp default UNIX_TIMESTAMP());
create table c37_actions2(col1 int primary key auto_increment, col2 timestamp default SYSTIMESTAMP);

--TEST: create trigger
create trigger trig_bef_ins before insert on c37
execute insert into c37_actions1 values default;

create trigger trig_aft_ins after insert on c37
execute insert into c37_actions2 values default;

insert into c37 values default;
insert into c37 values default;
insert into c37 values default;

--TEST: check trigger action result
select if (abs(c37.col2 - a1.col2) < 100, 'ok', 'nok') from c37 inner join c37_actions1 a1 on c37.col1=a1.col1;
select if (abs(c37.col2 - a2.col2) < 1000, 'ok', 'nok') from c37 inner join c37_actions2 a2 on c37.col1=a2.col1;

drop trigger trig_bef_ins;
drop trigger trig_aft_ins;
drop table c37_actions1, c37_actions2, c37;
