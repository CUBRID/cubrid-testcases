--inherit from a table including columns with different default value



create table c47(id int primary key auto_increment, 
	col1 timestamp not null default CURRENT_TIMESTAMP,
	col2 timestamp default UNIX_TIMESTAMP(),
	col3 timestamp default SYSTIMESTAMP,
	col4 date default SYSDATE,
	col5 datetime default SYSDATETIME,
	col6 varchar(1024) default USER,
	col7 string default CURRENT_USER
);


--TEST: inherit from a table and create a column with default value of CURRENT_TIMESTAMP
create table sub1_c47 under c47 (col8 timestamp default CURRENT_TIMESTAMP not null);
--TEST: check the inherited column
show columns in sub1_c47;

--TEST: insert into an inherited table
insert into sub1_c47(col8) values (default), (default), (default);
--TEST: check inserted values of the inherited column
select if((SYSTIMESTAMP - col1) >= 0 and abs(col2-col3)<=1 and col3 = col8, 'ok', 'nok') from sub1_c47;
--TEST: check inserted values of the inherited column
select if((SYSDATE - col4) = 0 and (SYSDATETIME - col5)>=0, 'ok', 'nok') from sub1_c47;
--TEST: check inserted values of the inherited column
select if(col6 = USER and col7 = CURRENT_USER, 'ok', 'nok') from sub1_c47;


--TEST: second inherit, add a column with default value of UNIX_TIMESTAMP
create table sub2_c47 under sub1_c47 (col9 timestamp default UNIX_TIMESTAMP());
--TEST: check the inherited column
desc sub2_c47;

--TEST: insert into an inherited table
insert into sub2_c47(col9) values(default), (default), (default), (default);
--TEST: check inserted values of the inherited column
select if((SYSTIMESTAMP - col9)>=0, 'ok', 'nok') from sub2_c47;


--TEST: third inherit, add a column with default value of SYSTIMESTAMP
create table sub3_c47 under sub2_c47 (col10 timestamp default SYSTIMESTAMP);
--TEST: check the inherited column
desc sub3_c47;

--TEST: insert into an inherited table
insert into sub3_c47(col2, col10) values(default, default), (default, default), (default, default), (default, default);
--TEST: check inserted values of the inherited column
select if((SYSTIMESTAMP - col10) >=0 , 'ok', 'nok') from sub3_c47;


--TEST: 4th inherit, add a column with default value of SYSDATE
create table sub4_c47 under sub3_c47 (col11 date default SYSDATE);
--TEST: check the inherited column
desc sub4_c47;

--TEST: insert into an inherited table
insert into sub4_c47(col3, col11) values(default, default), (default, default), (default, default), (default, default);
--TEST: check inserted values of the inherited column
select if((SYSDATE - col11) = 0, 'ok', 'nok') from sub4_c47;


--TEST: 5th inherit, add a column with default value of SYSDATETIME
create table sub5_c47 under sub4_c47 (col12 datetime default SYSDATETIME);
--TEST: check the inherited column
desc sub5_c47;

--TEST: insert into an inherited table
insert into sub5_c47(col4, col12) values(default, default), (default, default), (default, default), (default, default);
--TEST: check inserted values of the inherited column
--for example: sysdatetime:2015-01-23 21:21:31.599  systimestamp:2015-01-23 21:21:31.0 (SYSTIMESTAMP - col12)=-599 
select if((SYSTIMESTAMP - col12) >=0 or (SYSTIMESTAMP - col12)<=1000, 'ok', 'nok') from sub5_c47;


--TEST: 6th inherit, add a column with default value of USER
create table sub6_c47 under sub5_c47 (col13 varchar default USER);
--TEST: check the inherited column
desc sub6_c47;

--TEST: insert into an inherited table
insert into sub6_c47(col5, col13) values(default, default), (default, default), (default, default), (default, default);
--TEST: check inserted values of the inherited column
select if(CURRENT_USER = col13, 'ok', 'nok') from sub6_c47;


--TEST: 7th inherit, add a column with default value of CURRENT_USER
create table sub7_c47 under sub6_c47 (col14 string default CURRENT_USER);
--TEST: check the inherited column
desc sub7_c47;

--TEST: insert into an inherited table
insert into sub7_c47(col6, col14) values(default, default), (default, default), (default, default), (default, default);
--TEST: check inserted values of the inherited column
select if(CURRENT_USER = col14, 'ok', 'nok') from sub7_c47;




drop table c47, sub1_c47, sub2_c47, sub3_c47, sub4_c47, sub5_c47, sub6_c47, sub7_c47;
