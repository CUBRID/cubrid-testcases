autocommit off;
set names utf8;
create table test_to_time(
			to_time_1_1 varchar(50)
)  ;
insert into test_to_time (to_time_1_1) values ('9/6/1976');
		select to_time('10:30:20 am') from test_to_time;
			select to_time('AM','am') from test_to_time;
			select to_time('PM','am') from test_to_time;
			select to_time('am','AM') from test_to_time;
			select to_time('pm','AM') from test_to_time;
			select to_time('A.M.','a.m.') from test_to_time;
			select to_time('P.M.','a.m.') from test_to_time;
			select to_time('a.m.','A.M.') from test_to_time;
			select to_time('p.m.','A.M.') from test_to_time;
			select to_time('AM','pm') from test_to_time;
			select to_time('PM','pm') from test_to_time;
			select to_time('am','PM') from test_to_time;
			select to_time('pm','PM') from test_to_time;
			select to_time('A.M.','p.m.') from test_to_time;
			select to_time('P.M.','p.m.') from test_to_time;
			select to_time('a.m.','P.M.') from test_to_time;
			select to_time('p.m.','P.M.') from test_to_time;
			select to_time('10','hH') from test_to_time;
			select to_time('10','hH24') from test_to_time;
			select to_time('30','mI') from test_to_time;
			select to_time('20','sS') from test_to_time;
			select to_time(' ',' ') from test_to_time; 
			select to_time('	','	') from test_to_time;
			select to_time('					','					') from test_to_time; 
			select to_time('-','-') from test_to_time;
			select to_time('/','/') from test_to_time;
			select to_time(',',',') from test_to_time;
			select to_time('.','.') from test_to_time;
			select to_time(';',';') from test_to_time;
			select to_time(':',':') from test_to_time;
			select to_time('a','"a"') from test_to_time; 
			select to_time('10占쏙옙30占쏙옙20占쏙옙','hh24"占쏙옙"mi"占쏙옙"ss"占쏙옙"') from test_to_time;
			select to_time('10占쏙옙 30占쏙옙 20占쏙옙','hh24"占쏙옙"mi"占쏙옙"ss"占쏙옙"') from test_to_time;
			select to_time('10占쏙옙	30占쏙옙	20占쏙옙','hh24"占쏙옙"mi"占쏙옙"ss"占쏙옙"') from test_to_time;
			select to_time('10占쏙옙					30占쏙옙20占쏙옙','hh24"占쏙옙"mi"占쏙옙"ss"占쏙옙"') from test_to_time;
		
create table test_to_time_table(
	c1 varchar(500),
	c2 varchar(500),
	c3 varchar(500),
	c4 varchar(500)
) charset utf8 ;
insert into test_to_time_table (c1,c2,c3) values('12占쏙옙 30占쏙옙 20占쏙옙 pm','HH"占쏙옙" MI"占쏙옙" SS"占쏙옙" a.m.','12:30:20 pm');
		SELECT c3, to_time( c3) FROM test_to_time_table;
		SELECT c1,'HH"占쏙옙" MI"占쏙옙" SS"占쏙옙" a.m.', to_time( cast (c1 as string charset utf8),'HH"占쏙옙" MI"占쏙옙" SS"占쏙옙" a.m.') FROM test_to_time_table;
		SELECT '12占쏙옙 30占쏙옙 20占쏙옙 pm',c2, to_time( '12占쏙옙 30占쏙옙 20占쏙옙 pm',c2) FROM test_to_time_table;
		SELECT c1,c2, to_time( c1,c2) FROM test_to_time_table;
		SELECT c4, to_time( c4) FROM test_to_time_table;
		SELECT c1,c4, to_time( c1,c4) FROM test_to_time_table;
		SELECT c4,c2, to_time( c4,c2) FROM test_to_time_table;
		SELECT c4,c4, to_time( c4,c4) FROM test_to_time_table;
		select to_time(NULL) from test_to_time;
		select to_time(NULL,NULL) from test_to_time;
drop table test_to_time;
drop table test_to_time_table;
		
		
rollback;
set names iso88591;
