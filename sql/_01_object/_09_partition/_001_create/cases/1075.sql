--[er]create range partition table with a wrong int partition name:999

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
    PARTITION 999 VALUES LESS THAN (6)
);

drop class range_test;
