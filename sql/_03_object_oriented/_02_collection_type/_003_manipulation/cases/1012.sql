--Test operator +, - ,* on multiset and multiset with different data type
create class t1(c1 int);
insert into t1 values(10);

select multiset{101,102,103}+multiset{'aaa','bbb','ccc'} from t1;
select multiset{101,102,103,104} - multiset{'aaa'} from t1;
select multiset{101,102,103,104} * multiset{'aaa','bbb'} from t1;

select multiset{'aaa','bbb','ccc','ddd'} + multiset{111,222,333} from t1;
select multiset{'aaa','bbb','ccc','ddd'} - multiset{111,222,333} from t1;
select multiset{'aaa','bbb','ccc','ddd'} * multiset{111} from t1;


drop class t1; 