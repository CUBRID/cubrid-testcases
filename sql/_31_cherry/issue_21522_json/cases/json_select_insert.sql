drop table if exists players;
create table players(id int primary key not null auto_increment, player_and_games json not null);
INSERT INTO `players` (`id`, `player_and_games`) VALUES (1, '{  
    "id": 1,  
    "name": "Sally",
    "games_played":{    
       "Battlefield": {
          "weapon": "sniper rifle",
          "rank": "Sergeant V",
          "level": 20
        },                                                                                                                          
       "Crazy Tennis": {
          "won": 4,
          "lost": 1
        },  
       "Puzzler": {
          "time": 7
        }
      }
   }'
);

insert into players(player_and_games) select player_and_games from players a;
insert into players select rownum*2, player_and_games from players a; 
insert into players(player_and_games) select player_and_games from players a where json_extract(player_and_games, '/games_played/Puzzler/time') =7;
select * from players order by id;
insert into players(player_and_games) select json_array(json_extract(player_and_games, '/games_played/Battlefield/level'), json_extract(player_and_games, '/name')) from players a where json_extract(player_and_games, '/games_played/Puzzler/time') >0;
insert into players(player_and_games) select json_array(json_extract(player_and_games, '/games_played/Battlefield/level'), json_extract(player_and_games, '/name')) from players a where json_extract(player_and_games, '/games_played/Puzzler/time') =7;
select * from players order by id desc, json_extract(player_and_games, '/id') asc; 

drop table if exists players;

