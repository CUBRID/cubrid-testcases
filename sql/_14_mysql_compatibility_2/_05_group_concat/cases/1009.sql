--+ holdcas on;
-- result truncation with variable and fixed char

-- var char
create table tab1 (name char varying(10), i int);
insert into tab1 values('1234567890',10);
insert into tab1 values('1234',4);
insert into tab1 values('1234',4);
insert into tab1 values('1234567890',10);
insert into tab1 values('12345',5);
insert into tab1 values('12345',5);
insert into tab1 values('123456',6);
insert into tab1 values('123456',6);
insert into tab1 values('1234',4);

set system parameters 'error_log_level=warning';

set system parameters 'group_concat_max_len=13';

select i,count(name),group_concat(name order by 1 separator '+') from tab1 group by i order by 1;

set system parameters 'group_concat_max_len=1024';

select i,count(name),group_concat(name order by 1 separator '+') from tab1 group by i order by 1;

drop table tab1;



-- fixed char
create table tab1 (name char (10), i int);
insert into tab1 values('1234567890',10);
insert into tab1 values('1234',4);
insert into tab1 values('1234',4);
insert into tab1 values('1234567890',10);
insert into tab1 values('12345',5);
insert into tab1 values('12345',5);
insert into tab1 values('123456',6);
insert into tab1 values('123456',6);
insert into tab1 values('1234',4);

set system parameters 'error_log_level=warning';

set system parameters 'group_concat_max_len=13';

select i,count(name),group_concat(name order by 1 separator '+') from tab1 group by i order by 1;

set system parameters 'group_concat_max_len=1024';

select i,count(name),group_concat(name order by 1 separator '+') from tab1 group by i order by 1;

drop table tab1;


commit;
--+ holdcas off;
