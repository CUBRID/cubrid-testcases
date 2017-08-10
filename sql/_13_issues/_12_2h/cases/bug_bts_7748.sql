create table that_twlsh (
        nid CHARACTER VARYING(20) NOT NULL,
        npid CHARACTER VARYING(20) NOT NULL,
        aid CHARACTER VARYING(20) NOT NULL,
        aa SMALLINT NOT NULL,
        ndhan CHARACTER VARYING(300),
        nkmv CHARACTER VARYING(100) NOT NULL,
        nhmv CHARACTER VARYING(100),
        nnmv CHARACTER VARYING(100),
        nqmv CHARACTER VARYING(100),
        ozm CHARACTER VARYING(1) NOT NULL,
        eid CHARACTER VARYING(20),
        edt TIMESTAMP,
        vjid CHARACTER VARYING(20),
        vjdt TIMESTAMP );
SELECT /*+ recompile*/ *
FROM that_twlsh
WHERE nid IN (SELECT nid
                  FROM that_twlsh
                  WHERE ozm = 'Y'
                  START WITH nid = 'COSC000002'
                  CONNECT BY NOCYCLE PRIOR nid = npid
                  ORDER SIBLINGS BY aa);

drop that_twlsh;
