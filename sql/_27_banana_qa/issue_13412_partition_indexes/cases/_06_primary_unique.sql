drop table if exists t;
create table t(name  varchar(50),id int primary key AUTO_INCREMENT) 
partition by range(id)(
  partition beforec values less than(6),
  partition beforef values less than(12),
  partition beforel values less than MAXVALUE
 
);
 insert into t values ('aaabbbcccddd',null);
 insert into t values ('aaabbbcccdde ',null);
 insert into t values ('aaabbbcccddf ',null);
 insert into t values ('aaabbbccdddd ',null);
 insert into t values ('aaabbbcceddd ',null);
 insert into t values ('aaabbbccfddd ',null);
 insert into t values ('aaabbdcccddd ',null);
 insert into t values ('aaabbecccddd ',null);
 insert into t values ('aaabbfcccddd ',null);
 insert into t values ('aaabbbcccddd ',null);
 insert into t values ('daabbbcccddd ',null);
 insert into t values ('daabbbcccdde ',null);
 insert into t values ('daabbbcccddf ',null);
 insert into t values ('daabbbccdddd ',null);
 insert into t values ('daabbbcceddd ',null);
 insert into t values ('daabbbccfddd ',null);
 insert into t values ('eaabbbcccddd ',null);
 insert into t values ('faabbbcccddd ',null);
 insert into t values ('gaabbbcccddd ',null);
 insert into t values ('haabbbcccddd ',null);
 insert into t values ('iaabbbcccddd ',null);
 insert into t values ('jaabbbcccddd ',null);
 insert into t values ('kaabbbcccddd ',null);

 create unique index idx_name on t(id);
 create unique index idx_name on t(id);
 drop t;
 

drop table if exists t;
create table t(name  varchar(50) default 'aaaa',id int ,unique(name,id)) 
partition by range(id)(
  partition beforec values less than(6),
  partition beforef values less than(12),
  partition beforel values less than MAXVALUE
 );


drop table if exists t;
create table t(name  varchar(50),id int  AUTO_INCREMENT) 
partition by range(id)(
  partition beforec values less than(6),
  partition beforef values less than(12),
  partition beforel values less than MAXVALUE
 
);
 insert into t values ('aaabbbcccddd',null);
 insert into t values ('aaabbbcccdde ',null);
 insert into t values ('aaabbbcccddf ',null);
 insert into t values ('aaabbbccdddd ',null);
 insert into t values ('aaabbbcceddd ',null);
 insert into t values ('aaabbbccfddd ',null);
 insert into t values ('aaabbdcccddd ',null);
 insert into t values ('aaabbecccddd ',null);
 insert into t values ('aaabbfcccddd ',null);
 insert into t values ('aaabbbcccddd ',null);
 insert into t values ('daabbbcccddd ',null);
 insert into t values ('daabbbcccdde ',null);
 insert into t values ('daabbbcccddf ',null);
 insert into t values ('daabbbccdddd ',null);
 insert into t values ('daabbbcceddd ',null);
 insert into t values ('daabbbccfddd ',null);
 insert into t values ('eaabbbcccddd ',null);
 insert into t values ('faabbbcccddd ',null);
 insert into t values ('gaabbbcccddd ',null);
 insert into t values ('haabbbcccddd ',null);
 insert into t values ('iaabbbcccddd ',null);
 insert into t values ('jaabbbcccddd ',null);
 insert into t values ('kaabbbcccddd ',null);
create unique index idx_id on t__p__beforec (id);
alter table t promote partition beforec;
create unique index idx_id on t__p__beforec (id);
create unique index idx_name on t__p__beforec (name);
create unique index idx_id2 on t(id);
create unique index idx_name2 on t(name);
update statistics on all classes with fullscan;
show index from t__p__beforef;
show index from t__p__beforec;
show index from t__p__beforel;
  drop t__p__beforec;
 drop t;

