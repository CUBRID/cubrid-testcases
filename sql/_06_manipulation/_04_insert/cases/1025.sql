--Test insert with collection
create class t1 (col1 integer, col2 set varchar(20));
insert into t1 values(1001, {'golf', 'handicap'});
insert into t1 values(1002, {'football', 'basketball'});
insert into t1 values(1003, {'xxx', 'yyy', 'zzz'});

select * from t1 order by 1;
drop class t1;
