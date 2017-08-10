--[er]create range partition table with duplicate partition name

CREATE TABLE range_test (
    id INT NOT NULL,
    fname VARCHAR(30),
    lname VARCHAR(30),
    hired DATE  DEFAULT '1970-01-01' NOT NULL,
    separated DATE DEFAULT '9999-12-31'  NOT NULL,
    job_code INT NOT NULL,
    store_id int NOT NULL
)
PARTITION BY RANGE (store_id) (
    PARTITION p0 VALUES LESS THAN (6),
    PARTITION p1 VALUES LESS THAN (15),
    PARTITION p1 VALUES LESS THAN MAXVALUE
);

drop class range_test;
