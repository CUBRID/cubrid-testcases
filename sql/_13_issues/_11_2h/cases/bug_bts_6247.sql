--zero datetime
select datetime'2011-11-11 11:11:11' - datetime'0000-00-00 00:00:00';
select datetime'2011-11-11 11:11:11' - '0000-00-00 00:00:00';

select datetime'00/00/0000 00:00:00' - '1878-11-29';
select datetime'00/00/0000 00:00:00.000' - date'1878-11-29';
select '0000-00-00 00:00:00.000' - timestamp'00/00/0000 00:00:00';
select '0000-00-00 00:00:00.000' - date'1778-02-19';
select datetime'2011-11-11 11:11:11' + datetime'0000-00-00 00:00:00';
select datetime'2011-11-11 11:11:11' + '0000-00-00 00:00:00';
select datetime'00/00/0000 00:00:00' + '1878-11-29';
select datetime'00/00/0000 00:00:00.000' + date'1878-11-29';
select '0000-00-00 00:00:00.000' + timestamp'00/00/0000 00:00:00';
select '0000-00-00 00:00:00.000' + date'1778-02-19';



--zero timestamp
--Notice: local timezone: KST
select timestamp'2011-11-11 11:11:11' - timestamp'0000-00-00 00:00:00';
select timestamp'2011-11-11 11:11:11' - timestamp'1970-01-01 09:00:00';
select timestamp'0000-00-00 00:00:00' - '1989-12-12 3:4:5';
select timestamp'1970-01-01 09:00:00' - '0000-00-00';
select date'1776-01-28' - '0000-00-00 00:00:00';
select datetime'00/00/0000 00:00:00.000' - '1970-01-01 09:00:00';
select timestamp'2011-11-11 11:11:11' + timestamp'0000-00-00 00:00:00';
select timestamp'2011-11-11 11:11:11' + timestamp'1970-01-01 09:00:00';
select timestamp'0000-00-00 00:00:00' + '1989-12-12 3:4:5';
select timestamp'1970-01-01 09:00:00' + '0000-00-00';
select date'1776-01-28' + '0000-00-00 00:00:00';
select datetime'00/00/0000 00:00:00.000' + '1970-01-01 09:00:00';




--zero date
select date'2011-11-11' - date'00/00/0000';
select date'0000-00-00' - date'01/01/2000';
select date'0000-00-00' - timestamp'1989-12-12 3:4:5';
select date'0000-00-00' - '2022-10-21 12:12:12.123';
select datetime'2022-10-21 12:12:12.123' - '00/00/0000';
select '00/00/0000' - date'1999-10-10';
select date'2011-11-11' + date'00/00/0000';
select date'0000-00-00' + date'01/01/2000';
select date'0000-00-00' + timestamp'1989-12-12 3:4:5';
select date'0000-00-00' + '2022-10-21 12:12:12.123';
select datetime'2022-10-21 12:12:12.123' + '00/00/0000';
select '00/00/0000' + date'1999-10-10';



--server side
create table dttest (dt datetime, ts timestamp, d date, i int);
insert into dttest values ('0000-00-00 00:00:00', '2011-11-11 01:02:03', '2011-11-11', 0);
insert into dttest values ('2011-11-11 01:02:03', '0000-00-00 00:00:00', '2011-11-11', 1);
insert into dttest values ('2011-11-11 01:02:03', '2011-11-11 01:02:03', '0000-00-00', 2);
select * from dttest order by 4;
select i, dt-ts, dt-d, ts-d, dt-i, ts-i, d-i from dttest;
select i, dt+i, ts+i, d+i from dttest;

drop table dttest;




select datetime'0000-00-00 00:00:00' -1;
select datetime'0000-00-00 00:00:00' + 1;
select timestamp'0000-00-00 00:00:00' + 1;
select date'0000-00-00' + 1;
select date'0000-00-00' - 1;


select 128323 - datetime'0000-00-00 00:00:00';
select datetime'0000-00-00 00:00:00' + 300;
select timestamp'0000-00-00 00:00:00' - 125465;
select timestamp'0000-00-00 00:00:00' + 12222;
select date'0000-00-00' + 366;
select 48292834 - date'0000-00-00';







