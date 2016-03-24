--Test operator +, - ,* on set and multiset with same data type
create class t1(c1 int);
insert into t1 values(10);

select multiset{101,102,103}+{101,102,103,104} from t1;
select multiset{101,102,103,104} - {101} from t1;
select multiset{101,102,103,104} * {101,102} from t1;

select multiset{'aaa','bbb','ccc','ddd'} + {'aaa','bbb','xxx'} from t1;
select multiset{'aaa','bbb','ccc','ddd'} - {'aaa','bbb','xxx'} from t1;
select multiset{'aaa','bbb','ccc','ddd'} * {'aaa','bbb','xxx'} from t1;


drop class t1; 