set system parameters 'create_table_reuseoid=no';
-- select data from vclass and with left outer join keyword
--+ holdcas on;
create class dml_super (
int_col int,
var_col varchar(20),
set_col set(int) );

create class dml_0001 under dml_super (
ref_col dml_super);

create class dml_0002 under dml_0001 (
ref1_col dml_0001);

create class dml_0003 under dml_0002 (
ref2_col dml_0002);

create class dml_0004 under dml_0003 (
ref3_col dml_0003);

create class dml_0005 under dml_0004 (
ref4_col dml_0004);

create vclass dml_vsuper (
int_col int,
var_col varchar(20),
set_col set(int));

create vclass dml_v_normal_1 under dml_vsuper 
as
select a.int_col, a.var_col,a.set_col from dml_0001 a;

create vclass dml_v_normal_2 under dml_vsuper (
	int_col int,
	var_col varchar(20),
	set_col set(int),
	ref_col dml_0004
) as
select Max(a.int_col), a.var_col,a.set_col, a.ref4_col 
from dml_0005 a 
group by a.var_col,a.set_col,a.ref4_col;


create vclass dml_v_view_1 under dml_vsuper (
	ref_col dml_0001
)	as
select int_col, var_col, set_col, ref1_col from dml_0002;

create vclass dml_v_view_2 under dml_v_view_1 as
select a.int_col, b.var_col,c.set_col, a.ref_col 
from dml_v_view_1 a,dml_0001 b LEFT OUTER JOIN dml_0002 c on b.int_col = c.int_col 
RIGHT OUTER JOIN dml_0003 d on d.int_col = c.int_col;

create vclass dml_v_view_3 under dml_v_view_2 as
select a.int_col, b.var_col, c.set_col, d.ref_col 
from dml_0001 a LEFT OUTER JOIN dml_0002 b on a.int_col = b.int_col 
RIGHT OUTER JOIN dml_0003 c on c.int_col = b.int_col, dml_v_view_2 d
where a.int_col = d.int_col;

create vclass dml_v_view_4 under dml_v_view_3 as
select a.int_col, b.var_col, b.set_col, a.ref_col 
from dml_v_view_3 a, all dml_0003 b; 

create vclass dml_v_view_5 under dml_v_view_4 as
select * from dml_v_view_4;

create vclass dml_v_view_6 under dml_v_view_5 as
select * from dml_v_view_5;


create vclass dml_v_join_1 under dml_vsuper (
ref1_col dml_0003,
ref2_col dml_0004 ) as
select a.int_col,b.var_col,c.set_col,d.ref3_col, e.ref4_col 
from dml_0001 a, dml_0002 b,dml_0003 c,dml_0004 d,dml_0005 e
where a.int_col = b.int_col and b.int_col = c.int_col
and c.int_col = d.int_col and d.int_col = e.int_col;

create vclass dml_v_join_2 under dml_vsuper (
ref1_col dml_0003,
ref2_col dml_0004 ) as
select a.int_col,b.var_col,c.set_col,d.ref3_col,e.ref4_col
from dml_v_view_6 a, dml_v_normal_1 b, dml_0003 c, dml_0004 d, dml_0005 e
where a.int_col = b.int_col and b.int_col=c.int_col
and c.int_col = d.int_col and d.int_col = e.int_col;

create vclass dml_v_join_3 under dml_vsuper(
ref_col dml_super	) as 
select a.ref_col.int_col, b.ref1_col.ref_col.var_col, 
c.set_col, c.ref2_col.ref1_col.ref_col
from dml_0001 a LEFT OUTER JOIN dml_0002 b on a.int_col=b.int_col 
RIGHT OUTER JOIN dml_0003 c on c.int_col = b.int_col;

create vclass dml_v_join_4 under dml_vsuper(
ref1_col dml_0001,
ref2_col dml_0004	) as 
select a.ref_col.int_col, b.ref1_col.ref_col.var_col, 
c.set_col,d.ref_col, e.ref2_col
from dml_0001 a LEFT OUTER JOIN dml_0002 b on a.int_col = b.int_col 
RIGHT OUTER JOIN dml_0003 c on c.int_col = b.int_col ,
dml_v_view_6 d, dml_v_join_2 e
where c.int_col = d.int_col and d.int_col = e.int_col;

create vclass dml_v_join_5 under dml_vsuper (
ref1_col dml_0001
) as 
select a.int_col, b.var_col, a.set_col, b.ref_col
from all dml_super a, all dml_v_view_1 b
where a.int_col = b.int_col;

create vclass dml_v_inherit_1 under dml_vsuper as
select int_col, var_col, set_col
from all dml_super
where int_col between 1 and 2;

create vclass dml_v_inherit_2 under dml_vsuper as 
select int_col, var_col, set_col
from all dml_super (except (dml_0001, dml_0005))
where int_col between 1 and 2;
insert into dml_super values(1,'test1',{1,2});
insert into dml_super values(2,'test2',{2,3});

select dml_super into s_a from dml_super where int_col = 1;
select dml_super into s_b from dml_super where int_col = 2;

insert into dml_0001 values(1,'test1',{1,2},s_a);
insert into dml_0001 values(2,'test2',{2,3},s_b);

select dml_0001 into s1_a from dml_0001 where int_col = 1;
select dml_0001 into s1_b from dml_0001 where int_col = 2;

insert into dml_0002 values(1,'test1',{1,2},s_a,s1_a);
insert into dml_0002 values(2,'test2',{2,3},s_b,s1_b);

select dml_0002 into s2_a from dml_0002 where int_col = 1;
select dml_0002 into s2_b from dml_0002 where int_col = 2;

insert into dml_0003 values(1,'test1',{1,2},s_a,s1_a,s2_a);
insert into dml_0003 values(2,'test2',{2,3},s_b,s1_b,s2_b);

select dml_0003 into s3_a from dml_0003 where int_col = 1;
select dml_0003 into s3_b from dml_0003 where int_col = 2;

insert into dml_0004 values(1,'test1',{1,2},s_a,s1_a,s2_a,s3_a);
insert into dml_0004 values(2,'test2',{2,3},s_b,s1_b,s2_b,s3_b);

select dml_0004 into s4_a from dml_0004 where int_col = 1;
select dml_0004 into s4_b from dml_0004 where int_col = 2;

insert into dml_0005 values(1,'test1',{1,2},s_a,s1_a,s2_a,s3_a,s4_a);
insert into dml_0005 values(2,'test2',{2,3},s_b,s1_b,s2_b,s3_b,s4_b);

select a.ref4_col.ref3_col.ref2_col.ref1_col.int_col, b.var_col
from dml_0005 a, dml_v_join_2 b
where a.int_col = b.int_col and a.int_col = 1 order by 1,2;

select a.ref3_col.int_col, c.ref_col.var_col, d.ref2_col.ref3_col.ref2_col.ref1_col.ref_col.set_col
from dml_0004 a left outer join dml_0005 b on a.int_col=b.int_col,dml_v_view_3 c, dml_v_join_1 d
where a.int_col=c.int_col and c.int_col=d.int_col order by 1,2,3;

select a.int_col, b.var_col, c.set_col
from dml_v_view_2 a, dml_v_normal_2 b, dml_v_inherit_2 c
where a.int_col=b.int_col and b.int_col=c.int_col order by 1,2,3;

select a.ref2_col.ref3_col.ref2_col.ref1_col.ref_col.int_col, 
		 b.ref4_col.ref3_col.ref2_col.ref1_col.ref_col.var_col, 
		 c.ref4_col.ref3_col.ref2_col.ref1_col.ref_col.set_col
from dml_v_join_2 a, dml_0005 b right outer join dml_0005 c on b.int_col=c.int_col
where a.int_col=b.int_col and a.int_col=c.int_col order by 1,2,3;

select a.int_col, b.var_col, a.set_col
from all dml_super(except(dml_0001,dml_0002,dml_0003,dml_0004,dml_0005)) a, 
all dml_vsuper (except(dml_v_join_1,dml_v_join_2,dml_v_join_3,dml_v_join_4,dml_v_view_1,dml_v_view_2,dml_v_view_3,dml_v_view_4)) b
where a.int_col = b.int_col and a.int_col = 1 order by 1,2,3;

select a.ref3_col.int_col, c.ref_col.var_col, 
d.ref2_col.ref3_col.ref2_col.ref1_col.ref_col.set_col
from dml_0004 a left outer join dml_0005 b on a.int_col=b.int_col,dml_v_view_3 c, dml_v_join_2 d
where a.int_col=c.int_col and c.int_col=d.int_col
order by 1,2,3;

select a.ref_col.int_col, b.ref1_col.ref_col.var_col,c.set_col,d.ref_col
from dml_0001 a LEFT OUTER JOIN dml_0002 b on a.int_col = b.int_col 
RIGHT OUTER JOIN dml_0003 c on c.int_col = b.int_col,dml_v_view_6 d
order by 1,2,3,4;

drop vclass dml_v_inherit_2 ;
drop vclass dml_v_inherit_1 ;
drop vclass dml_v_join_5 ;
drop vclass dml_v_join_4 ;
drop vclass dml_v_join_3 ;
drop vclass dml_v_join_2 ;
drop vclass dml_v_join_1 ;
drop vclass dml_v_view_6 ;
drop vclass dml_v_view_5 ;
drop vclass dml_v_view_4 ;
drop vclass dml_v_view_3 ;
drop vclass dml_v_view_2 ;
drop vclass dml_v_view_1 ;
drop vclass dml_v_normal_2 ;
drop vclass dml_v_normal_1 ;
drop vclass dml_vsuper ;
drop class dml_0005 ;
drop class dml_0004 ;
drop class dml_0003 ;
drop class dml_0002 ;
drop class dml_0001 ;
drop class dml_super ;
commit;
--+ holdcas off;
set system parameters 'create_table_reuseoid=yes';
