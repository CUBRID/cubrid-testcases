--Test operator +, - ,* on mix datatype set and set with different data type
create class t1(c1 int);
insert into t1 values(10);

select multiset{101,102,103,'aaa','bbb'}+{101,'bbb','ccc'} from t1;
select multiset{101,102,103,'aaa','bbb'}-{101,'bbb','ccc'} from t1;
select multiset{101,102,103,'aaa','bbb'}*{101,'bbb','ccc'} from t1;

select multiset{'aaa','bbb','ccc','ddd',111,222} + {111,222,333,'aaa','bbb'} from t1;
select multiset{'aaa','bbb','ccc','ddd',111,222} - {111,222,333,'aaa','bbb'} from t1;
select multiset{'aaa','bbb','ccc','ddd',111,222} * {111,222,333,'aaa','bbb'} from t1;

drop class t1; 