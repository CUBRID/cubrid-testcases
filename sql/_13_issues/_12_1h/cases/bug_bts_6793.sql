CREATE TABLE blogtopic (topicId INTEGER, postDate DATE, closedDate DATE);
CREATE INDEX i_b_id ON blogtopic (topicId) WHERE 1=0;
drop table blogtopic ;
CREATE TABLE blogtopic (topicId INTEGER not null, postDate DATE, closedDate DATE);
CREATE INDEX i_b_id ON blogtopic (topicId) WHERE 1=0;
drop table blogtopic ;
CREATE TABLE blogtopic (topicId INTEGER not null, postDate DATE, closedDate DATE);
CREATE INDEX idx  ON blogtopic (topicId) WHERE 1=0;
drop table blogtopic ;