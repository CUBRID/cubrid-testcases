autocommit off;
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
			select cast(n1 as varchar)+'  sc'+c1+' sc'+c2+' sc'+c3+' sc'+c4+' sc'+c5+' sc'+c6+' sc'+c7+' sc'+c8+'
		'+to_char(n1,'sc'+c1+' sc'+c2+' sc'+c3+' sc'+c4+' sc'+c5+' sc'+c6+' sc'+c7+' sc'+c8+' sc') from test_to_char_f,test_to_char; 
			select cast(n1 as varchar)+'	'+c9+' '+c10+'
		'+to_char(n1,c9+' '+c10) from test_to_char_f,test_to_char;
			select cast(n2 as varchar)+'  sc'+c1+' sc'+c2+' sc'+c3+' sc'+c4+' sc'+c5+' sc'+c6+' sc'+c7+' sc'+c8+'
			select cast(n2 as varchar)+'	'+c9+' '+c10+'
			select cast(n3 as varchar)+'  sc'+c1+' sc'+c2+' sc'+c3+' sc'+c4+' sc'+c5+' sc'+c6+' sc'+c7+' sc'+c8+'
			select cast(n3 as varchar)+'	'+c9+' '+c10+'
		'+to_char(n3,c9+' '+c10) from test_to_char_f,test_to_char;
rollback;
