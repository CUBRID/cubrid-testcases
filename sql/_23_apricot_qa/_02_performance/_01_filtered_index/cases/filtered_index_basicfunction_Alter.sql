--+ holdcas on;
CREATE TABLE blogtopic (topicId INTEGER not null, postDate DATE, closedDate DATE);
insert into blogtopic value(1,DATE '2010-01-01',DATE '2010-01-02');
CREATE INDEX my_filter_index ON blogtopic (topicId) WHERE closedDate IS NULL;
show index in blogtopic;
alter REVERSE index my_filter_index on blogtopic (topicId) WHERE postDate>'2010-01-01' AND closedDate IS NULL rebuild;
show index in blogtopic;
alter index my_filter_index on blogtopic (topicId) rebuild;
show index in blogtopic;

drop index my_filter_index on blogtopic;


CREATE UNIQUE INDEX my_filter_index ON blogtopic (topicId) WHERE closedDate IS NULL;
alter UNIQUE index my_filter_index on blogtopic (topicId) WHERE postDate>'2010-01-01' or closedDate IS not NULL rebuild;
alter UNIQUE index my_filter_index on blogtopic (topicId) WHERE postDate>'2010-01-01' or closedDate IS not NULL rebuild;

alter UNIQUE index my_filter_index on blogtopic (topicId,postDate) WHERE postDate>'2010-01-01' and topicId>1 rebuild;
show index in blogtopic;
drop UNIQUE index my_filter_index on blogtopic;


CREATE INDEX my_filter_index ON blogtopic (topicId);
alter index my_filter_index on blogtopic (topicId) WHERE closedDate IS NULL rebuild;
show index in blogtopic;

drop table blogtopic;

CREATE TABLE blogtopic (topicId INTEGER not null, postDate DATE, closedDate DATE);
insert into blogtopic value(1,DATE '2010-01-01',DATE '2010-01-02');
insert into blogtopic value(2,DATE '2010-01-01',null);
CREATE INDEX my_filter_index ON blogtopic (topicId) WHERE closedDate IS NULL;
select count(topicId) from blogtopic WHERE closedDate IS NULL using index my_filter_index(+);

drop table blogtopic;
CREATE TABLE blogtopic (topicId INTEGER not null, postDate DATE, closedDate DATE);
insert into blogtopic value(1,DATE '2010-01-01',DATE '2010-01-02');
insert into blogtopic value(2,DATE '2010-01-01',null); 
CREATE INDEX my_filter_index ON blogtopic (topicId) WHERE topicId >1;
--test using my_filter_index
select /*+ recompile */ count(topicId) from blogtopic WHERE topicId >1 using index my_filter_index(+);
alter REVERSE index my_filter_index on blogtopic (topicId) WHERE postDate>'2010-01-01' AND closedDate IS NULL rebuild;
--test not using my_filter_index
select /*+ recompile */ count(topicId) from blogtopic WHERE topicId >1 using index my_filter_index(+);
alter index my_filter_index on blogtopic (topicId)
--test using my_filter_index
select /*+ recompile */ count(topicId) from blogtopic WHERE topicId >1 using index my_filter_index(+);
drop table blogtopic;

CREATE TABLE blogtopic (topicId INTEGER not null, postDate DATE, closedDate DATE);
insert into blogtopic value(1,DATE '2010-01-01',DATE '2010-01-02');
insert into blogtopic value(2,DATE '2010-01-01',null); 
CREATE INDEX my_filter_index ON blogtopic (topicId);
--test using my_filter_index
select /*+ recompile */ count(topicId) from blogtopic WHERE topicId >1 ;
alter REVERSE index my_filter_index on blogtopic (topicId) WHERE topicId >1 rebuild;
--test using my_filter_index
select /*+ recompile */ count(topicId) from blogtopic WHERE topicId >1;
drop table blogtopic;
create table t(id integer, textlabel varchar(255), description varchar(4096));
insert into t(id, textlabel, description)
    values
	(10, 'aab', 'the textbook'),
	(11, 'xab', 'book description'),
	(12, 'xxy', 'book chapters'),
	(13, 'xa0', 'author names'),
	(14, 'xa1', 'xa1'),
	(15, 'xab', 'xab'),
	(16, 'aff', 'syntax description'),
	(17, 'afg', 'operators list');
create index idx_tdesc on t(description) where description < textlabel;
--test alter should failed
alter index idx_tdesc on t(description) where char_length(description) * rand() < 4 rebuild;
drop table t;

	
commit;
--+ holdcas off;
