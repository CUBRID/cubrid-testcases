--+ holdcas on;
set @js :='{"a":"0.5", "b":"0.75"}';
SELECT JSON_EXTRACT(@js, '/b') - JSON_EXTRACT(@js, '/a') AS val;
select typeof(@js), json_type(@js);
drop table if exists t1;
create table t1(id int primary key auto_increment, name json);
insert into t1(name) select @js a;
select * from t1;
insert into t1(name) select json_merge(name, @js) from t1;
select * from t1 order by id;

SELECT AVG(JSON_EXTRACT(@js, '/b'));
select avg(if(json_type(json_extract(name, '/b'))='JSON_ARRAY', 0.25, json_extract(name, '/b'))) from t1;
SELECT CAST(JSON_EXTRACT(@js, '/b') AS decimal (3,2)) - CAST(JSON_EXTRACT(@js, '/a') AS decimal (3,2)) AS val;

set @j='
{
    "_id": "5a1260df1985c588fcc22801",
    "index": 0,
    "guid": "420d4a71-5738-4d9d-8b68-a1b0bd9415c6",
    "isActive": false,
    "balance": "$1,731.17",
    "picture": "http://placehold.it/32x32",
    "age": 30,
    "eyeColor": "brown",
    "name": "Felecia Hardy",
    "gender": "female",
    "company": "QUALITERN",
    "email": "feleciahardy@qualitern.com",
    "phone": "+1 (948) 436-2451",
    "address": "136 Macon Street, Germanton, Nevada, 5823",
    "about": "Ipsum excepteur ex tempor consectetur magna culpa elit laborum reprehenderit incididunt consectetur. Duis amet et esse ullamco nisi magna veniam. Est excepteur nisi officia incididunt ad aliqua quis irure tempor amet fugiat. Ea commodo cillum sint aute nostrud velit sint fugiat eiusmod dolor anim exercitation deserunt mollit. Consectetur laboris deserunt deserunt officia consequat velit velit magna adipisicing id sint fugiat. Et nulla eiusmod exercitation adipisicing. Irure irure aliquip aliqua sint qui eiusmod pariatur non.\r\n",
    "registered": "2015-06-15T07:18:45 -08:00",
    "latitude": 6.890302,
    "longitude": 45.636411,
    "tags": [
      "ut",
      "Lorem",
      "dolore",
      "anim",
      "ullamco",
      "amet",
      "cupidatat"
    ],
    "friends": [
      {
        "id": 0,
        "name": "Emma Kennedy"
      },
      {
        "id": 1,
        "name": "Erin Mosley"
      },
      {
        "id": 2,
        "name": "Wolf Morgan"
      }
    ],
    "greeting": "Hello, Felecia Hardy! You have 4 unread messages.",
    "favoriteFruit": "banana"
  },
  {
    "_id": "5a1260df871fb47b7571c7e5",
    "index": 1,
    "guid": "c21cdae1-8b2a-487a-ba34-06e893e20917",
    "isActive": false,
    "balance": "$1,730.43",
    "picture": "http://placehold.it/32x32",
    "age": 23,
    "eyeColor": "blue",
    "name": "Vincent Hurley",
    "gender": "male",
    "company": "XLEEN",
    "email": "vincenthurley@xleen.com",
    "phone": "+1 (804) 532-3490",
    "address": "419 Farragut Place, Stevens, Arizona, 9906",
    "about": "Ex qui in et ut enim. Ea eiusmod ipsum ullamco ipsum exercitation do. Et nostrud in est elit eu sit eu est occaecat cillum cillum minim mollit. Sunt ad ad duis do cillum laborum ad dolore duis mollit cupidatat incididunt.\r\n",
    "registered": "2014-01-17T02:54:35 -08:00",
    "latitude": -76.879633,
    "longitude": 48.439808,
    "tags": [
      "labore",
      "voluptate",
      "qui",
      "ipsum",
      "aliqua",
      "aliquip",
      "culpa"
    ],
    "friends": [
      {
        "id": 0,
        "name": "Levy Hodges"
      },
      {
        "id": 1,
        "name": "Flossie Conner"
      },
      {
        "id": 2,
        "name": "Elliott Hancock"
      }
    ],
    "greeting": "Hello, Vincent Hurley! You have 10 unread messages.",
    "favoriteFruit": "strawberry"
  },
  {
    "_id": "5a1260df517cb85d8e884fb5",
    "index": 2,
    "guid": "1b377590-f3f9-47a8-aed9-99d0e7ca574f",
    "isActive": false,
    "balance": "$2,662.48",
    "picture": "http://placehold.it/32x32",
    "age": 23,
    "eyeColor": "brown",
    "name": "Patton Bender",
    "gender": "male",
    "company": "EMTRAC",
    "email": "pattonbender@emtrac.com",
    "phone": "+1 (910) 458-3959",
    "address": "939 Elm Avenue, Outlook, Idaho, 8981",
    "about": "Culpa in nostrud excepteur et quis et. Reprehenderit ipsum irure in ea ullamco consequat adipisicing cillum aliqua. Proident ut incididunt et ullamco dolore cillum occaecat ea. Sunt labore ea ipsum ut ex dolore sit deserunt magna laboris aute. Reprehenderit aliquip enim occaecat eiusmod.\r\n",
    "registered": "2015-02-26T08:59:07 -08:00",
    "latitude": -73.761125,
    "longitude": 177.544371,
    "tags": [
      "laborum",
      "occaecat",
      "reprehenderit",
      "ad",
      "Lorem",
      "mollit",
      "veniam"
    ],
    "friends": [
      {
        "id": 0,
        "name": "Lawrence Hartman"
      },
      {
        "id": 1,
        "name": "Cobb Tyson"
      },
      {
        "id": 2,
        "name": "Jordan Lindsey"
      }
    ],
    "greeting": "Hello, Patton Bender! You have 4 unread messages.",
    "favoriteFruit": "apple"
  },
  {
    "_id": "5a1260df7e5c3f4ac3a68fbf",
    "index": 3,
    "guid": "b63870fb-b08e-472b-9867-a11fc39ad95b",
    "isActive": false,
    "balance": "$1,005.43",
    "picture": "http://placehold.it/32x32",
    "age": 20,
    "eyeColor": "blue",
    "name": "Leticia Cole",
    "gender": "female",
    "company": "TUBALUM",
    "email": "leticiacole@tubalum.com",
    "phone": "+1 (916) 511-2717",
    "address": "210 Hudson Avenue, Brewster, Delaware, 1327",
    "about": "Commodo voluptate eu excepteur reprehenderit magna velit proident Lorem reprehenderit. Sint aute nulla tempor anim voluptate est. Duis et in laborum nisi ad aute et. Dolor consequat reprehenderit minim fugiat ut in occaecat dolore nulla mollit exercitation proident cillum dolore. Sunt sunt dolor sunt tempor non dolore proident ea esse amet. Fugiat proident eiusmod proident aliqua laborum tempor minim qui culpa. Aute adipisicing laborum sint sit voluptate est sunt enim Lorem.\r\n",
    "registered": "2015-09-26T05:20:55 -08:00",
    "latitude": 56.135974,
    "longitude": -170.652214,
    "tags": [
      "deserunt",
      "commodo",
      "qui",
      "eiusmod",
      "ad",
      "excepteur",
      "esse"
    ],
    "friends": [
      {
        "id": 0,
        "name": "Lizzie Mcfadden"
      },
      {
        "id": 1,
        "name": "Michael Mathews"
      },
      {
        "id": 2,
        "name": "Daniel Ortiz"
      }
    ],
    "greeting": "Hello, Leticia Cole! You have 6 unread messages.",
    "favoriteFruit": "apple"
  },
  {
    "_id": "5a1260df33ae0309f18d385a",
    "index": 4,
    "guid": "069a0e83-599a-4dd6-b38c-3428044ef67f",
    "isActive": true,
    "balance": "$3,137.01",
    "picture": "http://placehold.it/32x32",
    "age": 31,
    "eyeColor": "brown",
    "name": "Barron Bray",
    "gender": "male",
    "company": "SPLINX",
    "email": "barronbray@splinx.com",
    "phone": "+1 (973) 536-2189",
    "address": "540 Eagle Street, Camino, Florida, 1990",
    "about": "Duis reprehenderit incididunt adipisicing magna Lorem enim id. Mollit pariatur labore pariatur aliquip ipsum sint. Adipisicing nulla sit voluptate Lorem excepteur magna tempor deserunt quis ad voluptate. Laboris id pariatur do pariatur adipisicing. Lorem laboris do culpa anim velit do ut duis labore deserunt duis.\r\n",
    "registered": "2015-12-24T04:56:31 -08:00",
    "latitude": -71.924035,
    "longitude": -21.57521,
    "tags": [
      "velit",
      "enim",
      "id",
      "magna",
      "id",
      "laborum",
      "ipsum"
    ],
    "friends": [
      {
        "id": 0,
        "name": "Perry Decker"
      },
      {
        "id": 1,
        "name": "Kemp Ross"
      },
      {
        "id": 2,
        "name": "Brenda Davidson"
      }
    ],
    "greeting": "Hello, Barron Bray! You have 8 unread messages.",
    "favoriteFruit": "banana"
  },
  {
    "_id": "5a1260dfd81a7263e1599ebc",
    "index": 5,
    "guid": "0da804af-064b-4625-84bf-7133c8068768",
    "isActive": true,
    "balance": "$2,127.21",
    "picture": "http://placehold.it/32x32",
    "age": 20,
    "eyeColor": "brown",
    "name": "Scott Kinney",
    "gender": "male",
    "company": "VETRON",
    "email": "scottkinney@vetron.com",
    "phone": "+1 (880) 513-2477",
    "address": "679 Jackson Place, Welda, Colorado, 2643",
    "about": "Voluptate ullamco labore eu non excepteur cillum esse aute ea ea amet ut qui. Pariatur sunt mollit qui laboris esse magna occaecat laborum magna et nulla do. Veniam ullamco occaecat sunt amet aliqua consequat eiusmod quis id quis nulla voluptate laborum ipsum. Ut aliquip nulla aute cupidatat. Sit culpa tempor cupidatat laborum irure veniam eu minim. Aliquip sunt deserunt irure mollit pariatur mollit ea.\r\n",
    "registered": "2016-09-02T12:28:35 -08:00",
    "latitude": 19.159398,
    "longitude": -145.828699,
    "tags": [
      "nulla",
      "fugiat",
      "ad",
      "magna",
      "aute",
      "in",
      "sit"
    ],
    "friends": [
      {
        "id": 0,
        "name": "Callahan Campos"
      },
      {
        "id": 1,
        "name": "Sofia Strong"
      },
      {
        "id": 2,
        "name": "Small Spears"
      }
    ],
    "greeting": "Hello, Scott Kinney! You have 2 unread messages.",
    "favoriteFruit": "strawberry"
  }';
select json_array(@j); 
select json_extract(@j, /1/friends/);

drop VARIABLE @js;
drop VARIABLE @j;
drop table if exists t1;

--+ holdcas off;
