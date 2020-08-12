autocommit off;
create table tb
(
	dummy varchar(1)
);
insert into tb (dummy) values ('X');
create table test_to_number (
	type_char char(30),
	type_varchar varchar(30),
	type_nchar nchar(30),
	type_nchar_varying nchar varying(30),
	type_numeric numeric(5,5),
	type_integer integer,
	type_smallint smallint,
	type_float float,
	type_double double
);
/*		Minus					*/
select to_number('-1234','9999') from tb;
/*		Currency				*/
select to_number('$1234','c9999') from tb;
/*		No decimal number			*/
insert into test_to_number (type_char,type_varchar)  values ('1234','1234');
select to_number('1234','9999') from test_to_number;
select to_number('1234','99999') from test_to_number;
select to_number('1234','9999.9') from test_to_number;
select to_number('1234','99999.9') from test_to_number;
select to_number('1234','0000.0') from test_to_number;
select to_number('1234','00000.0') from test_to_number;
select to_number(type_char,'9999') from test_to_number;
select to_number(type_char,'99999') from test_to_number;
select to_number(type_char,'9999.9') from test_to_number;
select to_number(type_char,'99999.9') from test_to_number;
select to_number(type_char,'0000.0') from test_to_number;
select to_number(type_char,'00000.0') from test_to_number;
select to_number(type_varchar,'9999') from test_to_number;
select to_number(type_varchar,'99999') from test_to_number;
select to_number(type_varchar,'9999.9') from test_to_number;
select to_number(type_varchar,'99999.9') from test_to_number;
select to_number(type_varchar,'0000.0') from test_to_number;
select to_number(type_varchar,'00000.0') from test_to_number;
delete from test_to_number where type_char='1234' and type_varchar='1234';
/*			Decimal Number			*/
insert into test_to_number (type_char,type_varchar)  values ('123.45','123.45');
select to_number('123.45','999.99') from test_to_number;
select to_number('123.45','9999.99') from test_to_number;
select to_number('123.45','000.00') from test_to_number;
select to_number('123.45','0000.00') from test_to_number;
select to_number(type_char,'999.99') from test_to_number;
select to_number(type_char,'9999.99') from test_to_number;
select to_number(type_char,'000.00') from test_to_number;
select to_number(type_char,'0000.00') from test_to_number;
select to_number(type_varchar,'999.99') from test_to_number;
select to_number(type_varchar,'9999.99') from test_to_number;
select to_number(type_varchar,'000.00') from test_to_number;
select to_number(type_varchar,'0000.00') from test_to_number;
delete from test_to_number where type_char='123.45' and type_varchar='123.45';
/*		Scientific	notation			*/
insert into test_to_number (type_char,type_varchar)  values ('1.234e+02','1.234e+02');
select to_number('1.234e+02','9.999eeee') from test_to_number;
select to_number('1.234e+02','9.9999eeee') from test_to_number;
select to_number('1.234e+02','99.999eeee') from test_to_number;
select to_number(type_char,'9.999eeee') from test_to_number;
select to_number(type_char,'9.9999eeee') from test_to_number;
select to_number(type_char,'99.999eeee') from test_to_number;
select to_number(type_varchar,'9.999eeee') from test_to_number;
select to_number(type_varchar,'9.9999eeee') from test_to_number;
select to_number(type_varchar,'99.999eeee') from test_to_number;
delete from test_to_number where type_char='1.234e+02' and type_varchar='1.234e+02';
/*	Minus				*/
insert into test_to_number (type_char,type_varchar)  values ('-1234','-1234');
select to_number('-1234','9999') from test_to_number;
select to_number('-1234','99999') from test_to_number;
select to_number('-1234','9999.9') from test_to_number;
select to_number('-1234','99999.9') from test_to_number;
select to_number('-1234','0000.0') from test_to_number;
select to_number('-1234','00000.0') from test_to_number;
select to_number(type_char,'9999') from test_to_number;
select to_number(type_char,'99999') from test_to_number;
select to_number(type_char,'9999.9') from test_to_number;
select to_number(type_char,'99999.9') from test_to_number;
select to_number(type_char,'0000.0') from test_to_number;
select to_number(type_char,'00000.0') from test_to_number;
select to_number(type_varchar,'9999') from test_to_number;
select to_number(type_varchar,'99999') from test_to_number;
select to_number(type_varchar,'9999.9') from test_to_number;
select to_number(type_varchar,'99999.9') from test_to_number;
select to_number(type_varchar,'0000.0') from test_to_number;
select to_number(type_varchar,'00000.0') from test_to_number;
delete from test_to_number where type_char='-1234' and type_varchar='-1234';
insert into test_to_number (type_char,type_varchar)  values ('-123.45','-123.45');
select to_number('-123.45','999.99') from test_to_number;
select to_number('-123.45','9999.99') from test_to_number;
select to_number('-123.45','000.00') from test_to_number;
select to_number('-123.45','0000.00') from test_to_number;
select to_number(type_char,'999.99') from test_to_number;
select to_number(type_char,'9999.99') from test_to_number;
select to_number(type_char,'000.00') from test_to_number;
select to_number(type_char,'0000.00') from test_to_number;
select to_number(type_varchar,'999.99') from test_to_number;
select to_number(type_varchar,'9999.99') from test_to_number;
select to_number(type_varchar,'000.00') from test_to_number;
select to_number(type_varchar,'0000.00') from test_to_number;
delete from test_to_number where type_char='-123.45' and type_varchar='-123.45';
insert into test_to_number (type_char,type_varchar)  values ('-1.234e+02','-1.234e+02');
select to_number('-1.234e+02','9.999eeee') from test_to_number;
select to_number('-1.234e+02','9.9999eeee') from test_to_number;
select to_number('-1.234e+02','99.999eeee') from test_to_number;
select to_number(type_char,'9.999eeee') from test_to_number;
select to_number(type_char,'9.9999eeee') from test_to_number;
select to_number(type_char,'99.999eeee') from test_to_number;
select to_number(type_varchar,'9.999eeee') from test_to_number;
select to_number(type_varchar,'9.9999eeee') from test_to_number;
select to_number(type_varchar,'99.999eeee') from test_to_number;
delete from test_to_number where type_char='-1.234e+02' and type_varchar='-1.234e+02';
/*		Normal test			*/
select to_number('1234','9999') from tb;
select to_number('1234','99999') from tb;
select to_number('1234','9999.9') from tb;
select to_number('1234','99999.9') from tb;
select to_number('1234','0000.0') from tb;
select to_number('1234','00000.0') from tb;
/*		Minus	test		*/
select to_number('-1234','9999') from tb;
select to_number('-1234','99999') from tb;
select to_number('-1234','9999.9') from tb;
select to_number('-1234','99999.9') from tb;
select to_number('-1234','0000.0') from tb;
select to_number('-1234','00000.0') from tb;
/*		Decimal number test	*/
select to_number('123.45','999.99') from tb;
select to_number('123.45','9999.99') from tb;
select to_number('123.45','000.00') from tb;
select to_number('123.45','0000.00') from tb;
/*		Decimal & minus number test	*/
select to_number('-123.45','999.99') from tb;
select to_number('-123.45','9999.99') from tb;
select to_number('-123.45','000.00') from tb;
select to_number('-123.45','0000.00') from tb;
/*		Scientific 	notation		*/
select to_number('1.234e+02','9.999eeee') from tb;
select to_number('-1.234e+02','9.999eeee') from tb;
select to_number('1.234e-02','9.999eeee') from tb;
select to_number('-1.234e-02','9.999eeee') from tb;
select to_number('1.234e+20','9.999eeee') from tb;
select to_number('-1.234e+20','9.999eeee') from tb;
select to_number('1.234e-20','9.999eeee') from tb;
select to_number('-1.234e-20','9.999eeee') from tb;
/*		Currency		*/
select to_number('$1234','c9999') from tb;
select to_number('$1234','c99999') from tb;
select to_number('$1234','c9999.9') from tb;
select to_number('$1234','c99999.9') from tb;
select to_number('$1234','c0000.0') from tb;
select to_number('$1234','c00000.0') from tb;
/* 		Currency & minus		*/
select to_number('$-1234','c9999') from tb;
select to_number('$-1234','c99999') from tb;
select to_number('$-1234','c9999.9') from tb;
select to_number('$-1234','c99999.9') from tb;
select to_number('$-1234','c0000.0') from tb;
select to_number('$-1234','c00000.0') from tb;
/*		Currency & Decimal & no sign		*/
select to_number('$123.45','c999.99') from tb;
select to_number('$123.45','c9999.99') from tb;
select to_number('$123.45','c000.00') from tb;
select to_number('$123.45','c0000.00') from tb;
/*		Currency & minus sign & Decimal		*/
select to_number('$-123.45','c999.99') from tb;
select to_number('$-123.45','c9999.99') from tb;
select to_number('$-123.45','c000.00') from tb;
select to_number('$-123.45','c0000.00') from tb;
/*		Currency & scientific & sign	*/
select to_number('$1.234e+02','c9.999eeee') from tb;
select to_number('$-1.234e+02','c9.999eeee') from tb;
select to_number('$1.234e-02','c9.999eeee') from tb;
select to_number('$-1.234e-02','c9.999eeee') from tb;
select to_number('$1.234e+20','c9.999eeee') from tb;
select to_number('$-1.234e+20','c9.999eeee') from tb;
select to_number('$1.234e-20','c9.999eeee') from tb;
select to_number('$-1.234e-20','c9.999eeee') from tb;
/*		Currncy	& no sign			*/
select to_number('$1234','c9999') from tb;
select to_number('$1234','c99999') from tb;
select to_number('$1234','c9999.9') from tb;
select to_number('$1234','c99999.9') from tb;
select to_number('$1234','c0000.0') from tb;
select to_number('$1234','c00000.0') from tb;
/*		Currency & minus sign		*/
select to_number('$-1234','c9999') from tb;
select to_number('$-1234','c99999') from tb;
select to_number('$-1234','c9999.9') from tb;
select to_number('$-1234','c99999.9') from tb;
select to_number('$-1234','c0000.0') from tb;
select to_number('$-1234','c00000.0') from tb;
/*		Currency & Decimal			*/
select to_number('$123.45','c999.99') from tb;
select to_number('$123.45','c9999.99') from tb;
select to_number('$123.45','c000.00') from tb;
select to_number('$123.45','c0000.00') from tb;
/*		Currency & minus sign		*/
select to_number('$-123.45','c999.99') from tb;
select to_number('$-123.45','c9999.99') from tb;
select to_number('$-123.45','c000.00') from tb;
select to_number('$-123.45','c0000.00') from tb;
/*		Currency & sign	& scienfic	*/
select to_number('$1.234e+02','c9.999eeee') from tb;
select to_number('$-1.234e+02','c9.999eeee') from tb;
select to_number('$1.234e-02','c9.999eeee') from tb;
select to_number('$-1.234e-02','c9.999eeee') from tb;
select to_number('$1.234e+20','c9.999eeee') from tb;
select to_number('$-1.234e+20','c9.999eeee') from tb;
select to_number('$1.234e-20','c9.999eeee') from tb;
select to_number('$-1.234e-20','c9.999eeee') from tb;
/*		Plus & minus sign				*/
select to_number('+1234','s9999') from tb;
select to_number('+1234','s99999') from tb;
select to_number('+1234','s9999.9') from tb;
select to_number('+1234','s99999.9') from tb;
select to_number('+1234','s0000.0') from tb;
select to_number('+1234','s00000.0') from tb;
select to_number('+123.45','s999.99') from tb;
select to_number('+123.45','s9999.99') from tb;
select to_number('+123.45','s000.00') from tb;
select to_number('+123.45','s0000.00') from tb;
select to_number('-1.234e+02','s9.999eeee') from tb;
select to_number('-1.234e-02','s9.999eeee') from tb;
select to_number('-1.234e+20','s9.999eeee') from tb;
select to_number('-1.234e-20','s9.999eeee') from tb;
select to_number('+1.234e+02','s9.999eeee') from tb;
select to_number('+1.234e-02','s9.999eeee') from tb;
select to_number('+1.234e+20','s9.999eeee') from tb;
select to_number('+1.234e-20','s9.999eeee') from tb;
select to_number('1.234e-13','9.999eeee') from tb;
select to_number('1.234e-14','9.999eeee') from tb;
select to_number('1.234e-15','9.999eeee') from tb;
select to_number('1.234e-16','9.999eeee') from tb;
/*		sign	&	currency		*/
select to_number('+$1.234e+02','sc9.999eeee') from tb;
select to_number('+$1.234e+02dummy ','sc9.999eeee"dummy"  ') from tb;
select to_number('dummy +$1.234e+02','"dummy" sc9.999eeee') from tb;
/*		Text				*/
insert into test_to_number (type_char,type_varchar,type_nchar,type_nchar_varying)  values ('dummy +$1.234e+02','dummy +$1.234e+02',N'dummy +$1.234e+02',N'dummy +$1.234e+02');
select to_number('dummy +$1.234e+02','"dummy" sc9.999eeee') from test_to_number;
select type_char from test_to_number;
select type_char,to_number(type_char,'"dummy" sc9.999eeee') from test_to_number;
select to_number(type_varchar,'"dummy" sc9.999eeee') from test_to_number;
select to_number(type_nchar,'"dummy" sc9.999eeee') from test_to_number;
select to_number(type_nchar_varying,'"dummy" sc9.999eeee') from test_to_number;
delete from test_to_number where type_char='dummy +$1.234e+02';
/*			Null test			*/
insert into test_to_number (type_integer) values (1);
select to_number(type_char,'99999') from test_to_number;
select to_number(type_varchar,'9999.9') from test_to_number;
select to_number(type_nchar,'99999.9') from test_to_number;
select to_number(type_nchar_varying,'0000.0') from test_to_number;
delete from test_to_number where type_integer=1;
select to_number('00.0','999.99') from tb;
select to_number('.0','999.99') from tb;
select to_number('.0e+10','999.99eeee') from tb;
select to_number('.0','999.99eeee') from tb;
select to_number('.0e+','999.99eeee') from tb;
select to_number('.0e-','999.99eeee') from tb;
select to_number('100.00','999.99') from tb;
drop table tb;
drop table test_to_number;
rollback;
