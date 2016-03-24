autocommit off;
set names utf8;
create table test_to_timestamp(
			to_timestamp_1_1 varchar(50)
);
insert into test_to_timestamp (to_timestamp_1_1) values ('9/6/1976');
		select to_timestamp('10:30:20 am 9/6/1976') from test_to_timestamp;
			select cast(to_timestamp('AM','am') as time) from test_to_timestamp;
			select cast(to_timestamp('PM','am') as time)from test_to_timestamp;
			select cast(to_timestamp('am','AM') as time)from test_to_timestamp;
			select cast(to_timestamp('pm','AM') as time) from test_to_timestamp;
			select cast(to_timestamp('A.M.','a.m.') as time) from test_to_timestamp;
			select cast(to_timestamp('P.M.','a.m.') as time) from test_to_timestamp;
			select cast(to_timestamp('a.m.','A.M.') as time) from test_to_timestamp;
			select cast(to_timestamp('p.m.','A.M.') as time) from test_to_timestamp;
			select cast(to_timestamp('AM','pm') as time) from test_to_timestamp;
			select cast(to_timestamp('PM','pm') as time) from test_to_timestamp;
			select cast(to_timestamp('am','PM') as time) from test_to_timestamp;
			select cast(to_timestamp('pm','PM') as time) from test_to_timestamp;
			select cast(to_timestamp('A.M.','p.m.') as time) from test_to_timestamp;
			select cast(to_timestamp('P.M.','p.m.') as time) from test_to_timestamp;
			select cast(to_timestamp('a.m.','P.M.') as time) from test_to_timestamp;
			select cast(to_timestamp('p.m.','P.M.') as time) from test_to_timestamp;
			select cast(to_timestamp('10','hH') as time) from test_to_timestamp;
			select cast(to_timestamp('10','hH24') as time) from test_to_timestamp;
			select cast(to_timestamp('30','mI')  as time) from test_to_timestamp;
			select cast(to_timestamp('20','sS') as time) from test_to_timestamp;
            select extract(year from  to_timestamp('1976','yYyy')) from test_to_timestamp;
            select extract( year from  to_timestamp('16','yY')) from test_to_timestamp;
            select extract(month from  to_timestamp('9','Mm')) from test_to_timestamp;
            select extract(month from to_timestamp('sepTEMBER','MONTH')) from test_to_timestamp;
            select extract(month from to_timestamp('sep','mON')) from test_to_timestamp;
            select extract(day from to_timestamp('25','dD')) from test_to_timestamp;
			select cast(to_timestamp(' ',' ') as time) from test_to_timestamp; 
			select cast(to_timestamp('	','	') as time) from test_to_timestamp; 
			select cast(to_timestamp('					','					') as time) from test_to_timestamp; 
			select cast(to_timestamp('-','-') as time) from test_to_timestamp;
			select cast(to_timestamp('/','/') as time) from test_to_timestamp;
			select cast(to_timestamp(',',',') as time) from test_to_timestamp;
			select cast(to_timestamp('.','.') as time) from test_to_timestamp;
			select cast(to_timestamp(';',';') as time) from test_to_timestamp;
			select cast(to_timestamp(':',':') as time) from test_to_timestamp;
			select cast(to_timestamp('a','"a"') as time) from test_to_timestamp;
			select to_timestamp('16占쏙옙9占쏙옙6占쏙옙10占쏙옙20占쏙옙31占쏙옙','yy"占쏙옙"mm"占쏙옙"dd"占쏙옙"hh"占쏙옙"mi"占쏙옙"ss"占쏙옙"') from test_to_timestamp;
			select to_timestamp('16占쏙옙 9占쏙옙 6占쏙옙 10占쏙옙 20占쏙옙 31占쏙옙','yy"占쏙옙"mm"占쏙옙"dd"占쏙옙"hh"占쏙옙"mi"占쏙옙"ss"占쏙옙"') from test_to_timestamp;
			select to_timestamp('16占쏙옙	9占쏙옙6占쏙옙10占쏙옙20占쏙옙31占쏙옙','yy"占쏙옙"mm"占쏙옙"dd"占쏙옙"hh"占쏙옙"mi"占쏙옙"ss"占쏙옙"') from test_to_timestamp;
			select to_timestamp('16占쏙옙9占쏙옙6占쏙옙10占쏙옙20占쏙옙31占쏙옙','yy"占쏙옙"mm"占쏙옙"dd"占쏙옙"hh"占쏙옙"mi"占쏙옙"ss"占쏙옙"') from test_to_timestamp;
create table test_to_timestamp_table(
	c1 varchar(500),
	c2 varchar(500),
	c3 varchar(500),
	c4 varchar(500)
) charset utf8;
insert into test_to_timestamp_table (c1,c2,c3) values('16占쏙옙 9占쏙옙 6占쏙옙 10占쏙옙 20占쏙옙 31占쏙옙','yy"占쏙옙" mm"占쏙옙" dd"占쏙옙" hh"占쏙옙" mi"占쏙옙" ss"占쏙옙"','12:30:20 pm 9/6/1976');
		SELECT c3, to_timestamp(c3) FROM test_to_timestamp_table;
		SELECT c1,'yy"占쏙옙" mm"占쏙옙" dd"占쏙옙" hh"占쏙옙" mi"占쏙옙" ss"占쏙옙"', to_timestamp( cast (c1 as string charset utf8),'yy"占쏙옙" mm"占쏙옙" dd"占쏙옙" hh"占쏙옙" mi"占쏙옙" ss"占쏙옙"') FROM test_to_timestamp_table;
		SELECT '76占쏙옙 9占쏙옙 6占쏙옙 10占쏙옙 20占쏙옙 31占쏙옙',c2, to_timestamp( '16占쏙옙 9占쏙옙 6占쏙옙 10占쏙옙 20占쏙옙 31占쏙옙',c2) FROM test_to_timestamp_table;
		SELECT c1,c2, to_timestamp( c1,c2) FROM test_to_timestamp_table;
		SELECT c4, to_timestamp( c4) FROM test_to_timestamp_table;
		SELECT c1,c4, to_timestamp( c1,c4) FROM test_to_timestamp_table;
		SELECT c4,c2, to_timestamp( c4,c2) FROM test_to_timestamp_table;
		SELECT c4,c4, to_timestamp( c4,c4) FROM test_to_timestamp_table;
		select to_timestamp(NULL) from test_to_timestamp;
		select to_timestamp(NULL,NULL) from test_to_timestamp;
drop table test_to_timestamp;
drop table test_to_timestamp_table;
rollback;
