--+ holdcas on;
--test mod function with a decimal
set system parameters 'compat_mode=cubrid';
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

select  a, b from func_08 where mod(a, 1.5) = 0 order by 1,2;

drop class func_08;
drop serial func_08_s;
commit;
--+ holdcas off;
