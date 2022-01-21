
create table t (i int, j int, s string);
create table u (i int, j int);

insert into t values (1,9,'one');
insert into t values (2,8,'two');
insert into t values (3,7,'three');
insert into t values (4,6,'four');
insert into t values (5,5,'five');
insert into t values (6,4,'six');
insert into t values (7,3,'seven');
insert into t values (8,2,'eight');
insert into t values (9,1,'nine');

insert into u values (1,2);
insert into u values (1,3);
insert into u values (1,4);
insert into u values (2,3);
insert into u values (2,4);
insert into u values (3,4);

create index i_t_i on t(i);
create index i_t_s on t(s);
create index i_u_i on u(i);
create index i_u_j on u(j);

select * from t where i > 0 limit 2;
select * from t where i > 0 limit 2,4;
select * from t where i > 5 order by i limit 3;
select * from t where (i between 0 and 8) and cast(sqrt(i) as int) = i order by i limit 9;
select * from t where (i between 0 and 8) and cast(sqrt(i) as int) = i order by i limit 2,10;
select * from t where (i > 5) and rownum between 4 and 6;

select t.*, u.* from t join u on t.i = u.i order by t.i,t.j,t.s,u.i,u.j limit 2;
select * from t where i in (select j from u where j > 1 using index i_u_j(+)) using index i_t_i(+) limit 1;
select * from t,u where t.i > 0 order by t.i,t.j,t.s,u.i,u.j limit 5,2;

select * from t where i > 0 and rownum <  4;
select * from t where i > 0 and rownum <= 4;

select * from t where i > 0 and rownum >  4 and rownum <  8;
select * from t where i > 0 and rownum >  4 and rownum <= 8;
select * from t where i > 0 and rownum >= 4 and rownum <  8;
select * from t where i > 0 and rownum >= 4 and rownum <= 8;
select * from t where i > 0 and rownum <= 8 and rownum >= 4;

select * from t where i > 0 and  8 > rownum;
select * from t where i > 0 and  8 >= rownum and 3 < rownum;

prepare st from 'select * from t where i>0 and rownum>? and rownum<? and rownum>? and rownum<?'; execute st using 1,8,2,7; deallocate prepare st;
select * from t where i>0 and rownum > 2 and rownum < 7;

prepare st from 'select * from t where i>0 and rownum between ? and ? and rownum<? and rownum>? and rownum<?'; execute st using 2,9,6,3,7; deallocate prepare st;
select * from t where i>0 and rownum > 3 and rownum < 6;

drop table t;
drop table u;
