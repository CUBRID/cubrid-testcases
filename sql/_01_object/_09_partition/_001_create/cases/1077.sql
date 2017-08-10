--[er]create range range partition table with a name having a space

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
    PARTITION aa bb VALUES LESS THAN (6)
);

drop class range_test;
