CREATE TABLE blogtopic (topicId INTEGER not null , postDate DATE, closedDate DATE);
insert into blogtopic value(1,DATE '2010-01-01',DATE '2010-01-02');
insert into blogtopic value(1,DATE '2010-01-01',null);
CREATE INDEX my_filter_index ON blogtopic (topicId) WHERE closedDate IS NULL;
--test it should use the index
select count(topicId) from blogtopic WHERE closedDate IS NULL using index my_filter_index(+);
drop table blogtopic;

