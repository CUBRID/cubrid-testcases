-- create serial and table which insert data into using data type of string and int and test "day" in function of to_timestamp using parameter of selected format and 'En_US' and then dorp table and serial 

create table day_test (
       u_day string,
       u_format string,
       lang string,
       ord int );

create serial ord start with 1 nocycle;

insert into day_test values ('2006-02-06-MONDAY 16:25','yyyy-mm-dd-DAY HH24:MI','En_US',ord.NEXT_VALUE);
insert into day_test values ('2006-02-07-TUESDAY 15:25','yyyy-mm-dd-DAY HH24:MI','En_US',ord.NEXT_VALUE);
insert into day_test values ('2006-02-08-WEDNESDAY 14:25','yyyy-mm-dd-DAY HH24:MI','En_US',ord.NEXT_VALUE);
insert into day_test values ('2006-02-09-THURSDAY 13:25','yyyy-mm-dd-DAY HH24:MI','En_US',ord.NEXT_VALUE);
insert into day_test values ('2006-02-10-FRIDAY 12:25','yyyy-mm-dd-DAY HH24:MI','En_US',ord.NEXT_VALUE);
insert into day_test values ('2006-02-11-SATURDAY 11:25','yyyy-mm-dd-DAY HH24:MI','En_US',ord.NEXT_VALUE);
insert into day_test values ('2006-02-12-SUNDAY 10:25','yyyy-mm-dd-DAY HH24:MI','En_US',ord.NEXT_VALUE);
insert into day_test values ('2006-02-06-Monday 09:25','yyyy-mm-dd-Day HH24:MI','En_US',ord.NEXT_VALUE);
insert into day_test values ('2006-02-07-Tuesday 08:25','yyyy-mm-dd-Day HH24:MI','En_US',ord.NEXT_VALUE);
insert into day_test values ('2006-02-08-Wednesday 07:25','yyyy-mm-dd-Day HH24:MI','En_US',ord.NEXT_VALUE);
insert into day_test values ('2006-02-09-Thursday 06:25','yyyy-mm-dd-Day HH24:MI','En_US',ord.NEXT_VALUE);
insert into day_test values ('2006-02-10-Friday 5:25','yyyy-mm-dd-Day HH24:MI','En_US',ord.NEXT_VALUE);
insert into day_test values ('2006-02-11-Saturday 4:25','yyyy-mm-dd-Day HH24:MI','En_US',ord.NEXT_VALUE);
insert into day_test values ('2006-02-12-Sunday 13:25','yyyy-mm-dd-Day HH24:MI','En_US',ord.NEXT_VALUE);
insert into day_test values ('2006-02-06-monday 17:25','yyyy-mm-dd-day HH24:MI','En_US',ord.NEXT_VALUE);
insert into day_test values ('2006-02-07-tuesday 19:25','yyyy-mm-dd-day HH24:MI','En_US',ord.NEXT_VALUE);
insert into day_test values ('2006-02-08-wednesday 23:25','yyyy-mm-dd-day HH24:MI','En_US',ord.NEXT_VALUE);
insert into day_test values ('2006-02-09-thursday 22:25','yyyy-mm-dd-day HH24:MI','En_US',ord.NEXT_VALUE);
insert into day_test values ('2006-02-10-friday 21:25','yyyy-mm-dd-day HH24:MI','En_US',ord.NEXT_VALUE);
insert into day_test values ('2006-02-11-saturday 20:25','yyyy-mm-dd-day HH24:MI','En_US',ord.NEXT_VALUE);
insert into day_test values ('2006-02-12-sunday 10:25','yyyy-mm-dd-day HH24:MI','En_US',ord.NEXT_VALUE);
insert into day_test values ('2006-02-06-MON 17:25','yyyy-mm-dd-DY HH24:MI','En_US',ord.NEXT_VALUE);
insert into day_test values ('2006-02-07-TUE 18:25','yyyy-mm-dd-DY HH24:MI','En_US',ord.NEXT_VALUE);
insert into day_test values ('2006-02-08-WED 19:25','yyyy-mm-dd-DY HH24:MI','En_US',ord.NEXT_VALUE);
insert into day_test values ('2006-02-09-THU 20:25','yyyy-mm-dd-DY HH24:MI','En_US',ord.NEXT_VALUE);
insert into day_test values ('2006-02-10-FRI 17:25','yyyy-mm-dd-DY HH24:MI','En_US',ord.NEXT_VALUE);
insert into day_test values ('2006-02-11-SAT 18:25','yyyy-mm-dd-DY HH24:MI','En_US',ord.NEXT_VALUE);
insert into day_test values ('2006-02-12-SUN 19:25','yyyy-mm-dd-DY HH24:MI','En_US',ord.NEXT_VALUE);
insert into day_test values ('2006-02-06-Mon 11:25','yyyy-mm-dd-Dy HH24:MI','En_US',ord.NEXT_VALUE);
insert into day_test values ('2006-02-07-Tue 10:25','yyyy-mm-dd-Dy HH24:MI','En_US',ord.NEXT_VALUE);
insert into day_test values ('2006-02-08-Wed 09:25','yyyy-mm-dd-Dy HH24:MI','En_US',ord.NEXT_VALUE);
insert into day_test values ('2006-02-09-Thu 10:25','yyyy-mm-dd-Dy HH24:MI','En_US',ord.NEXT_VALUE);
insert into day_test values ('2006-02-10-Fri 15:25','yyyy-mm-dd-Dy HH24:MI','En_US',ord.NEXT_VALUE);
insert into day_test values ('2006-02-11-Sat 16:25','yyyy-mm-dd-Dy HH24:MI','En_US',ord.NEXT_VALUE);
insert into day_test values ('2006-02-12-Sun 17:25','yyyy-mm-dd-Dy HH24:MI','En_US',ord.NEXT_VALUE);
insert into day_test values ('2006-02-06-mon 19:25','yyyy-mm-dd-dy HH24:MI','En_US',ord.NEXT_VALUE);
insert into day_test values ('2006-02-07-tue 17:25','yyyy-mm-dd-dy HH24:MI','En_US',ord.NEXT_VALUE);
insert into day_test values ('2006-02-08-wed 23:25','yyyy-mm-dd-dy HH24:MI','En_US',ord.NEXT_VALUE);
insert into day_test values ('2006-02-09-thu 17:25','yyyy-mm-dd-dy HH24:MI','En_US',ord.NEXT_VALUE);
insert into day_test values ('2006-02-10-fri 19:25','yyyy-mm-dd-dy HH24:MI','En_US',ord.NEXT_VALUE);
insert into day_test values ('2006-02-11-sat 21:25','yyyy-mm-dd-dy HH24:MI','En_US',ord.NEXT_VALUE);
insert into day_test values ('2006-02-12-sun 20:25','yyyy-mm-dd-dy HH24:MI','En_US',ord.NEXT_VALUE);
select u_day, u_format, to_timestamp(u_day,u_format,'En_US') 
from day_test where lang = 'En_US' order by ord;


drop table day_test;
drop serial ord;