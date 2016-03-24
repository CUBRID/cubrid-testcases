--test mod function with operations which used the mod function with different type operands like null, 0, 2

create class func_08 ( a int , b string );
create serial func_08_s;
insert into func_08 values ( func_08_s.next_value, 'test');
insert into func_08 values ( func_08_s.next_value, 'test');
insert into func_08 values ( func_08_s.next_value, 'test');
insert into func_08 values ( func_08_s.next_value, 'test');
insert into func_08 values ( func_08_s.next_value, 'test');
insert into func_08 values ( func_08_s.next_value, 'test');
insert into func_08 values ( func_08_s.next_value, 'test');
insert into func_08 values ( func_08_s.next_value, 'test');
insert into func_08 values ( func_08_s.next_value, 'test');
insert into func_08 values ( func_08_s.next_value, 'test');
insert into func_08 values ( func_08_s.next_value, 'test');
insert into func_08 values ( func_08_s.next_value, 'test');
insert into func_08 values ( func_08_s.next_value, 'test');
insert into func_08 values ( func_08_s.next_value, 'test');
insert into func_08 values ( func_08_s.next_value, 'test');
insert into func_08 values ( func_08_s.next_value, 'test');

select count(*) from func_08 order by 1;	
select count(*) from func_08 where mod(rownum,2) = 0  order by 1;	
select count(*) from func_08 where mod(rownum,rownum) = 0  order by 1;
select count(*) from func_08 where mod(a,2) = 0  order by 1;	
select count(*) from func_08 where mod(rownum,2) <> 0  order by 1;	
select count(*) from func_08 where mod(a,2) <> 0  order by 1;	
select count(*) from func_08 where mod(rownum,0) = 0  order by 1;	
select count(*) from func_08 where mod(0,0) = 0  order by 1;	
select count(*) from func_08 where mod(0,null) = 0  order by 1;	
select count(*) from func_08 where mod(null,null) = 0  order by 1;	
select count(*) from func_08 where mod(rownum,cast(to_number('1') as int)) = 0  order by 1;

drop class func_08;
drop serial func_08_s;


