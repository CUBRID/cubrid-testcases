
create table t (
        i int default 50,
        bi bigint default 9223372036854775807,
        f float default 1.12345678901234567890,
        d double default 1.123456789012345678901234567890,
        sm smallint default 80,
        m monetary default 12345.6789,
        n numeric(10,4) default 1123.4567,
        da date default to_date('2010-01-01'),
        dt datetime default '12:00:00.000 AM 10/31/2008',
        ti time default '09:00:01',
        ts timestamp default '12:00:00.000 AM 10/31/2008',
        c char(10) default 'abc',
        vc varchar(10) default 'def',
        b bit(10) default B'1',
        vb bit varying(10) default B'1010');
    
insert into t(i) values(10);

select trunc(i) from t;
select trunc(bi) from t;
select trunc(f) from t;
select trunc(d) from t;
select trunc(sm) from t;
select trunc(m) from t;
select trunc(n) from t;
select trunc(da) from t;
select trunc(dt) from t;
select trunc(ti) from t;
select trunc(ts) from t;
select trunc(c) from t;
select trunc(vc) from t;
select trunc(vb) from t;
select trunc(b) from t;


select trunc(i,1) from t;
select trunc(bi,1) from t;
select trunc(f,1) from t;
select trunc(d,1) from t;
select trunc(sm,1) from t;
select trunc(m,1) from t;
select trunc(n,1) from t;
select trunc(da,1) from t;
select trunc(dt,1) from t;
select trunc(ti,1) from t;
select trunc(ts,1) from t;
select trunc(c,1) from t;
select trunc(vc,1) from t;
select trunc(vb,1) from t;
select trunc(b,1) from t;

select trunc(i,-1) from t;
select trunc(bi,-1) from t;
select trunc(f,-1) from t;
select trunc(d,-1) from t;
select trunc(sm,-1) from t;
select trunc(m,-1) from t;
select trunc(n,-1) from t;
select trunc(da,-1) from t;
select trunc(dt,-1) from t;
select trunc(ti,-1) from t;
select trunc(ts,-1) from t;
select trunc(c,-1) from t;
select trunc(vc,-1) from t;
select trunc(vb,-1) from t;
select trunc(b,-1) from t;
drop table t;
