--02_first_last_nth_bug_from_web_001.sql
drop table if exists t,t1;

create table t( pk integer,id int primary key not null auto_increment ); 
insert into t(pk) values( 1 ); 
insert into t(pk) values( 2 ); 
insert into t(pk) values( null ); 
insert into t(pk) values( 2 ); 
insert into t(pk) values( null ); 
insert into t(pk) values( 4 ); 
select id,pk from t order by 1,2;

create table t1( pk integer,id int primary key not null auto_increment ); 
insert into t1(pk) values( 5 ); 
insert into t1(pk) values( 6 ); 
insert into t1(pk) values( null ); 
insert into t1(pk) values( 3 ); 
insert into t1(pk) values( null ); 
insert into t1(pk) values( 4 ); 
select id,pk from t1 order by 1,2;

select pk,first_value( pk ) OVER (  ) FROM (select id,pk from t order by 1) union (select id,pk from t1 order by 1);
select pk,first_value( pk ) OVER (  ) FROM ((select id,pk from t order by 1) union (select id,pk from t1 order by 1));
select pk,first_value( pk ) OVER (  ) FROM ((select id,pk from t order by 1 nulls first) union (select id,pk from t1 order by 1  nulls first));
select pk,first_value( pk ) OVER (  ) FROM ((select id,pk from t order by 1) union (select id,pk from t1 order by 1));
select pk,last_value( pk ) ignore nulls OVER (  ) FROM ((select id,pk from t order by 1) union (select id,pk from t1 order by 1));
select pk,last_value( pk ) OVER (  ) FROM ((select id,pk from t order by 1) union (select id,pk from t1 order by 1));
select pk,last_value( pk ) OVER (  ) FROM ((select id,pk from t order by 1) union (select id,pk from t1 order by 1) order by pk) ;
select pk,first_value( pk ) OVER (  ) FROM ((select id,pk from t order by 1) union (select id,pk from t1 order by 1) order by pk) ;
select pk,first_value( pk ) ignore nulls OVER (  ) FROM ((select id,pk from t order by 1) union (select id,pk from t1 order by 1) order by pk) ;

select groupid, itemno, first_value(itemno) ignore nulls over() as ret_val from T_FIRST_LAST_NTH order by itemno;
select groupid, itemno, first_value(itemno) over() as ret_val from T_FIRST_LAST_NTH order by itemno;

select pk,first_value( pk ) OVER ( order by pk ) FROM (select id,pk from t order by 1) union (select id,pk from t1 order by 1);
select pk,first_value( pk ) OVER (partition by pk order by pk ) FROM (select id,pk from t order by 1) union (select id,pk from t1 order by 1);
select id,pk FROM (select id,pk from t order by 1) union (select id,pk from t1 order by 1); 

select pk,first_value( pk ) OVER (  ) FROM ((select id,pk from t order by 1) union all (select id,pk from t1 order by 1));
select pk,last_value( pk ) OVER (  ) FROM ((select id,pk from t order by 1) union all (select id,pk from t1 order by 1));
select pk,nth_value( pk,3 ) OVER (  ) FROM ((select id,pk from t order by 1) union all (select id,pk from t1 order by 1));

select pk,first_value( pk ) OVER ( order by pk  ) FROM ((select id,pk from t order by 1) union all (select id,pk from t1 order by 1));
select pk,last_value( pk ) OVER ( order by pk ) FROM ((select id,pk from t order by 1) union all (select id,pk from t1 order by 1));
select pk,nth_value( pk,3 ) OVER ( order by pk ) FROM ((select id,pk from t order by 1) union all (select id,pk from t1 order by 1));

select pk,last_value( pk ) OVER ( order by pk ) FROM ((select id,pk from t order by 1) union all (select id,pk from t1 order by 1));
select pk,first_value( pk ) OVER ( order by pk  ) FROM ((select id,pk from t order by 1) union all (select id,pk from t1 order by 1));

drop table if exists t,t1;

drop al_cr_all;
drop al_to_category;
drop table if exists al_ca_category,al_ca_type,al_ca_class,al_cr,ca_category,ca_type,ca_class,price;

CREATE TABLE price ( 
    id_price int primary key not null auto_increment
); 
CREATE TABLE ca_class ( 
    id_ca_class int primary key not null auto_increment, 
    ca_class_name char(20) not null 
); 
CREATE TABLE ca_type ( 
    id_ca_type int primary key not null auto_increment, 
    id_ca_class integer references ca_class not null, 
    ca_type_name char(20) not null, 
    ca_type_code char(20) not null 
); 
CREATE TABLE ca_category ( 
    id_ca_category int primary key not null auto_increment, 
    id_ca_type integer references ca_type not null, 
    ca_cat_name char(20), 
    ca_cat_code char(20) 
); 
CREATE TABLE al_cr ( 
    id_al_cr int primary key not null auto_increment, 
    enabled int default 1 not null, 
    md5_code char(20)  
); 
CREATE TABLE al_ca_category ( 
    id_al_cr integer references al_cr, 
    id_ca_category integer references ca_category not null 
); 
CREATE TABLE al_ca_type ( 
    id_al_cr integer references al_cr, 
    id_ca_type integer references ca_type not null 
); 
CREATE TABLE al_ca_class ( 
    id_al_cr integer references al_cr, 
    id_ca_class integer references ca_class not null 
); 
CREATE VIEW al_cr_all AS 
    select c.*, ac.enabled 
        from ( 
                select 'class' as type,cl.ca_class_name as type_name,ac.* 
                from al_ca_class ac 
                join ca_class cl on (cl.id_ca_class) 
    union all 
       ( select 'type' as type,cl.ca_class_name||case when cl.ca_class_name = 
ct.ca_type_name then '' else ' ~ '||ct.ca_type_name end as 
type_name,ac.* 
                from al_ca_type ac 
                join ca_type ct on (ct.id_ca_type) 
                join ca_class cl on (cl.id_ca_class) )
    union all 
         (       select 'category' as type,cl.ca_class_name|| 
                case when cl.ca_class_name = ct.ca_type_name 
                then '' else ' ~ '||ct.ca_type_name end||' ~ '
                as type_name,ac.* 
                from al_ca_category ac 
                join ca_type ct on ( ct.id_ca_type) 
                join ca_class cl on (cl.id_ca_class) 
        )
        ) 
    as c join al_cr ac on ( ac.id_al_cr); 

create view al_to_category as 
        select ac.*, cl.ca_class_name, ct.ca_type_name, cc.ca_cat_name, 
    cc.id_ca_category, cc.ca_cat_code, 
    case when type='class' then cl.ca_class_name 
    when type='type' then ct.ca_type_name 
    when type='category' then ct.ca_type_name||' '||cc.ca_cat_code 
    end as ca_name 
    from al_cr_all ac 
    left join ca_class cl on ( 
                (ac.type = 'class' and cl.id_ca_class=ac.id_ca_class)        
        ) 
    join ca_type ct on ( 
                (ac.type = 'class' and  ct.id_ca_class=cl.id_ca_class)                
        ) 
    join ca_category cc on ( 
                (ac.type = 'category' and cc.id_ca_category=ac.id_ca_class)                 
        ); 

select 
first_value(max(p.id_price)) over () as id_price1 
,ac.ca_name 
        from al_to_category ac 
        join price p on (p.id_price=ac.id_al_cr) 
        group by ac.ca_name; 



drop al_cr_all;
drop al_to_category;
drop table if exists al_ca_category,al_ca_type,al_ca_class,al_cr,ca_category,ca_type,ca_class,price;


drop table if exists l_f_t;
CREATE TABLE l_f_t
(pk int,
id int,
s DATE);

INSERT INTO l_f_t
VALUES (1, 1, '8/8/2011');
INSERT INTO l_f_t
VALUES (2, 1, null);
INSERT INTO l_f_t
VALUES (3, 1,'8/20/2011');
INSERT INTO l_f_t
VALUES (4, 2,'8/18/2011');
INSERT INTO l_f_t
VALUES (5, 2,null);

SELECT id, s from l_f_t order by 1,2;
SELECT id, FIRST_VALUE(s) OVER (PARTITION BY ID ORDER BY s DESC NULLS LAST) from l_f_t order by 1,2;
SELECT id, FIRST_VALUE(s) OVER (PARTITION BY ID ORDER BY s DESC NULLS FIRST) from l_f_t order by 1,2;
SELECT id, LAST_VALUE(s) OVER (PARTITION BY ID ORDER BY s NULLS LAST) from l_f_t order by 1,2;
SELECT id, LAST_VALUE(s) OVER (PARTITION BY ID ORDER BY s NULLS FIRST) from l_f_t order by 1,2;
drop table if exists l_f_t;

drop table if exists t_h;
create table t_h(i int, p int, e varchar(10));

insert into t_h values(1,0,'A');
insert into t_h values(2,1,null);
select i, p,e from t_h order by 1;
select i, p,e from t_h start with i=2 connect by prior p=i order by 1;
select i,p,e,first_value(e) over(partition by connect_by_root p order by e nulls first)
from t_h
start with i=2
connect by prior p=i order by 1;

select i,p,e,first_value(e) over(partition by connect_by_root p order by e nulls last)
from t_h
start with i=2
connect by prior p=i order by 1;

drop table if exists t_h;

drop table if exists t;
create table t(e int ,s int ,r int);
insert into t values (101, 720,1);
insert into t values (102, 850,2);
insert into t values (103,1250,3);
insert into t values (105,1700,4);

select e,s, r from t order by 1;
select e,s, r,
nth_Value(e,r) over(order by e ) as emp,
nth_Value(s,r) over(order by s ) as sal
  from t order by 1;

drop table if exists t;   
