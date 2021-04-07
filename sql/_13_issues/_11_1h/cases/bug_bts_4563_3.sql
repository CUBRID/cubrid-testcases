-- covering index - ascending index
--+ holdcas on;


create table t1 (i1 int, i2 int, i3 int);

insert into t1 value (1,2,1);
insert into t1 value (1,2,2);
insert into t1 value (1,2,3);
insert into t1 value (1,2,4);
insert into t1 value (1,2,4);
insert into t1 value (1,2,5);
insert into t1 value (1,2,6);


insert into t1 value (1,3,1);
insert into t1 value (1,3,2);
insert into t1 value (1,3,3);
insert into t1 value (1,3,4);
insert into t1 value (1,3,5);
insert into t1 value (1,3,5);
insert into t1 value (1,3,6);	


insert into t1 value (1,4,1);
insert into t1 value (1,4,2);
insert into t1 value (1,4,3);
insert into t1 value (1,4,4);
insert into t1 value (1,4,4);
insert into t1 value (1,4,5);
insert into t1 value (1,4,5);

create index i_t1_i1_i2_i3  on t1(i1,i2,i3);



create table t2 (j1 int,j2 int);


insert into t2 value (1,3);	
insert into t2 value (1,4);
			
insert into t2 value (2,4);


create index  i_t2_j1_j2 on t2(j1,j2);

update statistics on t1;
update statistics on t2;

set system parameters 'multi_range_optimization_limit=0';

--join --1 ; join condition on col of range search
select /*+ recompile ordered */ * from t1 join t2 on t1.i1 = t2.j1 and t1.i3 = t2.j2 where t1.i1 = 1 and t1.i2 in (2,3,4) and t1.i3 > 2 and t1.i3 < 6 order by t1.i3 limit 4;

--join --2 ; 
select /*+ recompile ordered */ * from t2 join t1 on t1.i1 = t2.j1 and t1.i3 = t2.j2 where t1.i1 = 1 and t1.i2 in (2,3,4) and t1.i3 > 2 and t1.i3 < 6 order by t1.i3 limit 4;

--join --3 ; join condition on col which is not in range search
select /*+ recompile ordered */ * from t1 join t2 on t1.i1 = t2.j1 and t1.i2 = t2.j2 where t1.i1 = 1 and t1.i2 in (2,3,4) and t1.i3 > 2 and t1.i3 < 6 order by t1.i3 limit 4;


set system parameters 'multi_range_optimization_limit=100';

--join --1 ; join condition on col of range search
select /*+ recompile */ * from t1 join t2 on t1.i1 = t2.j1 and t1.i3 = t2.j2 where t1.i1 = 1 and t1.i2 in (2,3,4) and t1.i3 > 2 and t1.i3 < 6 order by t1.i3 limit 4;

--join --2 ; 
select /*+ recompile */ * from t2 join t1 on t1.i1 = t2.j1 and t1.i3 = t2.j2 where t1.i1 = 1 and t1.i2 in (2,3,4) and t1.i3 > 2 and t1.i3 < 6 order by t1.i3 limit 4;

--join --3 ; join condition on col which is not in range search
select /*+ recompile */ * from t1 join t2 on t1.i1 = t2.j1 and t1.i2 = t2.j2 where t1.i1 = 1 and t1.i2 in (2,3,4) and t1.i3 > 2 and t1.i3 < 6 order by t1.i3 limit 4;



drop t1;
drop t2;


create table t(i int, j int);
create table u(i int, j int, k int);

create index i_t_j_i on t(j, i);
create index i_u_i_j_k_d  on u(i, j, k desc);

insert into t values (0,0),(1,0),(2,0),(3,0),(4,0),(5,0),(6,0);
insert into t values (0,1),(1,1),(2,1),(3,1),(4,1),(5,1),(6,1);

insert into u values (1,3,0),(1,3,1),(1,3,2);
insert into u values (2,3,0),(2,3,1),(2,3,2),(2,3,3),(2,3,-4),(2,3,5);
insert into u values (2,4,0),(2,4,1),(2,4,2),(2,4,3),(2,4,-4),(2,4,6);
insert into u values (2,5,0),(2,5,1),(2,5,2),(2,5,3),(2,5,4),(2,5,-6);

update statistics on t;
update statistics on u;

set system parameters 'multi_range_optimization_limit=0';

select /*+ recompile */ u.* from t,u where	t.i = u.j and t.j = 1 and u.i = 2 and u.j in (3,4,5) order by u.k desc limit 3;

set system parameters 'multi_range_optimization_limit=100';

select /*+ recompile */ u.* from t,u where	t.i = u.j and t.j = 1 and u.i = 2 and u.j in (3,4,5) order by u.k desc limit 3;

drop t;
drop u;


create table t(i int, k int, p int);
create table u(i int, n int);

create index i_t_i_k_p_d  on t(i, k, p desc);

insert into u values (1,0),(1,1),(2,10),(3,10),(4,10);

insert into t values (0,1,2),(3,4,5),(6,7,8);
insert into t values (1,1,6),(1,1,4),(1,1,3);
insert into t values (1,2,5),(1,2,7),(1,2,2);
insert into t values (1,3,2),(1,3,1),(1,3,8);

update statistics on t;
update statistics on u;

set system parameters 'multi_range_optimization_limit=0';

select /*+ recompile */ t.i, t.k, t.p from t, u where	t.i = u.i and t.i = 1 and t.k in (1,2,3) order by t.p desc limit 5;

set system parameters 'multi_range_optimization_limit=100';

select /*+ recompile */ t.i, t.k, t.p from t, u where	t.i = u.i and t.i = 1 and t.k in (1,2,3) order by t.p desc limit 5;


drop t;
drop u;	


create table users(id int, name varchar(30));
create table posts(uid int, category varchar(30), entry_date date, title varchar(80));

create index i_users_name_id on users(name, id);
create index i_posts_uid_category_entry_date_d on posts(uid, category, entry_date desc);

insert into users values (1,'Joe'),(2,'Frank'),(3,'Ben'),(4,'Bill');

insert into posts values (1,'friends',date'2011-01-02','Recent trip');
insert into posts values (1,'cars',date'2011-01-02','Photos on the highway');
insert into posts values (2,'books',date'2011-02-04','A new library opens');
insert into posts values (3,'photos',date'2011-01-12','Mountain peak');
insert into posts values (3,'friends',date'2011-02-04','My new colleague');
insert into posts values (3,'games',date'2011-02-13','Expansion released');
insert into posts values (3,'games',date'2011-02-14','Strategy to win');
insert into posts values (3,'pets',date'2011-02-07','Talking parrot');
insert into posts values (3,'pets',date'2011-02-03','Training your pet');
insert into posts values (3,'books',date'2011-02-04','Bestsellers of last year');
insert into posts values (3,'friends',date'2011-02-05','The team and me');
insert into posts values (3,'cars',date'2011-02-03','New tires from the store');
insert into posts values (4,'friends',date'2010-11-12','Saturday evening');

update statistics on users;
update statistics on posts;

set system parameters 'multi_range_optimization_limit=0';

select /*+ recompile */ posts.title, posts.category, posts.entry_date from	posts, users where	users.name='Ben' and posts.uid=users.id and	posts.category in ('friends','books','games','pets') order by entry_date desc limit 5;

set system parameters 'multi_range_optimization_limit=100';

select /*+ recompile */ posts.title, posts.category, posts.entry_date from	posts, users where	users.name='Ben' and posts.uid=users.id and	posts.category in ('friends','books','games','pets') order by entry_date desc limit 5;

drop table users;
drop table posts;


commit;
--+ holdcas off;

