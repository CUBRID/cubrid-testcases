--Test operator +, - ,* on set with null set
create class t1(c1 int);
insert into t1 values(10);

select {101,102,103}+{} from t1;
select {101,102,103,104} - {} from t1;
select {101,102,103,104} * {} from t1;
select {101,102,103}+ null from t1;
select {101,102,103,104} - null from t1;
select {101,102,103,104} * null from t1;
select {'aaa','bbb','ccc','ddd'} + {} from t1;
select {'aaa','bbb','ccc','ddd'} - {} from t1;
select {'aaa','bbb','ccc','ddd'} * {} from t1;

select {'aaa','bbb','ccc','ddd'} + null from t1;
select {'aaa','bbb','ccc','ddd'} - null from t1;
select {'aaa','bbb','ccc','ddd'} * null from t1;

drop class t1; 