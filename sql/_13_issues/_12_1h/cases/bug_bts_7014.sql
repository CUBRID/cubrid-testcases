create table t(a char(3));
insert into t value('SQL');
--test: we expect idx is created successfully
CREATE INDEX idx ON t(lower (a));
drop table t;
