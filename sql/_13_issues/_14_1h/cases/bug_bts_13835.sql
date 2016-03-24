
--+ holdcas on;

drop table if exists t1;
create table t1 ( s1 bit varying(8) );
alter table t1 change s1 s bit varying(12) not NULL;
drop table t1;

create table t1 ( s1 bit(9) );
insert into t1 values (b'111010101'),(b''),(NULL),(b'111'),(b'101');
alter table t1 change s1 s bit(12) not NULL;

--error
select * from t1 order by 1;
drop table if exists t1;

--+ holdcas off;
commit;
