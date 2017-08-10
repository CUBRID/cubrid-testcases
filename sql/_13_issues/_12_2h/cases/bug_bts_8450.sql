drop table if exists z2;
create table z2 (a int, b int);

insert into z2 values (1,1);

--test: below result is strange.
SELECT @v1:=avg(b) over (partition by a order by b) FROM z2;

SELECT @v2:=sum(b) over (partition by a order by b) FROM z2;

SELECT distinct @v3:=avg(b) over (partition by a order by b) FROM z2;

SELECT distinct @v3:=max(b) over (partition by a order by b) FROM z2;

SELECT distinct @v3:=max(b) over (partition by a order by b+b) FROM z2;

SELECT distinct @v3:=max(b) over (partition by a+a order by b+b) FROM z2;

SELECT  @v3:=avg(b) over (partition by a+a order by b+b) FROM z2;

SELECT  @v3:=avg(b) over (partition by a+a order by b+b) FROM z2;

SELECT  @v3:=count(*) over (partition by a+a order by b+b) FROM z2;




drop table if exists z2;

create table z2 (a char(1), b varchar(1));

insert into z2 values (1,1);

--test: below result is strange.
SELECT @v1:=avg(b) over (partition by a order by b) FROM z2;

SELECT @v2:=sum(b) over (partition by a order by b) FROM z2;

SELECT distinct @v3:=avg(b) over (partition by a order by b) FROM z2;

SELECT distinct @v3:=max(b) over (partition by a order by b) FROM z2;

SELECT distinct @v3:=max(b) over (partition by a order by b+b) FROM z2;

SELECT distinct @v3:=max(b) over (partition by a+a order by b+b) FROM z2;

SELECT  @v3:=avg(b) over (partition by a+a order by b+b) FROM z2;

SELECT  @v3:=avg(b) over (partition by a+a order by b+b) FROM z2;

SELECT  @v3:=count(*) over (partition by a+a order by b+b) FROM z2;




drop table if exists z2;
create table z2 (a int, b int) partition by hash(b) partitions 2;

insert into z2 values (1,1);

SELECT @v1:=avg(b) over (partition by a order by b) FROM z2;

SELECT @v2:=sum(b) over (partition by a order by b) FROM z2;

SELECT distinct @v3:=avg(b) over (partition by a order by b) FROM z2;

SELECT distinct @v3:=max(b) over (partition by a order by b) FROM z2;

SELECT distinct @v3:=max(b) over (partition by a order by b+b) FROM z2;

SELECT distinct @v3:=max(b) over (partition by a+a order by b+b) FROM z2;

SELECT  @v3:=avg(b) over (partition by a+a order by b+b) FROM z2;

SELECT  @v3:=avg(b) over (partition by a+a order by b+b) FROM z2;

SELECT  @v3:=count(*) over (partition by a+a order by b+b) FROM z2;

SELECT  @v3:=count(b) over (partition by a+a order by b+b) FROM z2;

(SELECT  @v3:=count(b) over (partition by a+a order by b+b) FROM z2) union (SELECT  @v3:=count(b) over (partition by a+a order by b+b) FROM z2) ;

drop variable @v1;
drop variable @v2;
drop variable @v3;

drop table z2;
