drop if exists u01;
create table u01
(id int primary key, 
col1 timestamp default CURRENT_TIMESTAMP unique, 
col2 timestamp default CURRENT_TIMESTAMP on update current_timestamp not null, 
col3 timestamp default CURRENT_TIMESTAMP on update current_timestamp, 
col4 timestamp default CURRENT_TIMESTAMP
);

insert into u01 values(1, timestamp'12/12/2000 12:12:12', '12/12/2000 12:12:12', '12/12/2000 12:12:12', '12/12/2000 12:12:12');
insert into u01 values(2, timestamp'11/11/2000 11:11:11', '11/11/2000 11:11:11', '11/11/2000 11:11:11', '11/11/2000 11:11:11');
insert into u01 values(3, timestamp'10/10/2000 10:10:10', '10/10/2000 10:10:10', '10/10/2000 10:10:10', '10/10/2000 10:10:10');
insert into u01 values(4, timestamp'09/09/2000 09:09:09', '09/09/2000 09:09:09', '09/09/2000 09:09:09', '09/09/2000 09:09:09');
insert into u01 values(5, timestamp'08/08/2000 08:08:08', '08/08/2000 08:08:08', '08/08/2000 08:08:08', '08/08/2000 08:08:08');

update u01 set col2=default;
select if (current_timestamp - col2 >=0 and current_timestamp -col2<10, 'ok', 'nok') from u01;
select if (current_timestamp - col3 >=0 and current_timestamp -col3<10, 'ok', 'nok') from u01;
set @a=(select col2 from u01 where id=1);
select sleep(5);
update u01 set col1=default where id=1;
select if (col2-to_timestamp(@a) >=5 and col2-to_timestamp(@a) <10, 'ok', 'nok') from u01 where id=1;
select if (col3-to_timestamp(@a) >=5 and col3-to_timestamp(@a)<10, 'ok', 'nok') from u01 where id=1;
set @c=(select col3 from u01 where id=1);
select sleep(5);
update u01 set col2=default where id > 1 order by id desc;
select if (col2-to_timestamp(@c) >=5 and col2-to_timestamp(@c) <10, 'ok', 'nok') from u01 where id>1;
select if (col3-to_timestamp(@c) >=5 and col3-to_timestamp(@c)<10, 'ok', 'nok') from u01 where id>1;
select if ((@c - col2) =0 && (@c - col3) =0, 'ok', 'nok') from u01 where id=1;
drop table u01;
drop variable @a;
drop variable @c;

drop table if exists `p`;
CREATE TABLE  `p` (
`id` INT(11) NOT NULL AUTO_INCREMENT ,
`_lastmod` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
PRIMARY KEY (`id`) );
show columns from `p`;

drop table if exists `p`;
CREATE TABLE  `p` (
`id` INT(11) NOT NULL AUTO_INCREMENT ,
`_lastmod` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE now(),
PRIMARY KEY (`id`) );
show columns from `p`;


drop table if exists test;
create table test(c1 int primary key, c2 timestamp ); 
alter table test alter column c2 set default current_timestamp;
alter table test alter column c2 set default now();
alter table test alter column c2 set default '2015-01-01 01:01:01';
show columns from test;


drop table if exists `film_actor`,`actor`;
 CREATE TABLE `actor` (
  `actor_id` smallint NOT NULL AUTO_INCREMENT,
  `first_name` varchar(45) NOT NULL,
  `last_name` varchar(45) NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`actor_id`),
  KEY `idx_actor_last_name` (`last_name`)
) ;
CREATE TABLE `film_actor` (
  `actor_id` smallint NOT NULL,
  `film_id` smallint  NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`actor_id`,`film_id`),
  KEY `idx_fk_film_id` (`film_id`),
  CONSTRAINT `fk_film_actor_actor` FOREIGN KEY (`actor_id`) REFERENCES `actor` (`actor_id`) 
  ON DELETE CASCADE 
);

insert into `actor` values(1,'a','b',default);
insert into `actor` values(2,'c','d',default);
insert into `film_actor` values(1,100,default);
insert into `film_actor` values(1,50,default);
insert into `film_actor` values(1,40,default);
insert into `film_actor` values(1,10,default);
insert into `film_actor` values(1,20,default);
insert into `film_actor` values(1,30,default);
set @a=(select `last_update` from film_actor limit 1);
update actor set actor_id=300 where actor_id=2;
select if(current_timestamp-`last_update`>=0 and current_timestamp-`last_update`<10,'ok','nok') from actor where actor_id=300;
--CUBRID error: foreign table `actor_id` has been set null,but `last_update` can not update automatically
select if(`last_update`-to_timestamp(@a)<10,'ok','nok') from film_actor;

drop table if exists `film_actor`,`actor`;
 CREATE TABLE `actor` (
  `actor_id` smallint AUTO_INCREMENT,
  `first_name` varchar(45) ,
  `last_name` varchar(45) ,
  `last_update` timestamp  DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`actor_id`)
) ;
CREATE TABLE `film_actor` (
  `actor_id` smallint ,
  `film_id` smallint  ,
  `last_update` timestamp  DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT `fk_film_actor_actor` FOREIGN KEY (`actor_id`) REFERENCES `actor` (`actor_id`)
  ON UPDATE set NULL
);


insert into `actor` values(1,'a','b',default);
insert into `actor` values(2,'c','d',default);
insert into `film_actor` values(1,100,default);
insert into `film_actor` values(1,50,default);
insert into `film_actor` values(1,40,default);
insert into `film_actor` values(1,10,default);
insert into `film_actor` values(1,20,default);
insert into `film_actor` values(1,30,default);
set @a=(select  `last_update` from film_actor where actor_id=1 limit 1);
select sleep(2);
update actor set actor_id=300 where actor_id=1;
select if(current_timestamp-`last_update`>=0 and current_timestamp-`last_update`<10,'ok','nok') from actor where actor_id=300;

--CUBRID error: foreign table `actor_id` has been set null,but `last_update` can not update automatically
select if(`last_update`-to_timestamp(@a)<10,'ok','nok') from film_actor;
drop table if exists `film_actor`,`actor`;


DROP TABLE IF EXISTS t2,t1,t3;
CREATE TABLE t1 (a INT NOT NULL, b char(10), PRIMARY KEY (a),c timestamp on update current_timestamp);
CREATE TABLE t2 (a INT PRIMARY KEY, f_a INT, INDEX fk_a (f_a), b char(50),c timestamp on update current_timestamp,
        FOREIGN KEY (f_a) REFERENCES t1(a)  ON update SET NULL);
CREATE TABLE t3 (a INT NOT NULL,b timestamp on update current_timestamp);

create trigger tr_t2 after update on t2
        execute update t3 set a=a+1;

insert into t1(a,b) values (1,'A');
insert into t1(a,b) values (2,'B');
insert into t1(a,b) values (3,'C');
insert into t2(a,f_a,b) values (1,2,'E 1');
insert into t2(a,f_a,b) values (2,2,'E 2');
insert into t2(a,f_a,b) values (3,2,'E 3');
insert into t2(a,f_a,b) values (4,2,'E 4');
insert into t2(a,f_a,b) values (5,2,'E 5');
insert into t3(a) values(1);

select * from t1 order by 1,2;
select * from t2 order by 1,2,3;
select * from t3 order by 1;

update t1 set a=4 where a=2;

select if(current_timestamp-c>=0 and current_timestamp-c<10,'ok','nok') from t1 where a=4;
--CUBRID error: foreign table t2 has been set null,but c can not update automatically
select * from t2 order by 1;
select * from t3 order by 1;

update t2 set b='Emp 5a' where a=5;
select if(current_timestamp-c>=0 and current_timestamp-c<10,'ok','nok') from t2 where a=5;
select if(current_timestamp-b>=0 and current_timestamp-b<10,'ok','nok') from t3;

drop variable @a;
drop table if exists t2,t1,t3,test,p;



