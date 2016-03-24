autocommit off;
set names utf8;
create table test_ltrim(
			ltrim_1_1 varchar(50),
			ltrim_1_2 varchar(50),
			ltrim_1_3 varchar(50),
			ltrim_1_4 varchar(50),
			ltrim_1_5 varchar(50),
			ltrim_2_1_1 varchar(50),
			ltrim_2_1_2 varchar(50),
			ltrim_2_1_3 varchar(50),
			ltrim_2_1_4 varchar(50),
			ltrim_2_2_1 varchar(50),
			ltrim_2_2_2 varchar(50),
			ltrim_2_2_3 varchar(50),
			ltrim_2_2_4 varchar(50),
			ltrim_2_3 varchar(50)
) charset euckr;
insert into test_ltrim (ltrim_1_1,ltrim_1_2,ltrim_1_3,ltrim_1_4,ltrim_2_1_1,ltrim_2_1_2,ltrim_2_1_3,ltrim_2_1_4,ltrim_2_2_1,ltrim_2_2_2,ltrim_2_2_3,ltrim_2_2_4,ltrim_2_3) values ('   占쌍곤옙占쏙옙 ','   Korea Computer & Communication ','   ','','占쌍곤옙占쏙옙 ','   占쌍곤옙占쏙옙 ','   占쌍곤옙占쏙옙 ','   占쌍곤옙占쏙옙 ','Korea Computer & Communication',' Korea Computer & Communication',' Korea Computer & Communication',' Korea Computer & Communication','c 占쏙옙h占쏙옙 占쏙옙 ');
			select ltrim('   占쌍곤옙占쏙옙 ') from test_ltrim;
			select ltrim(ltrim_1_1) from test_ltrim;
			select ltrim('   Korea Computer & Communication ') from test_ltrim;
			select ltrim(ltrim_1_2) from test_ltrim;
			select ltrim('   ') from test_ltrim;
			select ltrim(ltrim_1_3) from test_ltrim;
			select ltrim('') from test_ltrim;
			select ltrim(ltrim_1_4) from test_ltrim;
			select ltrim(NULL) from test_ltrim;
			select ltrim(ltrim_1_5) from test_ltrim;
				select ltrim('占쌍곤옙占쏙옙 ','占쏙옙') from test_ltrim;
				select ltrim(ltrim_2_1_1,'占쏙옙') from test_ltrim;
				select ltrim('   占쌍곤옙占쏙옙 ','占쏙옙 占쏙옙') from test_ltrim;
				select ltrim(ltrim_2_1_2,'占쏙옙 占쏙옙') from test_ltrim;
				select ltrim('   占쌍곤옙占쏙옙 ','占쏙옙占쏙옙 占쏙옙') from test_ltrim;
				select ltrim(ltrim_2_1_3,'占쏙옙占쏙옙 占쏙옙') from test_ltrim;
				select ltrim('   占쌍곤옙占쏙옙 ','占쏙옙 占쏙옙') from test_ltrim;
				select ltrim(ltrim_2_1_4,'占쏙옙 占쏙옙') from test_ltrim;
				select ltrim('Korea Computer & Communication','K') from test_ltrim;
				select ltrim(ltrim_2_2_1,'K') from test_ltrim;
				select ltrim(' Korea Computer & Communication','K o') from test_ltrim;
				select ltrim(ltrim_2_2_2,'K o') from test_ltrim;

				select ltrim(' Korea Computer & Communication',' ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!@#$%^&*()_<+|-=\') from test_ltrim;
				select ltrim(ltrim_2_2_3,' ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!@#$%^&*()_<+|-=\') from test_ltrim;

set system parameters 'compat_mode=mysql';
				select ltrim(' Korea Computer & Communication',' ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!@#$%^&*()_<+|-=\\') from test_ltrim;
				select ltrim(ltrim_2_2_3,' ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!@#$%^&*()_<+|-=\\') from test_ltrim;
set system parameters 'compat_mode=cubrid';

				select ltrim(' Korea Computer & Communication',' KKoo') from test_ltrim;
				select ltrim(ltrim_2_2_4,' KKoo') from test_ltrim;
			select ltrim('c 占쏙옙h占쏙옙 占쏙옙 ','占쏙옙 h占쏙옙c') from test_ltrim;
			select ltrim(ltrim_2_3,'占쏙옙 h占쏙옙c') from test_ltrim;
create table test_ltrim_table(
	c1 varchar(50),
	c2 varchar(50),
	c3 varchar(50)
) charset euckr;
insert into test_ltrim_table (c1,c2) values(' 占쏙옙 占쌍곤옙占쏙옙 ',' 占쏙옙');
			SELECT c1, ltrim(c1) FROM test_ltrim_table;
			SELECT c1,' 占쏙옙', ltrim( c1,' 占쏙옙') FROM test_ltrim_table;
			SELECT ' 占쏙옙 占쌍곤옙占쏙옙 ',c2, ltrim( ' 占쏙옙 占쌍곤옙占쏙옙 ',c2) FROM test_ltrim_table;
			SELECT c1,c2, ltrim( c1,c2) FROM test_ltrim_table;
			select ltrim('','') FROM test_ltrim;
			select ltrim('','占쏙옙') FROM test_ltrim;
			select ltrim('占쏙옙','') FROM test_ltrim;
			SELECT c3, ltrim( c3) FROM test_ltrim_table;
			SELECT c1, c3, ltrim(c1,c3) FROM test_ltrim_table;
			SELECT c3, c2, ltrim(c3,c2) FROM test_ltrim_table;
			SELECT c3, c3, ltrim(c3,c3) FROM test_ltrim_table;
			select ltrim(NULL) from test_ltrim;
			select ltrim(NULL,NULL) from test_ltrim;
drop table test_ltrim;
drop table test_ltrim_table;
set names iso88591;		
		
rollback;
