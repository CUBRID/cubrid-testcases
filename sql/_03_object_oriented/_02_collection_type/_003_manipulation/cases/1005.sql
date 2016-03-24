--Test operator +, - ,* on set and set with different data type
create class t1(c1 int);
insert into t1 values(10);

select {101,102,103}+{'aaa','bbb','ccc'} from t1;
select {101,102,103,104} - {'aaa'} from t1;
select {101,102,103,104} * {'aaa','bbb'} from t1;

select {'aaa','bbb','ccc','ddd'} + {111,222,333} from t1;
select {'aaa','bbb','ccc','ddd'} - {111,222,333} from t1;
select {'aaa','bbb','ccc','ddd'} * {111} from t1;


drop class t1; 