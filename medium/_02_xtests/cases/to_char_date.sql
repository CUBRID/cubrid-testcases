--+ holdcas on;
autocommit off;
set names utf8;
create table test_to_char(
			to_char_1_1 varchar(50),
			to_char_1_2 varchar(50),
			to_char_1_3 varchar(50),
			to_char_1_4 varchar(50),
			to_char_1_5 varchar(50),
			to_char_2_1_1 varchar(50),
			to_char_2_1_2 varchar(50),
			to_char_2_1_3 varchar(50),
			to_char_2_1_4 varchar(50),
			to_char_2_2_1 varchar(50),
			to_char_2_2_2 varchar(50),
			to_char_2_2_3 varchar(50),
			to_char_2_2_4 varchar(50),
			to_char_2_3 varchar(50)
) charset euckr;
insert into test_to_char (to_char_1_1,to_char_1_2,to_char_1_3,to_char_1_4,to_char_2_1_1,to_char_2_1_2,to_char_2_1_3,to_char_2_1_4,to_char_2_2_1,to_char_2_2_2,to_char_2_2_3,to_char_2_2_4,to_char_2_3) values ('   占쌍곤옙占쏙옙 ','   Korea Computer & Communication ','   ','','占쌍곤옙占쏙옙 ','   占쌍곤옙占쏙옙 ','   占쌍곤옙占쏙옙 ','   占쌍곤옙占쏙옙 ','Korea Computer & Communication',' Korea Computer & Communication',' Korea Computer & Communication',' Korea Computer & Communication','c 占쏙옙h占쏙옙 占쏙옙 ');
		select to_char(DATE '9/6/1976') from test_to_char;
		select to_char(TIME '14:30:30') from test_to_char;
		select to_char(TIMESTAMP '14:30:30 9/6/1976') from test_to_char;
		select to_char(DATE '9/6/1976','cc yyyy yy q mm month Month MONTH mon Mon MON dd day Day DAY dy Dy DY - / , . ; : "ebebe"' ) from test_to_char;
			select to_char(TIME '10:30:40','am Am AM a.m. A.m. A.M. pm Pm PM p.m. P.m. P.M. hh hh12 hh24 mi ss - / , . , ; : "Text...." "트" "Space" "Space" "Tab"      "Tab" "Enter"	"Enter"') from test_to_char;
		select to_char(TIMESTAMP '10:30:40 am 9/6/1976','cc yyyy yy q mm month Month MONTH mon Mon MON dd day dy am Am AM a.m. A.m. A.M. pm Pm PM p.m. P.m. P.M.  hh hh12 hh24 mi ss - / , . , ; : "Text...." "占쌔쏙옙트" "Space" "Space" "Tab" "Tab" "Enter" "Enter"') from test_to_char;
			select to_char(DATE '9/6/1976',' ') from test_to_char;
			select to_char(TIME '14:30:30',' ') from test_to_char;
			select to_char(TIMESTAMP '14:30:30 9/6/1976',' ') from test_to_char;
create table test_to_char_table(
    d1 timestamp,
    c2 varchar(500),
    d3 timestamp,
    c4 varchar(500)
) charset euckr;
insert into test_to_char_table (d1,c2) values(TIMESTAMP '10:30:20 9/6/1976','cc yyyy yy q mm month Month MONTH mon Mon MON dd day dy am Am AM a.m. A.m. A.M. pm Pm PM p.m. P.m. P.M.  hh hh12 hh24 mi ss - / , . , ; : "Text...." "占쌔쏙옙트" "Space" "Space" "Tab" "Tab" "Enter"	"Enter"');
    
		SELECT d1, to_char( d1) FROM test_to_char_table;
		SELECT d1,'cc yyyy yy q mm month Month MONTH mon Mon MON dd day dy am Am AM a.m. A.m. A.M. pm Pm PM p.m. P.m. P.M.  hh hh12 hh24 mi ss - / , . , ; : "Text...." "占쌔쏙옙트" "Space" "Space" "Tab" "Tab" "Enter" "Enter"', to_char( d1,'cc yyyy yy q mm month Month MONTH mon Mon MON dd day dy am Am AM a.m. A.m. A.M. pm Pm PM p.m. P.m. P.M.  hh hh12 hh24 mi ss - / , . , ; : "Text...." "占쌔쏙옙트" "Space" "Space" "Tab" "Tab" "Enter" "Enter"') FROM test_to_char_table;
		SELECT TIMESTAMP '10:30:20 9/6/1976',c2, to_char( TIMESTAMP '10:30:20 9/6/1976',c2) FROM test_to_char_table;
		SELECT d1,c2, to_char( d1,c2) FROM test_to_char_table;
		SELECT d3, to_char( d3) FROM test_to_char_table;
		SELECT d1,c4, to_char( d1,c4) FROM test_to_char_table;
		SELECT d3,c2, to_char( d3,c2) FROM test_to_char_table;
		SELECT d3,c4, to_char( d3,c4) FROM test_to_char_table;
		select to_char(NULL) from test_to_char;
		select to_char(NULL,NULL) from test_to_char;
drop table test_to_char;
drop table test_to_char_table;
		
set names iso88591;		
rollback;

--+ holdcas off;
