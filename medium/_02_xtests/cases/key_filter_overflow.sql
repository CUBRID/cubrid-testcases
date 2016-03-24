autocommit off;
create table key_filter_overflow(s varchar(10), t varchar(10));
insert into key_filter_overflow values('0', '0');
insert into key_filter_overflow values('1', '1');
insert into key_filter_overflow values('2', '2');
insert into key_filter_overflow values('3', '3');
insert into key_filter_overflow values('4', '4');
insert into key_filter_overflow values('5', '5');
insert into key_filter_overflow values('6', '6');
insert into key_filter_overflow values('7', '7');
insert into key_filter_overflow values('8', '8');
insert into key_filter_overflow values('9', '9');
insert into key_filter_overflow select * from key_filter_overflow;
insert into key_filter_overflow select * from key_filter_overflow;
insert into key_filter_overflow select * from key_filter_overflow;
insert into key_filter_overflow select * from key_filter_overflow;
insert into key_filter_overflow select * from key_filter_overflow;
insert into key_filter_overflow select * from key_filter_overflow;
insert into key_filter_overflow select * from key_filter_overflow;
insert into key_filter_overflow select * from key_filter_overflow;
insert into key_filter_overflow select * from key_filter_overflow;
create index i_key_filter_overflow_s_t on key_filter_overflow(s, t);
--set optimization: level 257;
--set optimization: cost 'iscan' 0;
select s, count(*)
from key_filter_overflow
where s < '2' and t = '1'
group by s;
select s, count(*)
from key_filter_overflow
where s > '2' and t > '6'
group by s;
rollback;
