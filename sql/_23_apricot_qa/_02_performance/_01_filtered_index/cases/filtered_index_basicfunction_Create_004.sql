--+ holdcas on;
CREATE TABLE blogtopic (topicId INTEGER, postDate DATE, closedDate DATE);
insert into blogtopic value(1,DATE '2010-01-01',DATE '2010-01-02');
--test create index successfully
CREATE INDEX my_filter_index ON blogtopic (topicId) WHERE topicId IS NULL;
--test create index failed
CREATE INDEX my_filter_index1 ON blogtopic (topicId) WHERE LENGTH(topicId)>0;
--test create index failed 
CREATE INDEX my_filter_index2 ON blogtopic (topicId asc) WHERE LENGTH(topicId)>0;
--test create index successfully 
CREATE INDEX my_filter_index2 ON blogtopic (topicId desc) WHERE LENGTH(topicId)>0;
drop table blogtopic;
CREATE TABLE blogtopic (topicId INTEGER not null, postDate DATE, closedDate DATE);
insert into blogtopic value(1,DATE '2010-01-01',DATE '2010-01-02');
--test create index successfully
CREATE INDEX my_filter_index ON blogtopic (topicId) WHERE topicId IS NULL;
--test create index failed
CREATE INDEX my_filter_index1 ON blogtopic (topicId) WHERE LENGTH(topicId)>0;
--test create index failed 
CREATE INDEX my_filter_index2 ON blogtopic (topicId asc) WHERE LENGTH(topicId)>0;
--test create index successfully 
CREATE INDEX my_filter_index2 ON blogtopic (topicId desc) WHERE LENGTH(topicId)>0;
drop table blogtopic;
commit;
--+ holdcas off;
