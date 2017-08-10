-- create serial and table which insert data into using data type of string and int and test month in function of to_date using parameter of selected format and 'En_US' and then dorp table and serial 


create table month_test ( 
       u_month string,
       u_format string,
       lang string,
       ord int );

create serial ord start with 1 nocycle;
insert into month_test values ('2005 JANUARY 01','YYYY MONTH DD','En_US',ord.NEXT_VALUE);   
 insert into month_test values ('2005 FEBRUARY 01','YYYY MONTH DD','En_US',ord.NEXT_VALUE);  
 insert into month_test values ('2005 MARCH 01','YYYY MONTH DD','En_US',ord.NEXT_VALUE);     
 insert into month_test values ('2005 APRIL 01','YYYY MONTH DD','En_US',ord.NEXT_VALUE);     
 insert into month_test values ('2005 MAY 01','YYYY MONTH DD','En_US',ord.NEXT_VALUE);       
 insert into month_test values ('2005 JUNE 01','YYYY MONTH DD','En_US',ord.NEXT_VALUE);      
 insert into month_test values ('2005 JULY 01','YYYY MONTH DD','En_US',ord.NEXT_VALUE);      
 insert into month_test values ('2005 AUGUST 01','YYYY MONTH DD','En_US',ord.NEXT_VALUE);    
 insert into month_test values ('2005 SEPTEMBER 01','YYYY MONTH DD','En_US',ord.NEXT_VALUE); 
 insert into month_test values ('2005 OCTOBER 01','YYYY MONTH DD','En_US',ord.NEXT_VALUE);   
 insert into month_test values ('2005 NOVEMBER 01','YYYY MONTH DD','En_US',ord.NEXT_VALUE);  
 insert into month_test values ('2005 DECEMBER 01','YYYY MONTH DD','En_US',ord.NEXT_VALUE);  
 insert into month_test values ('2005 January 01','YYYY Month DD','En_US',ord.NEXT_VALUE);   
 insert into month_test values ('2005 February 01','YYYY Month DD','En_US',ord.NEXT_VALUE);  
 insert into month_test values ('2005 March 01','YYYY Month DD','En_US',ord.NEXT_VALUE);     
 insert into month_test values ('2005 April 01','YYYY Month DD','En_US',ord.NEXT_VALUE);     
 insert into month_test values ('2005 May 01','YYYY Month DD','En_US',ord.NEXT_VALUE);       
 insert into month_test values ('2005 June 01','YYYY Month DD','En_US',ord.NEXT_VALUE);      
 insert into month_test values ('2005 July 01','YYYY Month DD','En_US',ord.NEXT_VALUE);      
 insert into month_test values ('2005 August 01','YYYY Month DD','En_US',ord.NEXT_VALUE);    
 insert into month_test values ('2005 September 01','YYYY Month DD','En_US',ord.NEXT_VALUE); 
 insert into month_test values ('2005 October 01','YYYY Month DD','En_US',ord.NEXT_VALUE);   
 insert into month_test values ('2005 November 01','YYYY Month DD','En_US',ord.NEXT_VALUE);  
 insert into month_test values ('2005 December 01','YYYY Month DD','En_US',ord.NEXT_VALUE);   
 insert into month_test values ('2005 january 01','YYYY month DD','En_US',ord.NEXT_VALUE);   
 insert into month_test values ('2005 february 01','YYYY month DD','En_US',ord.NEXT_VALUE);  
 insert into month_test values ('2005 march 01','YYYY month DD','En_US',ord.NEXT_VALUE);     
 insert into month_test values ('2005 april 01','YYYY month DD','En_US',ord.NEXT_VALUE);     
 insert into month_test values ('2005 may 01','YYYY month DD','En_US',ord.NEXT_VALUE);       
 insert into month_test values ('2005 june 01','YYYY month DD','En_US',ord.NEXT_VALUE);      
 insert into month_test values ('2005 july 01','YYYY month DD','En_US',ord.NEXT_VALUE);      
 insert into month_test values ('2005 august 01','YYYY month DD','En_US',ord.NEXT_VALUE);    
 insert into month_test values ('2005 september 01','YYYY month DD','En_US',ord.NEXT_VALUE); 
 insert into month_test values ('2005 october 01','YYYY month DD','En_US',ord.NEXT_VALUE);   
 insert into month_test values ('2005 november 01','YYYY month DD','En_US',ord.NEXT_VALUE);  
 insert into month_test values ('2005 december 01','YYYY month DD','En_US',ord.NEXT_VALUE);    
 insert into month_test values ('2005 JAN 01','YYYY MON DD','En_US',ord.NEXT_VALUE);         
 insert into month_test values ('2005 FEB 01','YYYY MON DD','En_US',ord.NEXT_VALUE);         
 insert into month_test values ('2005 MAR 01','YYYY MON DD','En_US',ord.NEXT_VALUE);         
 insert into month_test values ('2005 APR 01','YYYY MON DD','En_US',ord.NEXT_VALUE);         
 insert into month_test values ('2005 MAY 01','YYYY MON DD','En_US',ord.NEXT_VALUE);         
 insert into month_test values ('2005 JUN 01','YYYY MON DD','En_US',ord.NEXT_VALUE);         
 insert into month_test values ('2005 JUL 01','YYYY MON DD','En_US',ord.NEXT_VALUE);         
 insert into month_test values ('2005 AUG 01','YYYY MON DD','En_US',ord.NEXT_VALUE);         
 insert into month_test values ('2005 SEP 01','YYYY MON DD','En_US',ord.NEXT_VALUE);         
 insert into month_test values ('2005 OCT 01','YYYY MON DD','En_US',ord.NEXT_VALUE);         
 insert into month_test values ('2005 NOV 01','YYYY MON DD','En_US',ord.NEXT_VALUE);         
 insert into month_test values ('2005 DEC 01','YYYY MON DD','En_US',ord.NEXT_VALUE);         
 insert into month_test values ('2005 Jan 01','YYYY Mon DD','En_US',ord.NEXT_VALUE);          
 insert into month_test values ('2005 Feb 01','YYYY Mon DD','En_US',ord.NEXT_VALUE);         
 insert into month_test values ('2005 Mar 01','YYYY Mon DD','En_US',ord.NEXT_VALUE);         
 insert into month_test values ('2005 Apr 01','YYYY Mon DD','En_US',ord.NEXT_VALUE);         
 insert into month_test values ('2005 May 01','YYYY Mon DD','En_US',ord.NEXT_VALUE);         
 insert into month_test values ('2005 Jun 01','YYYY Mon DD','En_US',ord.NEXT_VALUE);         
 insert into month_test values ('2005 Jul 01','YYYY Mon DD','En_US',ord.NEXT_VALUE);         
 insert into month_test values ('2005 Aug 01','YYYY Mon DD','En_US',ord.NEXT_VALUE);         
 insert into month_test values ('2005 Sep 01','YYYY Mon DD','En_US',ord.NEXT_VALUE);         
 insert into month_test values ('2005 Oct 01','YYYY Mon DD','En_US',ord.NEXT_VALUE);         
 insert into month_test values ('2005 Nov 01','YYYY Mon DD','En_US',ord.NEXT_VALUE);         
 insert into month_test values ('2005 Dec 01','YYYY Mon DD','En_US',ord.NEXT_VALUE);          
 insert into month_test values ('2005 jan 01','YYYY mon DD','En_US',ord.NEXT_VALUE);         
 insert into month_test values ('2005 feb 01','YYYY mon DD','En_US',ord.NEXT_VALUE);         
 insert into month_test values ('2005 mar 01','YYYY mon DD','En_US',ord.NEXT_VALUE);         
 insert into month_test values ('2005 apr 01','YYYY mon DD','En_US',ord.NEXT_VALUE);         
 insert into month_test values ('2005 may 01','YYYY mon DD','En_US',ord.NEXT_VALUE);         
 insert into month_test values ('2005 jun 01','YYYY mon DD','En_US',ord.NEXT_VALUE);         
 insert into month_test values ('2005 jul 01','YYYY mon DD','En_US',ord.NEXT_VALUE);         
 insert into month_test values ('2005 aug 01','YYYY mon DD','En_US',ord.NEXT_VALUE);         
 insert into month_test values ('2005 sep 01','YYYY mon DD','En_US',ord.NEXT_VALUE);         
 insert into month_test values ('2005 oct 01','YYYY mon DD','En_US',ord.NEXT_VALUE);         
 insert into month_test values ('2005 nov 01','YYYY mon DD','En_US',ord.NEXT_VALUE);         
 insert into month_test values ('2005 dec 01','YYYY mon DD','En_US',ord.NEXT_VALUE);
select u_month, u_format, to_date(u_month, u_format, 'En_US'), lang from month_test where lang = 'En_US' order by ord;



drop table month_test;
drop serial ord;