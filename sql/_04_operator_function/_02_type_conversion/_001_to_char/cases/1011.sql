-- create class to test to_char on a used class name

create class func_04 ( a timestamp , b date, c time );
insert into func_04 values( '00:00:01 01/01/1971', '01/01/1970', '01:02:03');
insert into func_04 values( '03:14:07 01/01/2038', '01/01/2038', '01:02:03');
insert into func_04 values( '01:02:03 am 01/01/1980', '01/01/1980', '01:02:03 am');
insert into func_04 values( '01:02:03 pm 01/01/1980', '01/01/1980', '01:02:03 pm');
insert into func_04 values( '12:00:00 pm 01/01/1980', '01/01/1980', '12:00:00 pm');
insert into func_04 values( '12:00:00 am 01/01/1980', '12/31/1980', '12:00:00 am');
insert into func_04 values( null , null, null);

select a,to_char(a,'CC YYYY YY Q MM MONTH MON DD DAY DY D AM PM A.M. P.M. HH HH12 HH24 MI SS') from  func_04 order by 1	;
select a,to_char(a,'cc yyyy yy q mm month mon dd day dy d am pm a.m. p.m. hh hh12 hh24 mi ss') from  func_04 order by 1	;
select b,to_char(b,'CC YYYY YY Q MM MONTH MON DD DAY DY D') from  func_04 order by 1	;
select b,to_char(b,'cc yyyy yy q mm month mon dd day dy d') from  func_04 order by 1;


drop class func_04;