autocommit off;
set names utf8;
create table dual (
	dummy varchar(1)
) charset euckr;
insert into dual values ('X');
create table test_to_char_from_date (
	type_char char(10),
	type_varchar varchar(10),
	type_nchar nchar(10),
	type_nchar_varying nchar varying(10),
	type_date date,
	type_time time,
	type_timestamp timestamp
) charset euckr;
select to_char(DATE '9/6/1976','cc yyyy yy q mm month Month MONTH mon Mon MON dd day Day DAY dy Dy DY - / , . ; : "ebebe"' ) from dual;
select to_char(TIME '10:30:40','am Am AM a.m. A.m. A.M. pm Pm PM p.m. P.m. P.M. hh hh12 hh24 mi ss - / , . , ; : "Text...." "" "Space" "Space" "Tab"      "Tab" "Enter"		"Enter"') from dual;
select to_char(TIMESTAMP '10:30:40 am 9/6/1976','cc yyyy yy q mm month Month MONTH mon Mon MON dd day dy am Am AM a.m. A.m. A.M. pm Pm PM p.m. P.m. P.M.  hh hh12 hh24 mi ss - / , . , ; : "Text" "占쌔쏙옙트" "Space" "Space" "Tab" "Tab" "Enter" "Enter"') from dual;

select to_char(DATE '11/11/1994',' ') from dual;
select to_char(DATE '11/11/1994',' ') from dual;

insert into test_to_char_from_date (type_date) values (DATE '9/6/1976');
select type_date,to_char(type_date,' ') from test_to_char_from_date;
select type_date,to_char(type_date,' 	') from test_to_char_from_date;

select to_char(DATE '9/6/1976') from dual;
select to_char(TIME '14:30:30') from dual;
select to_char(TIMESTAMP '14:30:30 9/6/1976') from dual;
drop table dual;
drop table test_to_char_from_date;
set names iso88591;
rollback;
