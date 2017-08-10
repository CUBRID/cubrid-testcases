-- create serial and table which insert data into using data type of string and int and test month in function of to_date using parameter of selected format and 'Ko_KR' and then dorp table and serial 

create table month_test ( 
       u_month string,
       u_format string,
       lang string,
       ord int );

create serial ord start with 1 nocycle;
insert into month_test values ('2005 1? 01','YYYY MONTH DD','Ko_KR',ord.NEXT_VALUE);       
 insert into month_test values ('2005 2? 01','YYYY MONTH DD','Ko_KR',ord.NEXT_VALUE);       
 insert into month_test values ('2005 3? 01','YYYY MONTH DD','Ko_KR',ord.NEXT_VALUE);       
 insert into month_test values ('2005 4? 01','YYYY MONTH DD','Ko_KR',ord.NEXT_VALUE);       
 insert into month_test values ('2005 5? 01','YYYY MONTH DD','Ko_KR',ord.NEXT_VALUE);       
 insert into month_test values ('2005 6? 01','YYYY MONTH DD','Ko_KR',ord.NEXT_VALUE);       
 insert into month_test values ('2005 7? 01','YYYY MONTH DD','Ko_KR',ord.NEXT_VALUE);       
 insert into month_test values ('2005 8? 01','YYYY MONTH DD','Ko_KR',ord.NEXT_VALUE);       
 insert into month_test values ('2005 9? 01','YYYY MONTH DD','Ko_KR',ord.NEXT_VALUE);       
 insert into month_test values ('2005 10? 01','YYYY MONTH DD','Ko_KR',ord.NEXT_VALUE);      
 insert into month_test values ('2005 11? 01','YYYY MONTH DD','Ko_KR',ord.NEXT_VALUE);      
 insert into month_test values ('2005 12? 01','YYYY MONTH DD','Ko_KR',ord.NEXT_VALUE);      
 insert into month_test values ('2005 1? 01','YYYY Month DD','Ko_KR',ord.NEXT_VALUE);       
 insert into month_test values ('2005 2? 01','YYYY Month DD','Ko_KR',ord.NEXT_VALUE);       
 insert into month_test values ('2005 3? 01','YYYY Month DD','Ko_KR',ord.NEXT_VALUE);       
 insert into month_test values ('2005 4? 01','YYYY Month DD','Ko_KR',ord.NEXT_VALUE);       
 insert into month_test values ('2005 5? 01','YYYY Month DD','Ko_KR',ord.NEXT_VALUE);       
 insert into month_test values ('2005 6? 01','YYYY Month DD','Ko_KR',ord.NEXT_VALUE);       
 insert into month_test values ('2005 7? 01','YYYY Month DD','Ko_KR',ord.NEXT_VALUE);       
 insert into month_test values ('2005 8? 01','YYYY Month DD','Ko_KR',ord.NEXT_VALUE);       
 insert into month_test values ('2005 9? 01','YYYY Month DD','Ko_KR',ord.NEXT_VALUE);       
 insert into month_test values ('2005 10? 01','YYYY Month DD','Ko_KR',ord.NEXT_VALUE);      
 insert into month_test values ('2005 11? 01','YYYY Month DD','Ko_KR',ord.NEXT_VALUE);      
 insert into month_test values ('2005 12? 01','YYYY Month DD','Ko_KR',ord.NEXT_VALUE);      
 insert into month_test values ('2005 1? 01','YYYY month DD','Ko_KR',ord.NEXT_VALUE);       
 insert into month_test values ('2005 2? 01','YYYY month DD','Ko_KR',ord.NEXT_VALUE);       
 insert into month_test values ('2005 3? 01','YYYY month DD','Ko_KR',ord.NEXT_VALUE);       
 insert into month_test values ('2005 4? 01','YYYY month DD','Ko_KR',ord.NEXT_VALUE);       
 insert into month_test values ('2005 5? 01','YYYY month DD','Ko_KR',ord.NEXT_VALUE);       
 insert into month_test values ('2005 6? 01','YYYY month DD','Ko_KR',ord.NEXT_VALUE);       
 insert into month_test values ('2005 7? 01','YYYY month DD','Ko_KR',ord.NEXT_VALUE);       
 insert into month_test values ('2005 8? 01','YYYY month DD','Ko_KR',ord.NEXT_VALUE);       
 insert into month_test values ('2005 9? 01','YYYY month DD','Ko_KR',ord.NEXT_VALUE);       
 insert into month_test values ('2005 10? 01','YYYY month DD','Ko_KR',ord.NEXT_VALUE);      
 insert into month_test values ('2005 11? 01','YYYY month DD','Ko_KR',ord.NEXT_VALUE);      
 insert into month_test values ('2005 12? 01','YYYY month DD','Ko_KR',ord.NEXT_VALUE);      
 insert into month_test values ('2005 1 01','YYYY MON DD','Ko_KR',ord.NEXT_VALUE);           
 insert into month_test values ('2005 2 01','YYYY MON DD','Ko_KR',ord.NEXT_VALUE);           
 insert into month_test values ('2005 3 01','YYYY MON DD','Ko_KR',ord.NEXT_VALUE);           
 insert into month_test values ('2005 4 01','YYYY MON DD','Ko_KR',ord.NEXT_VALUE);           
 insert into month_test values ('2005 5 01','YYYY MON DD','Ko_KR',ord.NEXT_VALUE);           
 insert into month_test values ('2005 6 01','YYYY MON DD','Ko_KR',ord.NEXT_VALUE);           
 insert into month_test values ('2005 7 01','YYYY MON DD','Ko_KR',ord.NEXT_VALUE);           
 insert into month_test values ('2005 8 01','YYYY MON DD','Ko_KR',ord.NEXT_VALUE);           
 insert into month_test values ('2005 9 01','YYYY MON DD','Ko_KR',ord.NEXT_VALUE);           
 insert into month_test values ('2005 10 01','YYYY MON DD','Ko_KR',ord.NEXT_VALUE);          
 insert into month_test values ('2005 11 01','YYYY MON DD','Ko_KR',ord.NEXT_VALUE);          
 insert into month_test values ('2005 12 01','YYYY MON DD','Ko_KR',ord.NEXT_VALUE);          
 insert into month_test values ('2005 1 01','YYYY Mon DD','Ko_KR',ord.NEXT_VALUE);           
 insert into month_test values ('2005 2 01','YYYY Mon DD','Ko_KR',ord.NEXT_VALUE);           
 insert into month_test values ('2005 3 01','YYYY Mon DD','Ko_KR',ord.NEXT_VALUE);           
 insert into month_test values ('2005 4 01','YYYY Mon DD','Ko_KR',ord.NEXT_VALUE);           
 insert into month_test values ('2005 5 01','YYYY Mon DD','Ko_KR',ord.NEXT_VALUE);           
 insert into month_test values ('2005 6 01','YYYY Mon DD','Ko_KR',ord.NEXT_VALUE);           
 insert into month_test values ('2005 7 01','YYYY Mon DD','Ko_KR',ord.NEXT_VALUE);           
 insert into month_test values ('2005 8 01','YYYY Mon DD','Ko_KR',ord.NEXT_VALUE);           
 insert into month_test values ('2005 9 01','YYYY Mon DD','Ko_KR',ord.NEXT_VALUE);           
 insert into month_test values ('2005 10 01','YYYY Mon DD','Ko_KR',ord.NEXT_VALUE);          
 insert into month_test values ('2005 11 01','YYYY Mon DD','Ko_KR',ord.NEXT_VALUE);          
 insert into month_test values ('2005 12 01','YYYY Mon DD','Ko_KR',ord.NEXT_VALUE);           
 insert into month_test values ('2005 1 01','YYYY mon DD','Ko_KR',ord.NEXT_VALUE);           
 insert into month_test values ('2005 2 01','YYYY mon DD','Ko_KR',ord.NEXT_VALUE);           
 insert into month_test values ('2005 3 01','YYYY mon DD','Ko_KR',ord.NEXT_VALUE);           
 insert into month_test values ('2005 4 01','YYYY mon DD','Ko_KR',ord.NEXT_VALUE);           
 insert into month_test values ('2005 5 01','YYYY mon DD','Ko_KR',ord.NEXT_VALUE);           
 insert into month_test values ('2005 6 01','YYYY mon DD','Ko_KR',ord.NEXT_VALUE);           
 insert into month_test values ('2005 7 01','YYYY mon DD','Ko_KR',ord.NEXT_VALUE);           
 insert into month_test values ('2005 8 01','YYYY mon DD','Ko_KR',ord.NEXT_VALUE);           
 insert into month_test values ('2005 9 01','YYYY mon DD','Ko_KR',ord.NEXT_VALUE);           
insert into month_test values ('2005 10 01','YYYY mon DD','Ko_KR',ord.NEXT_VALUE);          
 insert into month_test values ('2005 11 01','YYYY mon DD','Ko_KR',ord.NEXT_VALUE);          
 insert into month_test values ('2005 12 01','YYYY mon DD','Ko_KR',ord.NEXT_VALUE);

select u_month, u_format, to_date(u_month, u_format, 'Ko_KR'), lang from month_test where lang = 'Ko_KR' order by ord;


drop table month_test;
drop serial ord;