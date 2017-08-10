drop if exists tdate;
create table tdate(col1 timestamp,col2 date,col3 datetime);
insert into tdate values ('2014-4-4 22:16:05','2013-7-1','2013-4-1 18:00:43.5');
insert into tdate select rownum,rownum,rownum from db_root connect by level<=20;
insert into tdate select b'10011001',n'2013-07-01',x'32' from db_root connect by level<=20;
drop tdate;


drop if exists t1int,t2int;
create table t1int(i int,j bigint);
insert into t1int values (2147483647,9223372036854775807);
insert into t1int values(1,3);
insert into t1int values(2,4);

--should occur overflow
create table t2int(i short);
insert into t2int select j from t1int;
drop if exists t1int,t2int;

drop table if exists t;
create table t(i int,j enum('red','yellow','green','blue'));
insert into t select rownum,rownum from db_root connect by level<=200;
drop t;



--type cast,correct phenomenon
drop table if exists tchar,tint,tshort,tbigint,tdouble,tfloat,treal,tnumeric,tblob,tclob,tvarchar,tstring,tbit,tvarbit;
create table tchar(a char(10));
insert into tchar values('123.456');
create table tint(a int);
insert into tint select * from tchar;
select * from tint;
create table tshort(a short);
insert into tshort select * from tchar;
select * from tshort;
create table tbigint(a bigint);
insert into tbigint select * from tchar;
select * from tbigint;
create table tdouble(a double);
insert into tdouble select * from tchar;
select * from tdouble;
create table tfloat(a float);
insert into tfloat select * from tchar;
select * from tfloat;
create table treal(a real);
insert into treal select * from tchar;
select * from treal;
create table tnumeric(a numeric(5,2));
insert into tnumeric select * from tchar;
select * from tnumeric;
create table tblob(a blob);
insert into tblob select * from tchar;
create table tclob(a clob);
insert into tclob select * from tchar;
create table tvarchar(a varchar(20));
insert into tvarchar select * from tchar;
select * from tvarchar;
create table tstring(a string);
insert into tstring select * from tchar;
select * from tstring;
create table tbit(a bit(2));
insert into tbit select * from tchar;
select * from tbit;


drop table if exists tchar,tint,tshort,tbigint,tdouble,tfloat,treal,tnumeric,tblob,tclob,tvarchar,tstring,tbit,tvarbit;
create table tchar(a set(char(20)));
insert into tchar values({'123.456','32767','2147483647','9223372036854775807'});
create table tint(a set(int));
insert into tint select * from tchar;
select * from tint;
create table tshort(a set(short));
insert into tshort select * from tchar;
select * from tshort;
create table tbigint(a set(bigint));
insert into tbigint select * from tchar;
select * from tbigint;
create table tdouble(a set(double));
insert into tdouble select * from tchar;
select * from tdouble;
create table tfloat(a set(float));
insert into tfloat select * from tchar;
select * from tfloat;
create table treal(a set(real));
insert into treal select * from tchar;
select * from treal;
create table tnumeric(a set(numeric(5,2)));
insert into tnumeric select * from tchar;
select * from tnumeric;

create table tvarchar(a set(varchar(30)));
insert into tvarchar select * from tchar;
select * from tvarchar;
create table tstring(a set(string));
insert into tstring select * from tchar;
select * from tstring;
create table tbit(a set(bit(2)));
insert into tbit select * from tchar;
select * from tbit;

drop table if exists tchar,tint,tshort,tbigint,tdouble,tfloat,treal,tnumeric,tblob,tclob,tvarchar,tstring,tbit,tvarbit;
create table tchar(a set(char(20)));
insert into tchar values({'123.456','32767','2147483647','9223372036854775807'});
create table tint(a list(int));
insert into tint select * from tchar;
select * from tint;
create table tshort(a list(short));
insert into tshort select * from tchar;
select * from tshort;
create table tbigint(a list(bigint));
insert into tbigint select * from tchar;
select * from tbigint;
create table tdouble(a list(double));
insert into tdouble select * from tchar;
select * from tdouble;
create table tfloat(a list(float));
insert into tfloat select * from tchar;
select * from tfloat;
create table treal(a list(real));
insert into treal select * from tchar;
select * from treal;
create table tnumeric(a list(numeric(5,2)));
insert into tnumeric select * from tchar;
select * from tnumeric;

create table tvarchar(a list(varchar(30)));
insert into tvarchar select * from tchar;
select * from tvarchar;
create table tstring(a list(string));
insert into tstring select * from tchar;
select * from tstring;
create table tbit(a list(bit(2)));
insert into tbit select * from tchar;
select * from tbit;


drop table if exists tchar,tint,tshort,tbigint,tdouble,tfloat,treal,tnumeric,tvarchar,tstring,tbit;
create table tchar(a set(char(30)));
insert into tchar values({'3.402823466E+38','1.7976931348623157E+308'});
create table tint(a set(int));
insert into tint select * from tchar;
select * from tint;
create table tshort(a set(short));
insert into tshort select * from tchar;
select * from tshort;
create table tbigint(a set(bigint));
insert into tbigint select * from tchar;
select * from tbigint;
create table tdouble(a set(double));
insert into tdouble select * from tchar;
select * from tdouble;
create table tfloat(a set(float));
insert into tfloat select * from tchar;
select * from tfloat;
create table treal(a set(real));
insert into treal select * from tchar;
select * from treal;
create table tnumeric(a set(numeric(5,2)));
insert into tnumeric select * from tchar;
select * from tnumeric;

create table tvarchar(a set(varchar(30)));
insert into tvarchar select * from tchar;
select * from tvarchar;
create table tstring(a set(string));
insert into tstring select * from tchar;
select * from tstring;
create table tbit(a set(bit(2)));
insert into tbit select * from tchar;
select * from tbit;

drop table if exists tchar,tint,tshort,tbigint,tdouble,tfloat,treal,tnumeric,tvarchar,tstring,tbit;




