--+ holdcas on;

drop table if exists t;

create class t (i varchar, j string);

insert into t values('abc','def');

insert into t values(repeat('abc',200),'def');

insert into t values('abc',repeat('def',200));

insert into t values(repeat('abc',200),repeat('def',200)); 

-- normal index
create index idx_t on t(i,j);

create index idx_t1 on t(i,j desc);

create index idx_t_i on t(i);

create index idx_t_j on t(j);

-- filter index 
create index idx_t2 on t(i desc,j desc) where i>'a' and j<'m';

-- unique index
create unique index idx_t3 on t(i desc,j);

-- Function-based index
CREATE INDEX idx_t_func ON t(LEFT(i, 4));

alter table t add constraint pk_t primary key(i desc,j); 

alter table t add index i_idx(j desc,i desc);

ALTER TABLE t ADD CONSTRAINT t_key1 UNIQUE (i desc,j desc);

drop table t;

--+ holdcas off;