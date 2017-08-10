autocommit off;
set names utf8;
Create table t (col4 NCHAR VARYING(10) charset utf8);
insert into t values(N'각刊墾奸姦干幹懇揀杆');
select * from t where strcmp(col4,N'각刊')=1;
select * from t where SUBSTR(col4,0,2)>N'각刊' order by 1;

drop table t;


Create table t (col4 NCHAR VARYING(10) charset utf8);
insert into t values(N'abcd');
select * from t where strcmp(col4,N'ab')=1;

select * from t where SUBSTR(col4,0,2)>N'ab' order by 1;

select * from t where SUBSTR(col4,0,2)=N'ab' order by 1;

drop table t;
set names iso88591;
rollback;
autocommit on;
