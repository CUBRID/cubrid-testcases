autocommit off;
create class jorge_time2 (a time default '12:00:00');
insert into jorge_time2 (a) values ('1:00:00 PM');
insert into jorge_time2 (a) values (time'2:00:00 PM');
select * from jorge_time2;
insert into jorge_time2 (a) values (1:00:00 pm);
rollback;
