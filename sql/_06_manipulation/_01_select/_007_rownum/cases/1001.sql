--test rownum, inst_num with some select statements.

create class func_11 ( a int , b string );
create serial func_11_s;
insert into func_11 values ( func_11_s.next_value, 'test');
insert into func_11 values ( func_11_s.next_value, 'test');
insert into func_11 values ( func_11_s.next_value, 'test');
insert into func_11 values ( func_11_s.next_value, 'test');
insert into func_11 values ( func_11_s.next_value, 'test');
insert into func_11 values ( func_11_s.next_value, 'test');
insert into func_11 values ( func_11_s.next_value, 'test');
insert into func_11 values ( func_11_s.next_value, 'test');
insert into func_11 values ( func_11_s.next_value, 'test');
insert into func_11 values ( func_11_s.next_value, 'test');
insert into func_11 values ( func_11_s.next_value, 'test');
insert into func_11 values ( func_11_s.next_value, 'test');
insert into func_11 values ( func_11_s.next_value, 'test');
insert into func_11 values ( func_11_s.next_value, 'test');
insert into func_11 values ( func_11_s.next_value, 'test');
insert into func_11 values ( func_11_s.next_value, 'test');
insert into func_11 values ( func_11_s.next_value, 'test');
insert into func_11 values ( func_11_s.next_value, 'test');
insert into func_11 values ( func_11_s.next_value, 'test');
insert into func_11 values ( func_11_s.next_value, 'test');
insert into func_11 values ( func_11_s.next_value, 'test');
insert into func_11 values ( func_11_s.next_value, 'test');
insert into func_11 values ( func_11_s.next_value, 'test');
insert into func_11 values ( func_11_s.next_value, 'test');
insert into func_11 values ( func_11_s.next_value, 'test');
insert into func_11 values ( func_11_s.next_value, 'test');
insert into func_11 values ( func_11_s.next_value, 'test');

select * from (select rownum + 10 , a from (select * from func_11 order by a asc) t1 where rownum <= 10) a order by 1;
select * from (select rownum + 10 , a from (select * from func_11 order by a asc) t1 where rownum <= 10 and rownum between 1 and 3) a order by 1;
select * from (select rownum + 10 , a from (select * from func_11 order by a asc) t1 where rownum <= 10 and rownum between -1 and 0) a order by 1;	
select * from (select rownum ,w from ( select a from func_11 order by a ) as t(w) where rownum < 10) a order by 1;	
select * from (select rownum ,w from ( select a from func_11 order by a desc ) as t(w) where rownum <= 10) a order by 1;
select * from (select rownum ,w from ( select a from func_11 order by a desc ) as t(w) where rownum <= -1) a order by 1;
select * from (select rownum ,w from ( select a from func_11 order by a desc ) as t(w) where inst_num() <= -1) a order by 1;

drop class func_11;
drop serial func_11_s;
