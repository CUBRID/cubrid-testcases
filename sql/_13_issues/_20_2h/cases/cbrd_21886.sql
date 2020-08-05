DROP TABLE IF EXISTS auth_role_menu, auth_menu;

CREATE TABLE auth_role_menu (
role_id CHARACTER VARYING (20) NOT NULL,
menu_id CHARACTER VARYING (20) NOT NULL,
CONSTRAINT pk_auth_rmenu PRIMARY KEY(role_id, menu_id),
INDEX ix_auth_rolemenu1 (menu_id, role_id)
);

CREATE TABLE auth_menu (
menu_id CHARACTER VARYING (20) NOT NULL,
parent_id CHARACTER VARYING (20) NOT NULL,
res_id CHARACTER VARYING (20) NOT NULL,
menu_type CHARACTER(1) NOT NULL,
frame_type CHARACTER(1) NOT NULL,
is_request CHARACTER(1) NOT NULL,
is_secure CHARACTER(1) NOT NULL,
menu_key CHARACTER VARYING (225) NOT NULL,
seq INTEGER NOT NULL,
create_dt DATETIME NOT NULL,
modify_dt DATETIME NOT NULL,
name CHARACTER VARYING (128) NOT NULL,
prov_dt DATETIME NOT NULL,
prov_status CHARACTER(1) NOT NULL,
recon_dt DATETIME NOT NULL,
recon_status CHARACTER(1) NOT NULL,
code CHARACTER VARYING (128) NOT NULL,
display_name CHARACTER VARYING (128),
parent_path CHARACTER VARYING (1280),
default_icon_url CHARACTER VARYING (100),
selected_icon_url CHARACTER VARYING (100),
url CHARACTER VARYING (200),
sub_urls CHARACTER VARYING (1000),
description CHARACTER VARYING (400),
prov_msg CHARACTER VARYING (500),
recon_msg CHARACTER VARYING (500),
CONSTRAINT pk_auth_menu PRIMARY KEY(menu_id),
CONSTRAINT ix_auth_menu2 UNIQUE KEY(code, res_id),
INDEX ix_auth_menu1 (parent_id, res_id),
INDEX ix_auth_menu3 (menu_key, res_id),
INDEX ix_auth_menu4 (res_id)
);

SELECT a.auth_id, a.num
FROM
(
SELECT '-1001' auth_id, 1 num FROM db_root UNION ALL
SELECT '-1001' auth_id, 2 num FROM db_root UNION ALL
SELECT '-1002' auth_id, 1 num FROM db_root UNION ALL
SELECT '-1002' auth_id, 2 num FROM db_root UNION ALL
SELECT '-1003' auth_id, 1 num FROM db_root UNION ALL
SELECT '-1003' auth_id, 2 num FROM db_root UNION ALL
SELECT '-1004' auth_id, 1 num FROM db_root UNION ALL
SELECT '-1004' auth_id, 2 num FROM db_root ) a
LEFT OUTER JOIN auth_role_menu c ON DECODE ( a.num,3, a.auth_id, null) = c.role_id
LEFT OUTER JOIN auth_menu d ON DECODE ( a.num,3, c.menu_id, NULL ) = d.menu_id
WHERE (a.num=1 or a.num=2 ) ; 

SELECT a.auth_id, a.num
FROM
(
SELECT '-1001' auth_id, 1 num FROM db_root UNION ALL
SELECT '-1001' auth_id, 2 num FROM db_root UNION ALL
SELECT '-1002' auth_id, 1 num FROM db_root UNION ALL
SELECT '-1002' auth_id, 2 num FROM db_root UNION ALL
SELECT '-1003' auth_id, 1 num FROM db_root UNION ALL
SELECT '-1003' auth_id, 2 num FROM db_root UNION ALL
SELECT '-1004' auth_id, 1 num FROM db_root UNION ALL
SELECT '-1004' auth_id, 2 num FROM db_root ) a
LEFT OUTER JOIN auth_role_menu c ON (CASE WHEN a.num = 3 THEN a.auth_id ELSE  null END) = c.role_id
LEFT OUTER JOIN auth_menu d ON (CASE WHEN a.num = 3 THEN c.menu_id ELSE  NULL END) = d.menu_id
WHERE (a.num=1 or a.num=2 ) ; 

SELECT a.auth_id, a.num
FROM
(
SELECT '-1001' auth_id, 1 num FROM db_root UNION ALL
SELECT '-1001' auth_id, 2 num FROM db_root UNION ALL
SELECT '-1002' auth_id, 1 num FROM db_root UNION ALL
SELECT '-1002' auth_id, 2 num FROM db_root UNION ALL
SELECT '-1003' auth_id, 1 num FROM db_root UNION ALL
SELECT '-1003' auth_id, 2 num FROM db_root UNION ALL
SELECT '-1004' auth_id, 1 num FROM db_root UNION ALL
SELECT '-1004' auth_id, 2 num FROM db_root ) a
LEFT OUTER JOIN auth_role_menu c ON IF( a.num = 3, a.auth_id, null) = c.role_id
LEFT OUTER JOIN auth_menu d ON IF (a.num = 3, c.menu_id, NULL) = d.menu_id
WHERE (a.num=1 or a.num=2 ) ; 

DROP TABLE auth_role_menu, auth_menu;
