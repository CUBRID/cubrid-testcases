CREATE CLASS page;

ALTER CLASS page ADD ATTRIBUTE
id integer NOT NULL,
name integer DEFAULT 0,
titsh character varying(255) NOT NULL,
eha character varying(1073741823) DEFAULT '',
page integer DEFAULT 0,
fswu1 smallint DEFAULT 0,
fswu2 smallint DEFAULT 0,
round float NOT NULL,
vwek character varying(22) DEFAULT '',
ljjk integer,
shm integer;

ALTER CLASS page ADD ATTRIBUTE
CONSTRAINT [name_titsh] UNIQUE(name, titsh),
CONSTRAINT [pk_id] PRIMARY KEY(id);

CREATE CLASS nsimk;

ALTER CLASS nsimk ADD ATTRIBUTE
ns_f integer DEFAULT 0,
ns_t character varying(255) DEFAULT '',
ns_a character varying(70) DEFAULT '',
ns_d timestamp NOT NULL;

ALTER CLASS nsimk ADD ATTRIBUTE
CONSTRAINT [ns_f] UNIQUE(ns_f, ns_t);

SELECT /* Admin */ 'new' as "type", 14 as namespace, titsh as t, titsh as "v"
FROM page 
LEFT JOIN nsimk ON titsh=ns_t
WHERE ns_f IS NULL AND name = 14 AND fswu1 = 0
ORDER BY titsh DESC FOR ORDERBY_NUM() BETWEEN 1 AND 50;

drop table page, nsimk;
