--[er]test partition name using a string with a space
CREATE TABLE list_test (
    id INT NOT NULL,
    fname VARCHAR(30),
    lname VARCHAR(30),
    hired DATE  DEFAULT '1970-01-01' NOT NULL,
    separated DATE DEFAULT '9999-12-31'  NOT NULL,
    job_code INT NOT NULL,
    store_id int NOT NULL
)
PARTITION BY LIST(store_id) (
    PARTITION 'aa bb' VALUES IN (6)
);
drop table list_test;
