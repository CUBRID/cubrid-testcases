autocommit off;
set names utf8;
create table test_rtrim(
			rtrim_1_1 varchar(50),
			rtrim_1_2 varchar(50),
			rtrim_1_3 varchar(50),
			rtrim_1_4 varchar(50),
			rtrim_1_5 varchar(50),
			rtrim_2_1_1 varchar(50),
			rtrim_2_1_2 varchar(50),
			rtrim_2_1_3 varchar(50),
			rtrim_2_1_4 varchar(50),
			rtrim_2_2_1 varchar(50),
			rtrim_2_2_2 varchar(50),
			rtrim_2_2_3 varchar(50),
			rtrim_2_2_4 varchar(50),
			rtrim_2_3 varchar(50)
) charset euckr;
insert into test_rtrim (rtrim_1_1,rtrim_1_2,rtrim_1_3,rtrim_1_4,rtrim_2_1_1,rtrim_2_1_2,rtrim_2_1_3,rtrim_2_1_4,rtrim_2_2_1,rtrim_2_2_2,rtrim_2_2_3,rtrim_2_2_4,rtrim_2_3) values ('   최공훈 ','   Korea Computer & Communication ','   ','','최공훈 ','   최공훈 ','   최공훈 ','   최공훈 ','Korea Computer & Communication',' Korea Computer & Communication',' Korea Computer & Communication',' Korea Computer & Communication','c 최h공 훈 ');
			select rtrim('   최공훈 ') from test_rtrim;
			select rtrim(rtrim_1_1) from test_rtrim;
			select rtrim('   Korea Computer & Communication ') from test_rtrim;
			select rtrim(rtrim_1_2) from test_rtrim;
			select rtrim('   ') from test_rtrim;
			select rtrim(rtrim_1_3) from test_rtrim;
			select rtrim('') from test_rtrim;
			select rtrim(rtrim_1_4) from test_rtrim;
			select rtrim(NULL) from test_rtrim;
			select rtrim(rtrim_1_5) from test_rtrim;
				select rtrim('최공훈 ','훈') from test_rtrim;
				select rtrim(rtrim_2_1_1,'훈') from test_rtrim;
				select rtrim('   최공훈 ','훈 공') from test_rtrim;
				select rtrim(rtrim_2_1_2,'훈 공') from test_rtrim;
				select rtrim('   최공훈 ','훈최 공') from test_rtrim;
				select rtrim(rtrim_2_1_3,'훈최 공') from test_rtrim;
				select rtrim('   최공훈 ','훈 훈') from test_rtrim;
				select rtrim(rtrim_2_1_4,'훈 훈') from test_rtrim;
				select rtrim('Korea Computer & Communication','n') from test_rtrim;
				select rtrim(rtrim_2_2_1,'n') from test_rtrim;
				select rtrim(' Korea Computer & Communication','n o') from test_rtrim;
				select rtrim(rtrim_2_2_2,'n o') from test_rtrim;
				select rtrim(' Korea Computer & Communication',' ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!@#$%^&*()_<+|-=\') from test_rtrim;
				select rtrim(rtrim_2_2_3,' ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!@#$%^&*()_<+|-=\') from test_rtrim;
set system parameters 'compat_mode=mysql';
				select rtrim(' Korea Computer & Communication',' ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!@#$%^&*()_<+|-=\\') from test_rtrim;
				select rtrim(rtrim_2_2_3,' ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!@#$%^&*()_<+|-=\\') from test_rtrim;
set system parameters 'compat_mode=cubrid';
				select rtrim(' Korea Computer & Communication',' nnoo') from test_rtrim;
				select rtrim(rtrim_2_2_4,' nnoo') from test_rtrim;
			select rtrim('c 최h공 훈 ','훈 h공c') from test_rtrim;
			select rtrim(rtrim_2_3,'훈 h공c') from test_rtrim;
create table test_rtrim_table(
	c1 varchar(50),
	c2 varchar(50),
	c3 varchar(50)
) charset euckr;
insert into test_rtrim_table (c1,c2) values(' 최 최공훈 ',' 훈');
			SELECT c1, RTRIM(c1) FROM test_rtrim_table;
			SELECT c1,' 훈', RTRIM( c1,' 훈') FROM test_rtrim_table;
			SELECT ' 최 최공훈 ',c2, RTRIM( ' 최 최공훈 ',c2) FROM test_rtrim_table;
			SELECT c1,c2, RTRIM( c1,c2) FROM test_rtrim_table;
			select rtrim('','') FROM test_rtrim;
			select rtrim('','최') FROM test_rtrim;
			select rtrim('최','') FROM test_rtrim;
			SELECT c3, RTRIM( c3) FROM test_rtrim_table;
			SELECT c1, c3, rtrim(c1,c3) FROM test_rtrim_table;
			SELECT c3, c2, rtrim(c3,c2) FROM test_rtrim_table;
			SELECT c3, c3, rtrim(c3,c3) FROM test_rtrim_table;
			select rtrim(NULL) from test_rtrim;
			select rtrim(NULL,NULL) from test_rtrim;
drop table test_rtrim;
drop table test_rtrim_table;
set names iso88591;
rollback;
