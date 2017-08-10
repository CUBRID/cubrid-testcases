-- create serial and table which insert data into using data type of string and int and test "day" in function of to_timestamp using parameter of selected format and 'Ko_KR' and then dorp table and serial 

create table day_test (
       u_day string,
       u_format string,
       lang string,
       ord int );

create serial ord start with 1 nocycle;
insert into day_test values ('2006-04-03-??? 15:17','yyyy-mm-dd-DAY HH24:MI','Ko_KR',ord.NEXT_VALUE);
insert into day_test values ('2006-04-04-??? 16:17','yyyy-mm-dd-DAY HH24:MI','Ko_KR',ord.NEXT_VALUE);
insert into day_test values ('2006-04-05-??? 14:17','yyyy-mm-dd-DAY HH24:MI','Ko_KR',ord.NEXT_VALUE);
insert into day_test values ('2006-04-06-??? 20:17','yyyy-mm-dd-DAY HH24:MI','Ko_KR',ord.NEXT_VALUE);
insert into day_test values ('2006-04-07-??? 21:17','yyyy-mm-dd-DAY HH24:MI','Ko_KR',ord.NEXT_VALUE);
insert into day_test values ('2006-04-08-??? 22:17','yyyy-mm-dd-DAY HH24:MI','Ko_KR',ord.NEXT_VALUE);
insert into day_test values ('2006-04-09-??? 23:17','yyyy-mm-dd-DAY HH24:MI','Ko_KR',ord.NEXT_VALUE);
insert into day_test values ('2006-04-03-??? 14:17','yyyy-mm-dd-Day HH24:MI','Ko_KR',ord.NEXT_VALUE);
insert into day_test values ('2006-04-04-??? 08:17','yyyy-mm-dd-Day HH24:MI','Ko_KR',ord.NEXT_VALUE);
insert into day_test values ('2006-04-05-??? 07:17','yyyy-mm-dd-Day HH24:MI','Ko_KR',ord.NEXT_VALUE);
insert into day_test values ('2006-04-06-??? 03:17','yyyy-mm-dd-Day HH24:MI','Ko_KR',ord.NEXT_VALUE);
insert into day_test values ('2006-04-07-??? 23:17','yyyy-mm-dd-Day HH24:MI','Ko_KR',ord.NEXT_VALUE);
insert into day_test values ('2006-04-08-??? 09:17','yyyy-mm-dd-Day HH24:MI','Ko_KR',ord.NEXT_VALUE);
insert into day_test values ('2006-04-09-??? 11:17','yyyy-mm-dd-Day HH24:MI','Ko_KR',ord.NEXT_VALUE);
insert into day_test values ('2006-04-03-??? 12:17','yyyy-mm-dd-day HH24:MI','Ko_KR',ord.NEXT_VALUE);
insert into day_test values ('2006-04-04-??? 14:17','yyyy-mm-dd-day HH24:MI','Ko_KR',ord.NEXT_VALUE);
insert into day_test values ('2006-04-05-??? 15:17','yyyy-mm-dd-day HH24:MI','Ko_KR',ord.NEXT_VALUE);
insert into day_test values ('2006-04-06-??? 13:17','yyyy-mm-dd-day HH24:MI','Ko_KR',ord.NEXT_VALUE);
insert into day_test values ('2006-04-07-??? 12:17','yyyy-mm-dd-day HH24:MI','Ko_KR',ord.NEXT_VALUE);
insert into day_test values ('2006-04-08-??? 20:17','yyyy-mm-dd-day HH24:MI','Ko_KR',ord.NEXT_VALUE);
insert into day_test values ('2006-04-09-??? 21:17','yyyy-mm-dd-day HH24:MI','Ko_KR',ord.NEXT_VALUE);
insert into day_test values ('2006-04-03-? 22:18','yyyy-mm-dd-DY hh24:mi','Ko_KR',ord.NEXT_VALUE);
insert into day_test values ('2006-04-04-? 23:18','yyyy-mm-dd-DY hh24:mi','Ko_KR',ord.NEXT_VALUE);
insert into day_test values ('2006-04-05-? 14:18','yyyy-mm-dd-DY hh24:mi','Ko_KR',ord.NEXT_VALUE);
insert into day_test values ('2006-04-06-? 13:18','yyyy-mm-dd-DY hh24:mi','Ko_KR',ord.NEXT_VALUE);
insert into day_test values ('2006-04-07-? 12:18','yyyy-mm-dd-DY hh24:mi','Ko_KR',ord.NEXT_VALUE);
insert into day_test values ('2006-04-08-? 11:18','yyyy-mm-dd-DY hh24:mi','Ko_KR',ord.NEXT_VALUE);
insert into day_test values ('2006-04-09-? 17:18','yyyy-mm-dd-DY hh24:mi','Ko_KR',ord.NEXT_VALUE);
insert into day_test values ('2006-04-03-? 18:18','yyyy-mm-dd-Dy hh24:mi','Ko_KR',ord.NEXT_VALUE);
insert into day_test values ('2006-04-04-? 17:18','yyyy-mm-dd-Dy hh24:mi','Ko_KR',ord.NEXT_VALUE);
insert into day_test values ('2006-04-05-? 19:18','yyyy-mm-dd-Dy hh24:mi','Ko_KR',ord.NEXT_VALUE);
insert into day_test values ('2006-04-06-? 14:18','yyyy-mm-dd-Dy hh24:mi','Ko_KR',ord.NEXT_VALUE);
insert into day_test values ('2006-04-07-? 12:18','yyyy-mm-dd-Dy hh24:mi','Ko_KR',ord.NEXT_VALUE);
insert into day_test values ('2006-04-08-? 11:18','yyyy-mm-dd-Dy hh24:mi','Ko_KR',ord.NEXT_VALUE);
insert into day_test values ('2006-04-09-? 17:18','yyyy-mm-dd-Dy hh24:mi','Ko_KR',ord.NEXT_VALUE);
insert into day_test values ('2006-04-03-? 18:18','yyyy-mm-dd-dy hh24:mi','Ko_KR',ord.NEXT_VALUE);
insert into day_test values ('2006-04-04-? 19:18','yyyy-mm-dd-dy hh24:mi','Ko_KR',ord.NEXT_VALUE);
insert into day_test values ('2006-04-05-? 21:18','yyyy-mm-dd-dy hh24:mi','Ko_KR',ord.NEXT_VALUE);
insert into day_test values ('2006-04-06-? 23:18','yyyy-mm-dd-dy hh24:mi','Ko_KR',ord.NEXT_VALUE);
insert into day_test values ('2006-04-07-? 14:18','yyyy-mm-dd-dy hh24:mi','Ko_KR',ord.NEXT_VALUE);
insert into day_test values ('2006-04-08-? 12:18','yyyy-mm-dd-dy hh24:mi','Ko_KR',ord.NEXT_VALUE);
insert into day_test values ('2006-04-09-? 17:18','yyyy-mm-dd-dy hh24:mi','Ko_KR',ord.NEXT_VALUE);

select u_day, u_format, to_timestamp(u_day,u_format,'Ko_KR') 
from day_test where lang = 'Ko_KR' order by ord;


drop table day_test;
drop serial ord;