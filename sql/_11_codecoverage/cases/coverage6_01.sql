
create table test02(col_char varchar(100), col_nchar nchar VARYING(100));

insert into test02 values('nhn cubrid nhn, 12nhn56', N'nhn cubrid nhn, 12nhn56');
insert into test02 values('china korea', N'china korea');
insert into test02 values('china corea', N'china corea');
insert into test02 values('china_corea', N'china_corea');
insert into test02 values('china\_corea', N'china\_corea');
insert into test02 values('chinaXcorea', N'chinaXcorea');
insert into test02 values('china%corea', N'china%corea');
insert into test02 values('china\%corea', N'china\%corea');


select * from test02 where col_char like '%' order by 1;
select * from test02 where col_char not like '%' order by 1;
select * from test02 where col_char like 'n%' order by 1;
select * from test02 where col_char like 'n%n' order by 1;
select * from test02 where col_char like 'n%6' order by 1;
select * from test02 where col_char like 'm%' order by 1;
select * from test02 where col_char like 'china %' order by 1;
select * from test02 where col_char like '% %' order by 1;
select * from test02 where col_char like '__ina\_%' ESCAPE '\' order by 1;
select * from test02 where col_char like '__ina\%%' ESCAPE '\' order by 1;


select * from test02 where col_char like '_%' order by 1;
select * from test02 where col_char like 'n_n%' order by 1;
select * from test02 where col_char like 'n_m%' order by 1;
select * from test02 where col_char like '%_' order by 1;
select * from test02 where col_char like '%n_6' order by 1;
select * from test02 where col_char like 'china korea' order by 1;
select * from test02 where col_char like 'china _orea' order by 1;

select * from test02 where col_nchar like N'%' order by 1;
select * from test02 where col_nchar not like N'%' order by 1;
select * from test02 where col_nchar like N'n%' order by 1;
select * from test02 where col_nchar like N'n%n' order by 1;
select * from test02 where col_nchar like N'n%6' order by 1;
select * from test02 where col_nchar like N'm%' order by 1;
select * from test02 where col_nchar like N'china %' order by 1;
select * from test02 where col_nchar like N'% %' order by 1;
select * from test02 where col_nchar like N'__ina\_%' order by 1;
select * from test02 where col_nchar like N'__ina\%%' order by 1;

select * from test02 where col_nchar like N'_%' order by 1;
select * from test02 where col_nchar like N'n_n%' order by 1;
select * from test02 where col_nchar like N'n_m%' order by 1;
select * from test02 where col_nchar like N'%_' order by 1;
select * from test02 where col_nchar like N'%n_6' order by 1;
select * from test02 where col_nchar like N'china korea' order by 1;
select * from test02 where col_nchar like N'china _orea' order by 1;

--
select * from test02 where col_nchar like '%' order by 1;
select * from test02 where col_char like N'%' order by 1;
select * from test02 where col_char like '__ina\\\_%' ESCAPE '\' order by 1;
select * from test02 where col_char like '__ina\\\_%' ESCAPE '\' order by 1;

select * from test02 where col_nchar like N'__ina\_%' ESCAPE N'\' order by 1;
select * from test02 where col_nchar like N'__ina\%%' ESCAPE N'\' order by 1;

drop table test02;

