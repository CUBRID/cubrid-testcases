--+ holdcas on;
autocommit off;
create table dual
(
 dummy varchar(1)
 );
insert into dual values ('X');
			select to_char(1234) from dual;
			select to_char(+1234) from dual;
			select to_char(-1234) from dual;
			select to_char(1234e+02) from dual;
			select to_char(+1234e+02) from dual;
			select to_char(-1234e+02) from dual;
			select to_char(1234e-02) from dual;
			select to_char(+1234e-02) from dual;
			select to_char(-1234e-02) from dual;
			select to_char(1.234) from dual;
			select to_char(+1.234) from dual;
			select to_char(-1.234) from dual;
			select to_char(1.234e+02) from dual;
			select to_char(+1.234e+02) from dual;
			select to_char(-1.234e+02) from dual;
			select to_char(1.234e-02) from dual;
			select to_char(+1.234e-02) from dual;
			select to_char(-1.234e-02) from dual;
			select to_char(12.34e+02) from dual;
			select to_char(+12.34e+02) from dual;
			select to_char(-12.34e+02) from dual;
			select to_char(12.34e-02) from dual;
			select to_char(+12.34e-02) from dual;
			select to_char(-12.34e-02) from dual;
			select to_char(.234) from dual;
			select to_char(+.234) from dual;
			select to_char(-.234) from dual;
create table test_to_char(
	n1 numeric(10,5),
	n2 numeric(10,5),
	n3 numeric(10,5)
);
create table test_to_char_f(
	c1 varchar(10),
	c2 varchar(10),
	c3 varchar(10),
	c4 varchar(10),
	c5 varchar(10),
	c6 varchar(10),
	c7 varchar(10),
	c8 varchar(10),
	c9 varchar(10),
	c10 varchar(10)
);
insert into test_to_char (n1,n2,n3) values (123,296,999);
insert into test_to_char (n1,n2,n3) values (12.3,29.6,99.9);
insert into test_to_char (n1,n2,n3) values (1.23,2.96,9.99);
insert into test_to_char (n1,n2,n3) values (0.123,0.296,0.999);
insert into test_to_char (n1,n2,n3) values (0.0123,0.0296,0.0999);
insert into test_to_char_f (c1,c2,c3,c4,c5,c6,c7,c8,c9,c10) 
	values ('9','9.','9.9','.9','0','0.','0.0','.0','9,','0,');
insert into test_to_char_f (c1,c2,c3,c4,c5,c6,c7,c8,c9,c10)
   	values ('99','99.','9.99','.99','00','00.','0.00','.00','9,9,','0,0,');
insert into test_to_char_f (c1,c2,c3,c4,c5,c6,c7,c8,c9,c10) 
	values ('999','999.','9.999','.999','000','000.','0.000','.000','9,9,9,','0,0,0,');
insert into test_to_char_f (c1,c2,c3,c4,c5,c6,c7,c8,c9,c10) 
	values ('9999','9999.','9.9999','.9999','0000','0000.','0.0000','.0000','9,9,9,9,','0,0,0,0,');
insert into test_to_char_f (c1,c2,c3,c4,c5,c6,c7,c8,c9,c10) 
	values ('99999','99999.','9.99999','.99999','00000','00000.','0.00000','.00000','9,9,9,9,9,','0,0,0,0,0,');
			select cast(n1 as varchar)+'  '+c1+' '+c2+' '+c3+' '+c4+' '+c5+' '+c6+' '+c7+' '+c8+'  '+'
		'+to_char(n1,c1+' '+c2+' '+c3+' '+c4+' '+c5+' '+c6+' '+c7+' '+c8+' ') from test_to_char_f,test_to_char; --	1,2,3,4,5,6,7,8
			select cast(n1 as varchar)+'  '+c1+c4+' '+c5+c8+' '+c1+c8+' '+c5+c4+'
		'+to_char(n1,c1+c4+' '+c5+c8+' '+c1+c8+' '+c5+c4+' ') from test_to_char_f,test_to_char; --	1-4,5-8,1-8,5-4
			select cast(n1 as varchar)+'  s'+c1+' s'+c2+' s'+c3+' s'+c4+' s'+c5+' s'+c6+' s'+c7+' s'+c8+'
		'+to_char(n1,'s'+c1+' s'+c2+' s'+c3+' s'+c4+' s'+c5+' s'+c6+' s'+c7+' s'+c8+' s') from test_to_char_f,test_to_char; --	1,2,3,4,5,6,7,8
			select cast(n1 as varchar)+'  s'+c1+c4+' s'+c5+c8+' s'+c1+c8+' s'+c5+c4+'
		'+to_char(n1,'s'+c1+c4+' s'+c5+c8+' s'+c1+c8+' s'+c5+c4+' ') from test_to_char_f,test_to_char; --	1-4,5-8,1-8,5-4
			select cast(n1 as varchar)+'  c'+c1+' c'+c2+' c'+c3+' c'+c4+' c'+c5+' c'+c6+' c'+c7+' c'+c8+'
		'+to_char(n1,'c'+c1+' c'+c2+' c'+c3+' c'+c4+' c'+c5+' c'+c6+' c'+c7+' c'+c8+' c') from test_to_char_f,test_to_char; --	1,2,3,4,5,6,7,8
			select cast(n1 as varchar)+'  c'+c1+c4+' c'+c5+c8+' c'+c1+c8+' c'+c5+c4+'
		'+to_char(n1,'c'+c1+c4+' c'+c5+c8+' c'+c1+c8+' c'+c5+c4+' ') from test_to_char_f,test_to_char; --	1-4,5-8,1-8,5-4
			select cast(n1 as varchar)+'  sc'+c1+c4+' sc'+c5+c8+' sc'+c1+c8+' sc'+c5+c4+'
		'+to_char(n1,'sc'+c1+c4+' sc'+c5+c8+' sc'+c1+c8+' sc'+c5+c4+' ') from test_to_char_f,test_to_char; --	1-4,5-8,1-8,5-4
			select cast(n1 as varchar)+'	'+c9+c4+' '+c10+c8+' '+c9+c8+' '+c10+c4+'
		'+to_char(n1,c9+c4+' '+c10+c8+' '+c9+c8+' '+c10+c4+' ') from test_to_char_f,test_to_char; --	9-4,10-8,9-8,10-4
			select cast(n1 as varchar)+'  '+c1+'eeee '+c2+'eeee '+c3+'eeee '+c4+'eeee '+c5+'eeee '+c6+'eeee '+c7+'eeee '+c8+'eeee  '+'
		'+to_char(n1,c1+'eeee '+c2+'eeee '+c3+'eeee '+c4+'eeee '+c5+'eeee '+c6+'eeee '+c7+'eeee '+c8+'eeee ') from test_to_char_f,test_to_char; --	1,2,3,4,5,6,7,8
			select cast(n1 as varchar)+'  '+c1+c4+'eeee '+c5+c8+'eeee '+c1+c8+'eeee '+c5+c4+'eeee  
		'+to_char(n1,c1+c4+'eeee '+c5+c8+'eeee '+c1+c8+'eeee '+c5+c4+'eeee ') from test_to_char_f,test_to_char; --	1-4,5-8,1-8,5-4
			select cast(n1 as varchar)+'  s'+c1+'eeee s'+c2+'eeee s'+c3+'eeee s'+c4+'eeee s'+c5+'eeee s'+c6+'eeee s'+c7+'eeee s'+c8+'
		'+to_char(n1,'s'+c1+'eeee s'+c2+'eeee s'+c3+'eeee s'+c4+'eeee s'+c5+'eeee s'+c6+'eeee s'+c7+'eeee s'+c8+'eeee s') from test_to_char_f,test_to_char; --	1,2,3,4,5,6,7,8
			select cast(n1 as varchar)+'  s'+c1+c4+'eeee s'+c5+c8+'eeee s'+c1+c8+'eeee s'+c5+c4+'eeee
		'+to_char(n1,'s'+c1+c4+'eeee s'+c5+c8+'eeee s'+c1+c8+'eeee s'+c5+c4+'eeee') from test_to_char_f,test_to_char; --	1-4,5-8,1-8,5-4
			select cast(n1 as varchar)+'  c'+c1+'eeee c'+c2+'eeee c'+c3+'eeee c'+c4+'eeee c'+c5+'eeee c'+c6+'eeee c'+c7+'eeee c'+c8+'eeee
		'+to_char(n1,'c'+c1+'eeee c'+c2+'eeee c'+c3+'eeee c'+c4+'eeee c'+c5+'eeee c'+c6+'eeee c'+c7+'eeee c'+c8+'eeee c') from test_to_char_f,test_to_char; --	1,2,3,4,5,6,7,8
			select cast(n1 as varchar)+'  c'+c1+c4+'eeee c'+c5+c8+'eeee c'+c1+c8+'eeee c'+c5+c4+'eeee
		'+to_char(n1,'c'+c1+c4+'eeee c'+c5+c8+'eeee c'+c1+c8+'eeee c'+c5+c4+'eeee') from test_to_char_f,test_to_char; --	1-4,5-8,1-8,5-4
			select cast(n1 as varchar)+'  sc'+c1+'eeee sc'+c2+'eeee sc'+c3+'eeee sc'+c4+'eeee sc'+c5+'eeee sc'+c6+'eeee sc'+c7+'eeee sc'+c8+'eeee
		'+to_char(n1,'sc'+c1+'eeee sc'+c2+'eeee sc'+c3+'eeee sc'+c4+'eeee sc'+c5+'eeee sc'+c6+'eeee sc'+c7+'eeee sc'+c8+'eeee sc') from test_to_char_f,test_to_char; -- Current BUG	
			select cast(n1 as varchar)+'  sc'+c1+c4+'eeee sc'+c5+c8+'eeee sc'+c1+c8+'eeee sc'+c5+c4+'eeee
		'+to_char(n1,'sc'+c1+c4+'eeee sc'+c5+c8+'eeee sc'+c1+c8+'eeee sc'+c5+c4+'eeee ') from test_to_char_f,test_to_char; --	1-4,5-8,1-8,5-4
			select cast(n1 as varchar)+'	'+c9+'eeee '+c10+'eeee
		'+to_char(n1,c9+'eeee '+c10 +'eeee') from test_to_char_f,test_to_char; -- Current BUG 
			select cast(n1 as varchar)+'	'+c9+c4+'eeee '+c10+c8+'eeee '+c9+c8+'eeee '+c10+c4+'eeee
		'+to_char(n1,c9+c4+'eeee '+c10+c8+'eeee '+c9+c8+'eeee '+c10+c4+'eeee ') from test_to_char_f,test_to_char; --	9-4,10-8,9-8,10-4
			select cast(n2 as varchar)+'  '+c1+' '+c2+' '+c3+' '+c4+' '+c5+' '+c6+' '+c7+' '+c8+'  '+'
		'+to_char(n2,c1+' '+c2+' '+c3+' '+c4+' '+c5+' '+c6+' '+c7+' '+c8+' ') from test_to_char_f,test_to_char; --	1,2,3,4,5,6,7,8
			select cast(n2 as varchar)+'  '+c1+c4+' '+c5+c8+' '+c1+c8+' '+c5+c4+'
		'+to_char(n2,c1+c4+' '+c5+c8+' '+c1+c8+' '+c5+c4+' ') from test_to_char_f,test_to_char; --	1-4,5-8,1-8,5-4
			select cast(n2 as varchar)+'  s'+c1+' s'+c2+' s'+c3+' s'+c4+' s'+c5+' s'+c6+' s'+c7+' s'+c8+'
		'+to_char(n2,'s'+c1+' s'+c2+' s'+c3+' s'+c4+' s'+c5+' s'+c6+' s'+c7+' s'+c8+' s') from test_to_char_f,test_to_char; --	1,2,3,4,5,6,7,8
			select cast(n2 as varchar)+'  s'+c1+c4+' s'+c5+c8+' s'+c1+c8+' s'+c5+c4+'
		'+to_char(n2,'s'+c1+c4+' s'+c5+c8+' s'+c1+c8+' s'+c5+c4+' ') from test_to_char_f,test_to_char; --	1-4,5-8,1-8,5-4
			select cast(n2 as varchar)+'  c'+c1+' c'+c2+' c'+c3+' c'+c4+' c'+c5+' c'+c6+' c'+c7+' c'+c8+'
		'+to_char(n2,'c'+c1+' c'+c2+' c'+c3+' c'+c4+' c'+c5+' c'+c6+' c'+c7+' c'+c8+' c') from test_to_char_f,test_to_char; --	1,2,3,4,5,6,7,8
			select cast(n2 as varchar)+'  c'+c1+c4+' c'+c5+c8+' c'+c1+c8+' c'+c5+c4+'
		'+to_char(n2,'c'+c1+c4+' c'+c5+c8+' c'+c1+c8+' c'+c5+c4+' ') from test_to_char_f,test_to_char; --	1-4,5-8,1-8,5-4
			select cast(n2 as varchar)+'  sc'+c1+c4+' sc'+c5+c8+' sc'+c1+c8+' sc'+c5+c4+'
		'+to_char(n2,'sc'+c1+c4+' sc'+c5+c8+' sc'+c1+c8+' sc'+c5+c4+' ') from test_to_char_f,test_to_char; --	1-4,5-8,1-8,5-4
			select cast(n2 as varchar)+'  '+c1+'eeee '+c2+'eeee '+c3+'eeee '+c4+'eeee '+c5+'eeee '+c6+'eeee '+c7+'eeee '+c8+'eeee  '+'
		'+to_char(n2,c1+'eeee '+c2+'eeee '+c3+'eeee '+c4+'eeee '+c5+'eeee '+c6+'eeee '+c7+'eeee '+c8+'eeee ') from test_to_char_f,test_to_char; --	1,2,3,4,5,6,7,8
			select cast(n2 as varchar)+'  '+c1+c4+'eeee '+c5+c8+'eeee '+c1+c8+'eeee '+c5+c4+'eeee  
		'+to_char(n2,c1+c4+'eeee '+c5+c8+'eeee '+c1+c8+'eeee '+c5+c4+'eeee ') from test_to_char_f,test_to_char; --	1-4,5-8,1-8,5-4
			select cast(n2 as varchar)+'  s'+c1+'eeee s'+c2+'eeee s'+c3+'eeee s'+c4+'eeee s'+c5+'eeee s'+c6+'eeee s'+c7+'eeee s'+c8+'
		'+to_char(n2,'s'+c1+'eeee s'+c2+'eeee s'+c3+'eeee s'+c4+'eeee s'+c5+'eeee s'+c6+'eeee s'+c7+'eeee s'+c8+'eeee s') from test_to_char_f,test_to_char; --	1,2,3,4,5,6,7,8
			select cast(n2 as varchar)+'  s'+c1+c4+'eeee s'+c5+c8+'eeee s'+c1+c8+'eeee s'+c5+c4+'eeee
		'+to_char(n2,'s'+c1+c4+'eeee s'+c5+c8+'eeee s'+c1+c8+'eeee s'+c5+c4+'eeee') from test_to_char_f,test_to_char; --	1-4,5-8,1-8,5-4
			select cast(n2 as varchar)+'  c'+c1+'eeee c'+c2+'eeee c'+c3+'eeee c'+c4+'eeee c'+c5+'eeee c'+c6+'eeee c'+c7+'eeee c'+c8+'eeee
		'+to_char(n2,'c'+c1+'eeee c'+c2+'eeee c'+c3+'eeee c'+c4+'eeee c'+c5+'eeee c'+c6+'eeee c'+c7+'eeee c'+c8+'eeee c') from test_to_char_f,test_to_char; --	1,2,3,4,5,6,7,8
			select cast(n2 as varchar)+'  c'+c1+c4+'eeee c'+c5+c8+'eeee c'+c1+c8+'eeee c'+c5+c4+'eeee
		'+to_char(n2,'c'+c1+c4+'eeee c'+c5+c8+'eeee c'+c1+c8+'eeee c'+c5+c4+'eeee') from test_to_char_f,test_to_char; --	1-4,5-8,1-8,5-4
			select cast(n2 as varchar)+'  sc'+c1+'eeee sc'+c2+'eeee sc'+c3+'eeee sc'+c4+'eeee sc'+c5+'eeee sc'+c6+'eeee sc'+c7+'eeee sc'+c8+'eeee
		'+to_char(n2,'sc'+c1+'eeee sc'+c2+'eeee sc'+c3+'eeee sc'+c4+'eeee sc'+c5+'eeee sc'+c6+'eeee sc'+c7+'eeee sc'+c8+'eeee sc') from test_to_char_f,test_to_char; 
			select cast(n2 as varchar)+'  sc'+c1+c4+'eeee sc'+c5+c8+'eeee sc'+c1+c8+'eeee sc'+c5+c4+'eeee
		'+to_char(n2,'sc'+c1+c4+'eeee sc'+c5+c8+'eeee sc'+c1+c8+'eeee sc'+c5+c4+'eeee ') from test_to_char_f,test_to_char; --	1-4,5-8,1-8,5-4
			select cast(n2 as varchar)+'	'+c9+'eeee '+c10+'eeee
		'+to_char(n2,c9+'eeee '+c10 +'eeee') from test_to_char_f,test_to_char; 
			select cast(n2 as varchar)+'	'+c9+c4+'eeee '+c10+c8+'eeee '+c9+c8+'eeee '+c10+c4+'eeee
		'+to_char(n2,c9+c4+'eeee '+c10+c8+'eeee '+c9+c8+'eeee '+c10+c4+'eeee ') from test_to_char_f,test_to_char; --	9-4,10-8,9-8,10-4
			select cast(n3 as varchar)+'  '+c1+' '+c2+' '+c3+' '+c4+' '+c5+' '+c6+' '+c7+' '+c8+'  '+'
		'+to_char(n3,c1+' '+c2+' '+c3+' '+c4+' '+c5+' '+c6+' '+c7+' '+c8+' ') from test_to_char_f,test_to_char; --	1,2,3,4,5,6,7,8
			select cast(n3 as varchar)+'  '+c1+c4+' '+c5+c8+' '+c1+c8+' '+c5+c4+'
		'+to_char(n3,c1+c4+' '+c5+c8+' '+c1+c8+' '+c5+c4+' ') from test_to_char_f,test_to_char; --	1-4,5-8,1-8,5-4
			select cast(n3 as varchar)+'  s'+c1+' s'+c2+' s'+c3+' s'+c4+' s'+c5+' s'+c6+' s'+c7+' s'+c8+'
		'+to_char(n3,'s'+c1+' s'+c2+' s'+c3+' s'+c4+' s'+c5+' s'+c6+' s'+c7+' s'+c8+' s') from test_to_char_f,test_to_char; --	1,2,3,4,5,6,7,8
			select cast(n3 as varchar)+'  s'+c1+c4+' s'+c5+c8+' s'+c1+c8+' s'+c5+c4+'
		'+to_char(n3,'s'+c1+c4+' s'+c5+c8+' s'+c1+c8+' s'+c5+c4+' ') from test_to_char_f,test_to_char; --	1-4,5-8,1-8,5-4
			select cast(n3 as varchar)+'  c'+c1+' c'+c2+' c'+c3+' c'+c4+' c'+c5+' c'+c6+' c'+c7+' c'+c8+'
		'+to_char(n3,'c'+c1+' c'+c2+' c'+c3+' c'+c4+' c'+c5+' c'+c6+' c'+c7+' c'+c8+' c') from test_to_char_f,test_to_char; --	1,2,3,4,5,6,7,8
			select cast(n3 as varchar)+'  c'+c1+c4+' c'+c5+c8+' c'+c1+c8+' c'+c5+c4+'
		'+to_char(n3,'c'+c1+c4+' c'+c5+c8+' c'+c1+c8+' c'+c5+c4+' ') from test_to_char_f,test_to_char; --	1-4,5-8,1-8,5-4
			select cast(n3 as varchar)+'  sc'+c1+c4+' sc'+c5+c8+' sc'+c1+c8+' sc'+c5+c4+'
		'+to_char(n3,'sc'+c1+c4+' sc'+c5+c8+' sc'+c1+c8+' sc'+c5+c4+' ') from test_to_char_f,test_to_char; --	1-4,5-8,1-8,5-4
			select cast(n3 as varchar)+'	'+c9+c4+' '+c10+c8+' '+c9+c8+' '+c10+c4+'
		'+to_char(n3,c9+c4+' '+c10+c8+' '+c9+c8+' '+c10+c4+' ') from test_to_char_f,test_to_char; --	9-4,10-8,9-8,10-4
			select cast(n3 as varchar)+'  '+c1+'eeee '+c2+'eeee '+c3+'eeee '+c4+'eeee '+c5+'eeee '+c6+'eeee '+c7+'eeee '+c8+'eeee  '+'
		'+to_char(n3,c1+'eeee '+c2+'eeee '+c3+'eeee '+c4+'eeee '+c5+'eeee '+c6+'eeee '+c7+'eeee '+c8+'eeee ') from test_to_char_f,test_to_char; --	1,2,3,4,5,6,7,8
			select cast(n3 as varchar)+'  '+c1+c4+'eeee '+c5+c8+'eeee '+c1+c8+'eeee '+c5+c4+'eeee  
		'+to_char(n3,c1+c4+'eeee '+c5+c8+'eeee '+c1+c8+'eeee '+c5+c4+'eeee ') from test_to_char_f,test_to_char; --	1-4,5-8,1-8,5-4
			select cast(n3 as varchar)+'  s'+c1+'eeee s'+c2+'eeee s'+c3+'eeee s'+c4+'eeee s'+c5+'eeee s'+c6+'eeee s'+c7+'eeee s'+c8+'
		'+to_char(n3,'s'+c1+'eeee s'+c2+'eeee s'+c3+'eeee s'+c4+'eeee s'+c5+'eeee s'+c6+'eeee s'+c7+'eeee s'+c8+'eeee s') from test_to_char_f,test_to_char; --	1,2,3,4,5,6,7,8
			select cast(n3 as varchar)+'  s'+c1+c4+'eeee s'+c5+c8+'eeee s'+c1+c8+'eeee s'+c5+c4+'eeee
		'+to_char(n3,'s'+c1+c4+'eeee s'+c5+c8+'eeee s'+c1+c8+'eeee s'+c5+c4+'eeee') from test_to_char_f,test_to_char; --	1-4,5-8,1-8,5-4
			select cast(n3 as varchar)+'  c'+c1+'eeee c'+c2+'eeee c'+c3+'eeee c'+c4+'eeee c'+c5+'eeee c'+c6+'eeee c'+c7+'eeee c'+c8+'eeee
		'+to_char(n3,'c'+c1+'eeee c'+c2+'eeee c'+c3+'eeee c'+c4+'eeee c'+c5+'eeee c'+c6+'eeee c'+c7+'eeee c'+c8+'eeee c') from test_to_char_f,test_to_char; --	1,2,3,4,5,6,7,8
			select cast(n3 as varchar)+'  c'+c1+c4+'eeee c'+c5+c8+'eeee c'+c1+c8+'eeee c'+c5+c4+'eeee
		'+to_char(n3,'c'+c1+c4+'eeee c'+c5+c8+'eeee c'+c1+c8+'eeee c'+c5+c4+'eeee') from test_to_char_f,test_to_char; --	1-4,5-8,1-8,5-4
			select cast(n3 as varchar)+'  sc'+c1+'eeee sc'+c2+'eeee sc'+c3+'eeee sc'+c4+'eeee sc'+c5+'eeee sc'+c6+'eeee sc'+c7+'eeee sc'+c8+'eeee
		'+to_char(n3,'sc'+c1+'eeee sc'+c2+'eeee sc'+c3+'eeee sc'+c4+'eeee sc'+c5+'eeee sc'+c6+'eeee sc'+c7+'eeee sc'+c8+'eeee sc') from test_to_char_f,test_to_char; 
			select cast(n3 as varchar)+'  sc'+c1+c4+'eeee sc'+c5+c8+'eeee sc'+c1+c8+'eeee sc'+c5+c4+'eeee
		'+to_char(n3,'sc'+c1+c4+'eeee sc'+c5+c8+'eeee sc'+c1+c8+'eeee sc'+c5+c4+'eeee ') from test_to_char_f,test_to_char; --	1-4,5-8,1-8,5-4
			select cast(n3 as varchar)+'	'+c9+'eeee '+c10+'eeee
		'+to_char(n3,c9+'eeee '+c10 +'eeee') from test_to_char_f,test_to_char; 
			select cast(n3 as varchar)+'	'+c9+c4+'eeee '+c10+c8+'eeee '+c9+c8+'eeee '+c10+c4+'eeee
		'+to_char(n3,c9+c4+'eeee '+c10+c8+'eeee '+c9+c8+'eeee '+c10+c4+'eeee ') from test_to_char_f,test_to_char; --	9-4,10-8,9-8,10-4
			select to_char(1.234,' ') from dual;
			select to_char(-1.234,' ') from dual;
			select to_char(1.234,'.') from dual;
			select to_char(-1.234,'.') from dual;
			select to_char(1.234,'s') from dual;
			select to_char(-1.234,'s') from dual;
			select to_char(1.234,'c') from dual;
			select to_char(-1.234,'c') from dual;
			select to_char(1.234,'sc') from dual;
			select to_char(-1.234,'sc') from dual;
			select to_char(1.234,'"text"') from dual;
                        set names utf8;
			select to_char(1234,'"최공훈" 0000 "ebebe"') from dual;
			select to_char(1234,'"최공훈" 0.99eeee "ebebe"') from dual;
			select to_char(1234,'999"최공훈"999   0.99eeee "ebebe"') from dual;
			select to_char(1234,'"최공훈""ebebe" sc00000 ') from dual;
			select to_char(1234,'"최공훈" "ebebe" 009999.99') from dual;
			select to_char(9999.9,'"최공훈" 0000 "ebebe"') from dual;
			select to_char(9999.9,'"최공훈" 0.99eeee "ebebe"') from dual;
			select to_char(9999.9,'999"최공훈"999   0.99eeee "ebebe"') from dual;
			select to_char(9999.9,'"최공훈""ebebe" sc00000 ') from dual;
			select to_char(9999.9,'"최공훈" "ebebe" 009999.99') from dual;
			
create table test_to_char_table(
    n1 numeric(10,5),
    c2 varchar(500),
    n3 numeric(10,5),
    c4 varchar(500)
);  
insert into test_to_char_table (n1,c2) values(124.5,'0000 9999 9,999 9,9,9,9, s999999 s00000 c99999 c00000 sc99999 sc00000 9.9eeee 9.99eeee 0.99eeee 00.9eeee sc0.eeee 999 000 000.0 99.9 ');
    
		SELECT n1, to_char( n1) FROM test_to_char_table;
		SELECT n1,'0000 9999 9,999 9,9,9,9, s999999 s00000 c99999 c00000 sc99999 sc00000 9.9eeee 9.99eeee 0.99eeee 00.9eeee sc0.eeee 999 000 000.0 99.9 ', to_char( n1,'0000 9999 9,999 9,9,9,9, s999999 s00000 c99999 c00000 sc99999 sc00000 9.9eeee 9.99eeee 0.99eeee 00.9eeee sc0.eeee 999 000 000.0 99.9 ') FROM test_to_char_table;
		SELECT 124.5,c2, to_char( 124.5,c2) FROM test_to_char_table;
		SELECT n1,c2, to_char( n1,c2) FROM test_to_char_table;
		SELECT to_char(1234,'9999') FROM test_to_char_table;
		SELECT n3, to_char( n3) FROM test_to_char_table;
		SELECT n1,c4, to_char( n1,c4) FROM test_to_char_table;
		SELECT n3,c2, to_char( n3,c2) FROM test_to_char_table;
		SELECT n3,c4, to_char( n3,c4) FROM test_to_char_table;
		select to_char(NULL) from test_to_char;
		select to_char(NULL,NULL) from test_to_char;
drop table test_to_char;
drop table test_to_char_table;
		
set names iso88591; 	
rollback;
--+ holdcas off;
