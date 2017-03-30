drop table if exists t;
create table t (i int, dtz datetimetz);

-- Below queries expected return error
insert into t values (9, '1996-01-01 00:00:00 AM America/Lima PET');
insert into t values (11, '1996-01-01 00:00:00 AM America/Lima PEST');
insert into t values (1, '1993-12-31 23:59:59 PM America/Lima PET');
insert into t values (2, '1994-01-02 00:59:59 AM America/Lima PEST');

-- Below 2 query expected successfully processed.
insert into t values (1, '1993-12-31 23:59:59 PM America/Lima -05');
insert into t values (2, '1994-01-02 00:59:59 AM America/Lima -04');

select * from t order by i;
drop table if exists t;

