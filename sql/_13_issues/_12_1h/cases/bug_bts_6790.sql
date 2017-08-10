CREATE TABLE blogtopic (topicId INTEGER, postDate DATE, closedDate DATE);
CREATE INDEX i_t_topicId ON blogtopic (topicId) WHERE postDate>'2010-01-01' OR closedDate IS NULL;
CREATE INDEX i_t_topicId_1 ON blogtopic (topicId) WHERE postDate>'2010-01-01' and (closedDate IS NULL or postDate is null);
CREATE INDEX i_t_topicId_2 ON blogtopic (topicId) WHERE 1=0 or postDate is null;
drop table blogtopic ;



