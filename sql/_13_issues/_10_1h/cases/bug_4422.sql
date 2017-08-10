create table tbl_foo(col_nchar nchar(7),col_string string,col_int int,col_time time,col_short short);

alter table tbl_foo add index idx (col_nchar ,col_string ,col_int ,col_time ,col_short );

insert into tbl_foo values(n'0','0',0,0,0);
insert into tbl_foo values(n'1','1',1,1,1);

select * from tbl_foo where col_nchar =n'0' and col_string ='0' and col_int =0 and col_time =0 and col_short =0; 
select * from tbl_foo where col_nchar =n'1' and col_string ='1' and col_int =1 and col_time =1 and col_short =1;

select * from tbl_foo where col_nchar =n'0' and col_string ='0' and col_int =0 and col_time =0 and col_short =0 USING INDEX NONE; 
select * from tbl_foo where col_nchar =n'1' and col_string ='1' and col_int =1 and col_time =1 and col_short =1 USING INDEX NONE;

drop table tbl_foo;

create table test01;

ALTER CLASS test01 ADD ATTRIBUTE
       col1 character(10) NOT NULL,
       year01 character(4) NOT NULL,
       col2 character(1) NOT NULL,
       col3 character(1) NOT NULL,
       col4 character(2) NOT NULL,
       grade character varying(2) NOT NULL,
       col5 character varying(4) NOT NULL,
       col6 character(5) NOT NULL,
       col7 integer NOT NULL,
       col8 character(2) NOT NULL,
       col9 character(1) NOT NULL,
       col10 character varying(2) NOT NULL,
       col11 character varying(20),
       cnt1 integer,
       cnt2 integer,
       cnt3 integer,
       cnt4 integer,
       cnt5 integer,
       cnt6 integer,
       cnt7 integer,
       col12 numeric(5,2) NOT NULL,
       date1 timestamp,
       col13 character varying(20) NOT NULL;
       
ALTER CLASS test01 ADD ATTRIBUTE
       CONSTRAINT [test01_pk] UNIQUE(year01, col2, col3, col4, grade, col5, col6, col7,
 col8, col9, col10, col1);  

insert into test01 values ('C100000338', '2003', '2', '1', '06', '1', '0685', '00137', 3, '00', 'Y', '16', '1', 544, 4, 9, 2, 3, 0, 0, 96.80, timestamp'12:53:54 PM 12/17/2003', '6903071109743');

SELECT 
 count(*)
 FROM 
 test01 a 
 WHERE 
 a.col1='C100000338' 
 AND a.year01='2003' 
 AND a.col2='2' 
 AND a.col3='1' 
 AND a.col4='06' 
 AND a.grade='1' 
 AND a.col5='0685' 
 AND a.col7=to_number('3') 
 AND a.col6='00137' 
 AND  a.col8='00' 
 AND a.col9='Y'; 
 
SELECT 
 count(*)
 FROM 
 test01 a 
 WHERE 
 a.col1='C100000338' 
 AND a.year01='2003' 
 AND a.col2='2' 
 AND a.col3='1' 
 AND a.col4='06' 
 AND a.grade='1' 
 AND a.col5='0685' 
 AND a.col7=3 
 AND a.col6='00137' 
 AND  a.col8='00' 
 AND a.col9='Y'; 

drop table test01;

