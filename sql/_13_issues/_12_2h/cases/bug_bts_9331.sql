CREATE TABLE "actions"(
"action_id" smallint,
"user_id" integer,
"page_id" integer,
"action_type_id" integer,
"source_type_id" integer,
"action_when" datetime,
"action_count" smallint,
"action_weight" smallint
);

CREATE TABLE "users"(
"user_id" integer,
"user_name" character varying(4096),
"user_email" character varying(4096),
"user_nickname" character varying(4096),
"user_firstname" character varying(4096),
"user_lastname" character varying(4096)
);

insert into "actions" ("action_id", "user_id", "page_id", "action_type_id", "source_type_id", "action_when", "action_count", "action_weight") values (15, 14, 100274, 1, 1, DATETIME'2012-09-21 19:39:18.000', 0, 0);
insert into "actions" ("action_id", "user_id", "page_id", "action_type_id", "source_type_id", "action_when", "action_count", "action_weight") values (16, 15, 100274, 1, 1, DATETIME'2012-09-21 20:39:18.000', 0, 0);
insert into "actions" ("action_id", "user_id", "page_id", "action_type_id", "source_type_id", "action_when", "action_count", "action_weight") values (18, 16, 100275, 1, 1, DATETIME'2012-09-22 21:39:18.000', 0, 0);
insert into "actions" ("action_id", "user_id", "page_id", "action_type_id", "source_type_id", "action_when", "action_count", "action_weight") values (19, 15, 100274, 2, 1, DATETIME'2012-09-22 22:39:18.000', 0, 0);
insert into "actions" ("action_id", "user_id", "page_id", "action_type_id", "source_type_id", "action_when", "action_count", "action_weight") values (20, 15, 100274, 3, 1, DATETIME'2012-09-22 23:39:18.000', 0, 0);
insert into "users" ("user_id", "user_name", "user_email", "user_nickname", "user_firstname", "user_lastname") values (14, 'Tester1', 'tester@domainame.com', '4 Name', 'Test', 'Name');
insert into "users" ("user_id", "user_name", "user_email", "user_nickname", "user_firstname", "user_lastname") values (15, 'Tester2', 'tester@domainame.com', '4 Name', 'Test', 'Name');
insert into "users" ("user_id", "user_name", "user_email", "user_nickname", "user_firstname", "user_lastname") values (16, 'Tester3', 'tester@domainame.com', '4 Name', 'Test', 'Name');
CREATE VIEW actions_users AS
SELECT
    actions.action_id AS action_id,
    actions.user_id AS user_id,
    actions.page_id AS page_id,
    actions.action_type_id AS action_type_id,
    actions.action_when AS action_when,
    users.user_name AS username,
    users.user_nickname AS nickname
FROM
    actions LEFT JOIN users ON actions.user_id = users.user_id
ORDER BY actions.action_when ASC;
SELECT * from actions_users;
SELECT username from actions_users;
drop actions;
drop users;
drop view actions_users;
