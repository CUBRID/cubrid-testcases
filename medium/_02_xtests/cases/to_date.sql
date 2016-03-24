autocommit off;
create table test_to_date(
			to_date_1_1 varchar(50)
);
insert into test_to_date (to_date_1_1) values ('9/6/1976');
		select to_date('9/6/1976') from test_to_date;
			select extract(year from to_date('1976','yYyy')) from test_to_date;
			select extract(month from to_date('1976','yYyy')) - extract(month from sys_date) from test_to_date;
			select extract(day from to_date('1976','yYyy')) from test_to_date;
			select extract(year from to_date('76','yY')) from test_to_date;
			select extract(month from to_date('76','yY')) - extract(month from sys_date) from test_to_date;
			select extract(day from to_date('76','yY')) from test_to_date;
			select extract(year from to_date('9','Mm')) - extract(year from sys_date) from test_to_date;
			select extract(month from  to_date('9','Mm'))  from test_to_date;
			select extract(day from to_date('9','Mm'))   from test_to_date;
			select extract(year from to_date('sepTEMBER','MONTH')) - extract(year from sys_date) from test_to_date;
			select extract(month from to_date('sepTEMBER','MONTH'))  from test_to_date;
			select extract(day from to_date('sepTEMBER','MONTH')) from test_to_date;
			select extract(year from to_date('sep','MON')) - extract(year from sys_date) from test_to_date;
			select extract(month from to_date('sep','MON'))  from test_to_date;
			select extract(day from to_date('sep','MON'))  from test_to_date;
			select extract(year from to_date('25','dD')) - extract(year from sys_date) from test_to_date;
			select extract(month from to_date('25','dD')) - extract(month from sys_date) from test_to_date;
			select extract(day from to_date('25','dD')) from test_to_date;
			select to_date(' ',' ') - to_date(to_char(sys_date,'mm')+'/1/'+to_char(sys_date,'yyyy')) from test_to_date; 
			select to_date('	','	') - to_date(to_char(sys_date,'mm')+'/1/'+to_char(sys_date,'yyyy'))from test_to_date; 
			select to_date('					','					') - to_date(to_char(sys_date,'mm')+'/1/'+to_char(sys_date,'yyyy'))from test_to_date;
			select to_date('-','-') - to_date(to_char(sys_date,'mm')+'/1/'+to_char(sys_date,'yyyy'))from test_to_date;
			select to_date('/','/') - to_date(to_char(sys_date,'mm')+'/1/'+to_char(sys_date,'yyyy'))from test_to_date;
			select to_date(',',',') - to_date(to_char(sys_date,'mm')+'/1/'+to_char(sys_date,'yyyy'))from test_to_date;
			select to_date('.','.') - to_date(to_char(sys_date,'mm')+'/1/'+to_char(sys_date,'yyyy'))from test_to_date;
			select to_date(';',';') - to_date(to_char(sys_date,'mm')+'/1/'+to_char(sys_date,'yyyy'))from test_to_date;
			select to_date(':',':') - to_date(to_char(sys_date,'mm')+'/1/'+to_char(sys_date,'yyyy'))from test_to_date;
			select to_date('a','"a"') - to_date(to_char(sys_date,'mm')+'/1/'+to_char(sys_date,'yyyy'))from test_to_date;

		
create table test_to_date_table(
	c1 varchar(500),
	c2 varchar(500),
	c3 varchar(500),
	c4 varchar(500)
);

		SELECT c3, to_date( c3) FROM test_to_date_table;

		SELECT c1,c2, to_date( c1,c2) FROM test_to_date_table;
		SELECT c4, to_date( c4) FROM test_to_date_table;
		SELECT c1,c4, to_date( c1,c4) FROM test_to_date_table;
		SELECT c4,c2, to_date( c4,c2) FROM test_to_date_table;
		SELECT c4,c4, to_date( c4,c4) FROM test_to_date_table;
		select to_date(NULL) from test_to_date;
		select to_date(NULL,NULL) from test_to_date;
drop table test_to_date;
drop table test_to_date_table;
		
		
rollback;
