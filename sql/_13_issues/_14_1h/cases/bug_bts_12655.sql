drop if exists xoo;
create table xoo(a int ,b char(10));
insert into xoo values(1,'a');
insert into xoo values(2,'b');
insert into xoo values(3,'c');
select round(a),row_number() over() rn from xoo order by 1;
drop xoo;

create table xoo(a double ,b char(10));
insert into xoo values(1.75,'a');
insert into xoo values(2.63,'b');
insert into xoo values(3.76,'c');
select round(a),row_number() over() rn from xoo order by 1;
drop xoo;

create table xoo(col1 blob ,col2 clob);
insert into xoo values(B'1011','aaa');
insert into xoo values(B'1100','bbb');
insert into xoo values(B'1111','ccc');
select blob_to_bit(col1),clob_to_char(col2) from xoo order by 1;
select blob_to_bit(col1), clob_to_char(col2), row_number() over() row_num from xoo order by 1;
drop xoo;

create table xoo(a int ,b char(10));
insert into xoo values(1,'a');
insert into xoo values(2,'b');
insert into xoo values(3,'c');
select round(a),row_number() over() rn from xoo order by 1;
drop xoo;

