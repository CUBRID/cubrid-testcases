autocommit off;
select nullif(null, null) from class db_user order by 1;
select nullif(1, null) from class db_user order by 1;
select nullif(null, 1) from class db_user order by 1;
select nullif(1, 1) from class db_user order by 1;
select nullif('', ' ') from class db_user order by 1;
select nullif('a', ' a') from class db_user order by 1;
select nullif(nullif(10, 10.01), 10) from class db_user order by 1;
select nullif(nullif(10, 10.01), 11) from class db_user order by 1;
select nullif(B'1111', X'f') from class db_user order by 1;
select nullif($10.00, 10) from class db_user order by 1;
select nullif($10, 10.01) from class db_user order by 1;
select nullif(date '07/18/1992', date '07/18/1993') from class db_user order by 1;
select nullif({1, 2}, {'1', 2}) from class db_user order by 1;
select nullif(set{1, 2}, {2, 1}) from class db_user order by 1;
select nullif(set{1, 2}, set{2, 1}) from class db_user order by 1;
select nullif(set{'1', '2'}, multiset{'1', '2'}) from class db_user order by 1;
select coalesce(nullif(1, 1), 2) from class db_user order by 1;
select coalesce(nullif(1, 1), nullif(2, 2), nullif(3, 3))
from class db_user order by 1;
select coalesce(null, 'null', null) from class db_user order by 1;
select coalesce(coalesce(null, B'1111'), coalesce(X'f', B'1111'))
from class db_user order by 1;
select coalesce(1, 1.0, $1) from class db_user order by 1;
select  case null when 1 then 1 end from class db_user order by 1;
select case 1 when 1 then 1 end from class db_user order by 1;

select 	case 'a' 
	when ' a' then 1 
	when 'a ' then 2 
	when ' a ' then 3 
	else 4 end 
from class db_user order by 1,2;
select 	case B'1010' 
	when X'10' then X'10' 
	when X'a' then X'a' end
from class db_user order by 1,2;
select 	case {'1'} 
	when {1} then {'1'} 
	else case {1} 
	     when {1} then {1} end 
	end 
from class db_user order by 1,2;
select case when null<>0 then 1 end from class db_user order by 1,2;
select 	case 
	when 'a'>'b' then 'a' 
	else 'b' end 
from class db_user order by 1,2;
select 	case 
	when {1,2} seteq {2,1} then 'set' 
	else 'sequence' end 
from class db_user order by 1,2;
select 	case 
	when set{1,2} seteq set{2,1} then 'set' 
	else 'sequence' end 
from class db_user order by 1,2;
select 	case 
	when 3<0 then '-' 
	when 3=0 then '0' 
	when 3>0 then '+' end 
from class db_user order by 1,2;
select 	case 
	when 'a'<='b' then case 'a' 
			   when 'b' then 'a' 
			   else 'b' end 
	end 
from class db_user order by 1,2;
/* server side calls */
create class x (b_x 	bit(8),
		i_x	int,
		s_x	set(),
		str_x	string,
		tt_x	time);
create class y (b_y	bit(4),
		d_y	double,
		s_y	sequence(),
		str_y	varchar(20),
		tt_y	time);
create class z (m_z	monetary,
		str_z	char(3));
insert into x values (B'1111', 10, {'aaa',10,B'1111',time '11:12:13'},
		      'aaa', time '11:12:13');
insert into x (i_x) values (11);
insert into x (i_x) values (null);
insert into x (i_x) values (null);
insert into x (i_x) values (null);
insert into y values (B'1111', 10, {'aaa',10,B'1111',time '11:12:13'},
		      'aaa', time '11:12:13');
insert into y values (B'11', 11, {'bbb',11,B'11',time '21:22:23'},
		      'bbb', time '21:22:23');
insert into y (str_y) values ('ccc');
insert into y (str_y) values (null);
insert into y (str_y) values (null);
insert into z values (10, 'aaa');
insert into z values (11, 'bbb');
insert into z values (12, 'ccc');
insert into z values (13, 'ddd');
insert into z values (null, null);
select b_x, nullif(b_x, b_x) from x order by 1,2;
select i_x, d_y, nullif(i_x, d_y) from x, y 
where i_x is not null order by 1,2;
select str_x, nullif(str_x, 'aaa') from x order by 1,2;
select s_x, s_y, nullif(s_x, s_y) from x, y 
where s_x is not null order by 1,2;
select m_z, i_x, nullif(m_z, i_x) from x, z 
where m_z is not null order by 1,2;
select str_x, str_y, nullif(str_x, str_y) from x, y 
where str_x is not null order by 1,2;
select tt_x, tt_y, nullif(tt_x, tt_y) from x, y 
where tt_x is not null order by 1,2;
select b_x, b_y, coalesce(b_x, b_y) from x, y 
where b_x is not null or b_y is not null order by 1,2;
select i_x, d_y, m_z, coalesce(m_z, d_y, i_x) from x, y, z 
where i_x is not null or d_y is not null or m_z is not null order by 1,2;
select s_x, s_y, coalesce(s_x, s_y, {}) from x, y order by 1,2;
select str_x, str_y, str_z, coalesce(str_x, str_y, str_z, 'eee') 
from x, y, z order by 1,2;
select b_x, b_y, case B'1111' 
		 when b_x then b_x 
		 when b_y then b_y end 
from x, y where b_x is not null or b_y is not null order by 1,2;
select i_x, d_y, m_z, case m_z 
		      when i_x then i_x 
		      when d_y then d_y 
		      else 0 end 
from x, y, z order by 1,2;
select str_z, str_x, str_y, case str_z 
			    when str_x then str_x 
			    when str_y then str_y end 
from x, y, z 
where str_z is not null and (str_x is not null or str_y is not null) order by 1,2,3,4;
select b_x, b_y, case 
		 when b_y > b_x then b_y + b_x 
		 when b_x > b_y then b_x + b_y end 
from x, y 
where b_x is not null or b_y is not null order by 1,2;
select i_x, d_y, m_z, case 
		      when i_x >= d_y then case 
					   when i_x >= m_z then i_x 
					   else m_z end 
		      else case 
			   when d_y >= m_z then d_y 
			   else m_z end 
		      end 
from x, y, z 
where i_x is not null or d_y is not null or m_z is not null order by 1,2;
/* combined calls -- for testing parse tree optimization */
select i_x, d_y, case when 1=1 then i_x else d_y end from x, y order by 1,2;
select s_x, s_y, case when 1=1 then s_x else s_y end from x, y order by 1,2;
select s_x, s_y, case when 1=2 then s_x else s_y end from x, y order by 1,2;
select tt_x, tt_y, case when 1=1 then tt_x else tt_y end from x, y order by 1,2;
select tt_x, tt_y, case when 1=2 then tt_x else tt_y end from x, y order by 1,2;
select i_x, m_z, case 
		 when 1=1 then i_x 
		 else m_z end 
from x, z order by 1,2;
select i_x, d_y, case 
		 when i_x is not null then i_x 
		 when 1<2 then d_y end 
from x, y order by 1,2;
create class w (w1 numeric(16, 2),
		w2 numeric);
insert into w values (1234.12, 1235);
select w1, w2, case when 1=2 then w1 else w2 end from w order by 1,2;
rollback;
