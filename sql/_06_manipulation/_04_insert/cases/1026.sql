--Test insert with collection: multiset
create class t1 (col1 integer, col2 multiset varchar(20));
insert into t1 values(1001, {'golf', 'handicap','golf'});
insert into t1 values(1002, {'football', 'basketball','football'});
insert into t1 values(1003, {'xxx', 'yyy', 'zzz','xxx','yyy','zzz'});

select * from t1 order by 1;
drop class t1;
