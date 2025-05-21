/* ------------------------------------------------------------------------------------*/
/* 1. alter serial owner to sql syntax check                                           */
/*  In csql, the results for errors in sql statements are displayed as in the sentence below, but the actual answer is output as an error code value. */
/* ------------------------------------------------------------------------------------*/
create user test_user1;

create serial cubrid_seq;
select unique_name, name, owner.name, [comment] from db_serial where name = 'cubrid_seq';

alter serial cubrid_seq OWNER TO test_user1;
select unique_name, name, owner.name, [comment] from db_serial where name = 'cubrid_seq';

alter serial test_user1.cubrid_seq OWNER TO dba comment '1) owner to comment';
select unique_name, name, owner.name, [comment] from db_serial where name = 'cubrid_seq';

/* semantic check error */
alter serial cubrid_seq;

alter serial cubrid_seq2;

/* syntax error */
alter serial cubrid_seq start with 2 OWNER TO test_user1;

alter serial cubrid_seq increment by 2 OWNER TO test_user1;

alter serial cubrid_seq minvalue 3 OWNER TO test_user1;

alter serial cubrid_seq maxvalue 10 OWNER TO test_user1;

alter serial cubrid_seq cycle OWNER TO test_user1;

alter serial cubrid_seq OWNER TO test_user1 cycle;

alter serial cubrid_seq cache 3 OWNER TO test_user1;

alter serial cubrid_seq start with 1 OWNER TO test_user1 comment '2) start with owner to comment';

/* reset */
drop serial cubrid_seq;
drop user test_user1;

/* ------------------------------------------*/
/* 2. alter serial owner to permission check */
/* ------------------------------------------*/
create user test_user1 groups dba;
create user test_user2;

create serial cubrid_seq;
select unique_name, name, owner.name, [comment] from db_serial where name = 'cubrid_seq';

alter serial cubrid_seq OWNER TO test_user1;
select unique_name, name, owner.name, [comment] from db_serial where name = 'cubrid_seq';

CALL login ('test_user1', '') ON CLASS db_user;
alter serial cubrid_seq OWNER TO test_user2;
select unique_name, name, owner.name, [comment] from db_serial where name = 'cubrid_seq';

CALL login ('test_user2', '') ON CLASS db_user;
alter serial cubrid_seq OWNER TO test_user1;

/* reset */
CALL login ('dba', '') ON CLASS db_user;
drop serial test_user2.cubrid_seq;
drop user test_user1;
drop user test_user2;

/* ------------------------------------------------------------------------------------*/
/* 2-1. Test when created with serial cache and changed to another user                  */
/* ------------------------------------------------------------------------------------*/
create user test_user1;
create user test_user2;
create serial test_user1.cubrid_seq cache 5;
SELECT test_user1.cubrid_seq.nextval from dual;

alter serial test_user1.cubrid_seq OWNER TO test_user2;
SELECT unique_name, name, owner.name, current_val, cached_num, [comment] FROM db_serial WHERE name = 'cubrid_seq';

SELECT test_user2.cubrid_seq.nextval from dual;

alter serial test_user2.cubrid_seq comment 'test comment';
SELECT unique_name, name, owner.name, current_val, cached_num, [comment] FROM db_serial WHERE name = 'cubrid_seq';

SELECT test_user2.cubrid_seq.nextval from dual;

/* reset */
DROP serial test_user2.cubrid_seq;
DROP USER test_user1;
DROP USER test_user2;
/* ------------------------------------------------------------------------------------*/
/* 3. Test whether serial can be created in the view table                             */
/* ------------------------------------------------------------------------------------*/
create serial cubrid_seq;
create table tbl1 (col1 int, col2 varchar);
INSERT INTO tbl1  values (1,'a');
INSERT INTO tbl1  values (2,'b');
INSERT INTO tbl1  values (3,'c');

create view v_serial as select cubrid_seq.nextval from dual;

create view v_serial as insert into tbl1 select cubrid_seq.nextval, 'd' from dual;

/* Scalar Subquery */
CREATE VIEW v_serial AS SELECT t1.*, (SELECT cubrid_seq.NEXTVAL) as col3 FROM tbl1 t1;
select * from v_serial;

/* Inline View */
CREATE VIEW v_serial2 AS SELECT t1.* FROM (SELECT cubrid_seq.NEXTVAL, 'a' FROM dual) t1;
select * from v_serial2;

/* Subquery */
CREATE VIEW v_serial3 AS SELECT t1.* FROM (select * from tbl1 where col1 = (SELECT cubrid_seq.NEXTVAL)) t1;
select * from v_serial3;

/* reset */
drop view v_serial;
drop view v_serial2;
drop view v_serial3;
drop table tbl1;
drop serial cubrid_seq;

/* ------------------------------------------------------------------------------------*/
/* 4. Test changing ai serial owner in auto increment                                  */
/* ------------------------------------------------------------------------------------*/
create user test_user1;
create table tbl1 (col1 int auto_increment, col2 varchar);

alter serial tbl1_ai_col1 owner to test_user1;

select unique_name, name, owner.name from db_serial where name = 'tbl1_ai_col1';

alter table tbl1 owner to test_user1;
select unique_name, name, owner.name from db_serial where name = 'tbl1_ai_col1';

/* reset */
drop table test_user1.tbl1;
drop user test_user1;

