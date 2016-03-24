--[er]test mod function with unmatched type(int, char)
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

select rownum, a, b from func_08 where mod(rownum,'1') = 0  order by a;

drop class func_08;
drop serial func_08_s;

