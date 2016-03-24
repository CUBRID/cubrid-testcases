autocommit off;
set names utf8;
create table test_translate(
			translate_1_1_k varchar(50) charset utf8,
			translate_1_1_e varchar(50) charset utf8,
			translate_1_4_k varchar(50) charset utf8,
			translate_1_4_e varchar(50) charset utf8
);
insert into test_translate (translate_1_1_k,translate_1_1_e,translate_1_4_k,translate_1_4_e) values ('¾ó·¼·¹','abcde','¾ó·¹·¹','aaada');
		select translate('¾ó·¼·¹','¾ó','¿¤·¹') from test_translate;
		select translate('abcde','a','xyz') from test_translate;
		select translate('¾ó·¼·¹','¾ó','xyz') from test_translate;
		select translate('abcde','a','¿¤·¹') from test_translate;
		select translate(translate_1_1_k,'¾ó','¿¤·¹') from test_translate;
		select translate(translate_1_1_e,'a','xyz') from test_translate;
		select translate(translate_1_1_k,'¾ó','xyz') from test_translate;
		select translate(translate_1_1_e,'a','¿¤·¹') from test_translate;
		select translate('¾ó·¼·¹','¾ó·¼','¿¤·ç') from test_translate;
		select translate('abcde','abc','xyz') from test_translate;
		select translate('¾ó·¼·¹','¾ó·¼','xy') from test_translate;
		select translate('abcde','abc','¿¤·ç¾Æ') from test_translate;
		select translate(translate_1_1_k,'¾ó·¼','¿¤·ç') from test_translate;
		select translate(translate_1_1_e,'abc','xyz') from test_translate;
		select translate(translate_1_1_k,'¾ó·¼','xy') from test_translate;
		select translate(translate_1_1_e,'abc','¿¤·ç¾Æ') from test_translate;
		select translate('¾ó·¼·¹','¾ó·¼','¿¤') from test_translate;
		select translate('abcde','abc','x') from test_translate;
		select translate('¾ó·¼·¹','¾ó·¼','x') from test_translate;
		select translate('abcde','abc','¿¤') from test_translate;
		select translate(translate_1_1_k,'¾ó·¼','¿¤') from test_translate;
		select translate(translate_1_1_e,'abc','x') from test_translate;
		select translate(translate_1_1_k,'¾ó·¼','x') from test_translate;
		select translate(translate_1_1_e,'abc','¿¤') from test_translate;
		select translate('¾ó·¼·¹','¾ó¾ó',' ¿¤') from test_translate;
		select translate('abcde','aa',' x') from test_translate;
		select translate('¾ó·¼·¹','¾ó¾ó',' x') from test_translate;
		select translate('abcde','aa',' ¿¤') from test_translate;
		select translate(translate_1_1_k,'¾ó¾ó',' ¿¤') from test_translate;
		select translate(translate_1_1_e,'aa',' x') from test_translate;
		select translate(translate_1_1_k,'¾ó¾ó',' x') from test_translate;
		select translate(translate_1_1_e,'aa',' ¿¤') from test_translate;
		select translate('¾ó·¹·¹','·¹','¶ó') from test_translate;
		select translate('aaada','a','x') from test_translate;
		select translate('¾ó·¹·¹','·¹','x') from test_translate;
		select translate('aaada','a','¿¤') from test_translate;
		select translate(translate_1_4_k,'·¹','¶ó') from test_translate;
		select translate(translate_1_4_e,'a','x') from test_translate;
		select translate(translate_1_4_k,'·¹','x') from test_translate;
		select translate(translate_1_4_e,'a','¿¤') from test_translate;
create table test_translate_table(
	c1 varchar(50) charset utf8,
	c2 varchar(50) charset utf8,
	c3 varchar(50) charset utf8,
	c4 varchar(50) charset utf8,
	c5 varchar(50) charset utf8
);
insert into test_translate_table (c1,c2,c3) values('2KRW229', '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ', '9999999999XXXXXXXXXXXXXXXXXXXXXXXXXX');
			SELECT c1,'0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ',c3, translate( c1,'0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ',c3) FROM test_translate_table;
			SELECT '2KRW229',c2,c3, translate( '2KRW229',c2,c3) FROM test_translate_table;
			SELECT c1,c2,'9999999999XXXXXXXXXXXXXXXXXXXXXXXXXX', translate( c1,c2,'9999999999XXXXXXXXXXXXXXXXXXXXXXXXXX') FROM test_translate_table;
			SELECT '2KRW229','0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ',c3, translate( '2KRW229','0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ',c3) FROM test_translate_table;
			SELECT '2KRW229',c2,'9999999999XXXXXXXXXXXXXXXXXXXXXXXXXX', translate( '2KRW229',c2,'9999999999XXXXXXXXXXXXXXXXXXXXXXXXXX') FROM test_translate_table;
			SELECT c1,'0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ','9999999999XXXXXXXXXXXXXXXXXXXXXXXXXX', translate( c1,'0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ','9999999999XXXXXXXXXXXXXXXXXXXXXXXXXX') FROM test_translate_table;
			SELECT c1,c2,c3, translate( c1,c2,c3) FROM test_translate_table;
			select translate('','a','c') FROM test_translate;
			select translate('a','','c') FROM test_translate;
			select translate('a','c','') FROM test_translate;
			SELECT c5,'0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ',c5, translate( c5,'0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ',c5) FROM test_translate_table;
			SELECT '2KRW229',c4,c5, translate( '2KRW229',c4,c5) FROM test_translate_table;
			SELECT c5,c4,'9999999999XXXXXXXXXXXXXXXXXXXXXXXXXX', translate( c5,c4,'9999999999XXXXXXXXXXXXXXXXXXXXXXXXXX') FROM test_translate_table;
			SELECT '2KRW229','0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ',c5, translate( '2KRW229','0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ',c5) FROM test_translate_table;
			SELECT '2KRW229',c4,'9999999999XXXXXXXXXXXXXXXXXXXXXXXXXX', translate( '2KRW229',c4,'9999999999XXXXXXXXXXXXXXXXXXXXXXXXXX') FROM test_translate_table;
			SELECT c5,'0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ','9999999999XXXXXXXXXXXXXXXXXXXXXXXXXX', translate( c5,'0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ','9999999999XXXXXXXXXXXXXXXXXXXXXXXXXX') FROM test_translate_table;
			SELECT c5,c4,c5, translate( c5,c4,c5) FROM test_translate_table;
			select translate(NULL,NULL,NULL) from test_translate;
drop table test_translate;
drop table test_translate_table;
set names iso88591;			
rollback;
