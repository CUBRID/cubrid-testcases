-- retrieve by operator of "||" and "+" to operate string and char


create class dummy( a string);
insert into dummy values ('                    1');
insert into dummy values ('                    1');
insert into dummy values ('111');
insert into dummy values ('1      1');
insert into dummy values ('1        1');
insert into dummy values ('   1   ');
insert into dummy values (' 1 ');
insert into dummy values ('');
insert into dummy values (null);
 


select a || 'hello' || 'world' from dummy order by 1	;
select a + 'hello' + 'world' from dummy order by 1	;
select a || 'hello' + 'world' from dummy order by 1	;
select null + ' ' from dummy order by 1	;
select  to_char(rownum) || 'world' from dummy order by 1;	
select   'world' ||  to_char(rownum)  from dummy order by 1;	
select cast('1234' as string ) || cast('1234' as varchar(4) ) || cast('1234' as char(4)) from dummy	;
select to_char(111) || to_char(222) from dummy	;
select to_char(rownum) || to_char(222) from dummy	;
select '111' || to_char(222) from dummy	;
select cast('1111' as varchar(4)) + to_char(222) from dummy ;

 

drop class dummy;