create table file_text_data (
  ftd_id             number(10, 0),
  frd_id             number(10, 0),
  fmd_id             number(5, 0),
  timestamp_insert   timestamp default systimestamp not null,
  sheet_id           number(2, 0),
  sheet_name         varchar2(255 char),
  row_number         number(8, 0) not null,
  c001               varchar2(4000 char),
  c002               varchar2(4000 char),
  c003               varchar2(4000 char),
  c004               varchar2(4000 char),
  c005               varchar2(4000 char),
  c006               varchar2(4000 char),
  c007               varchar2(4000 char),
  c008               varchar2(4000 char),
  c009               varchar2(4000 char),
  c010               varchar2(4000 char),
  c011               varchar2(4000 char),
  c012               varchar2(4000 char),
  c013               varchar2(4000 char),
  c014               varchar2(4000 char),
  c015               varchar2(4000 char),
  c016               varchar2(4000 char),
  c017               varchar2(4000 char),
  c018               varchar2(4000 char),
  c019               varchar2(4000 char),
  c020               varchar2(4000 char),
  c021               varchar2(4000 char),
  c022               varchar2(4000 char),
  c023               varchar2(4000 char),
  c024               varchar2(4000 char),
  c025               varchar2(4000 char),
  c026               varchar2(4000 char),
  c027               varchar2(4000 char),
  c028               varchar2(4000 char),
  c029               varchar2(4000 char),
  c030               varchar2(4000 char),
  c031               varchar2(4000 char),
  c032               varchar2(4000 char),
  c033               varchar2(4000 char),
  c034               varchar2(4000 char),
  c035               varchar2(4000 char),
  c036               varchar2(4000 char),
  c037               varchar2(4000 char),
  c038               varchar2(4000 char),
  c039               varchar2(4000 char),
  c040               varchar2(4000 char),
  c041               varchar2(4000 char),
  c042               varchar2(4000 char),
  c043               varchar2(4000 char),
  c044               varchar2(4000 char),
  c045               varchar2(4000 char),
  c046               varchar2(4000 char),
  c047               varchar2(4000 char),
  c048               varchar2(4000 char),
  c049               varchar2(4000 char),
  c050               varchar2(4000 char),  
  c051               varchar2(4000 char),
  c052               varchar2(4000 char),
  c053               varchar2(4000 char),
  c054               varchar2(4000 char),
  c055               varchar2(4000 char),
  c056               varchar2(4000 char),
  c057               varchar2(4000 char),
  c058               varchar2(4000 char),
  c059               varchar2(4000 char),
  c060               varchar2(4000 char),
  c061               varchar2(4000 char),
  c062               varchar2(4000 char),
  c063               varchar2(4000 char),
  c064               varchar2(4000 char),
  c065               varchar2(4000 char),
  c066               varchar2(4000 char),
  c067               varchar2(4000 char),
  c068               varchar2(4000 char),
  c069               varchar2(4000 char),
  c070               varchar2(4000 char),
  c071               varchar2(4000 char),
  c072               varchar2(4000 char),
  c073               varchar2(4000 char),
  c074               varchar2(4000 char),
  c075               varchar2(4000 char),
  c076               varchar2(4000 char),
  c077               varchar2(4000 char),
  c078               varchar2(4000 char),
  c079               varchar2(4000 char),
  c080               varchar2(4000 char),
  c081               varchar2(4000 char),
  c082               varchar2(4000 char),
  c083               varchar2(4000 char),
  c084               varchar2(4000 char),
  c085               varchar2(4000 char),
  c086               varchar2(4000 char),
  c087               varchar2(4000 char),
  c088               varchar2(4000 char),
  c089               varchar2(4000 char),
  c090               varchar2(4000 char),
  c091               varchar2(4000 char),
  c092               varchar2(4000 char),
  c093               varchar2(4000 char),
  c094               varchar2(4000 char),
  c095               varchar2(4000 char),
  c096               varchar2(4000 char),
  c097               varchar2(4000 char),
  c098               varchar2(4000 char),
  c099               varchar2(4000 char),
  c100               varchar2(4000 char),
  c101               varchar2(4000 char),
  c102               varchar2(4000 char),
  c103               varchar2(4000 char),
  c104               varchar2(4000 char),
  c105               varchar2(4000 char),
  c106               varchar2(4000 char),
  c107               varchar2(4000 char),
  c108               varchar2(4000 char),
  c109               varchar2(4000 char),
  c110               varchar2(4000 char),
  c111               varchar2(4000 char),
  c112               varchar2(4000 char),
  c113               varchar2(4000 char),
  c114               varchar2(4000 char),
  c115               varchar2(4000 char),
  c116               varchar2(4000 char),
  c117               varchar2(4000 char),
  c118               varchar2(4000 char),
  c119               varchar2(4000 char),
  c120               varchar2(4000 char),
  c121               varchar2(4000 char),
  c122               varchar2(4000 char),
  c123               varchar2(4000 char),
  c124               varchar2(4000 char),
  c125               varchar2(4000 char),
  c126               varchar2(4000 char),
  c127               varchar2(4000 char),
  c128               varchar2(4000 char),
  c129               varchar2(4000 char),
  c130               varchar2(4000 char),
  c131               varchar2(4000 char),
  c132               varchar2(4000 char),
  c133               varchar2(4000 char),
  c134               varchar2(4000 char),
  c135               varchar2(4000 char),
  c136               varchar2(4000 char),
  c137               varchar2(4000 char),
  c138               varchar2(4000 char),
  c139               varchar2(4000 char),
  c140               varchar2(4000 char),
  c141               varchar2(4000 char),
  c142               varchar2(4000 char),
  c143               varchar2(4000 char),
  c144               varchar2(4000 char),
  c145               varchar2(4000 char),
  c146               varchar2(4000 char),
  c147               varchar2(4000 char),
  c148               varchar2(4000 char),
  c149               varchar2(4000 char),
  c150               varchar2(4000 char),
  c151               varchar2(4000 char),
  c152               varchar2(4000 char),
  c153               varchar2(4000 char),
  c154               varchar2(4000 char),
  c155               varchar2(4000 char),
  c156               varchar2(4000 char),
  c157               varchar2(4000 char),
  c158               varchar2(4000 char),
  c159               varchar2(4000 char),
  c160               varchar2(4000 char),
  c161               varchar2(4000 char),
  c162               varchar2(4000 char),
  c163               varchar2(4000 char),
  c164               varchar2(4000 char),
  c165               varchar2(4000 char),
  c166               varchar2(4000 char),
  c167               varchar2(4000 char),
  c168               varchar2(4000 char),
  c169               varchar2(4000 char),
  c170               varchar2(4000 char),
  c171               varchar2(4000 char),
  c172               varchar2(4000 char),
  c173               varchar2(4000 char),
  c174               varchar2(4000 char),
  c175               varchar2(4000 char),
  c176               varchar2(4000 char),
  c177               varchar2(4000 char),
  c178               varchar2(4000 char),
  c179               varchar2(4000 char),
  c180               varchar2(4000 char),
  c181               varchar2(4000 char),
  c182               varchar2(4000 char),
  c183               varchar2(4000 char),
  c184               varchar2(4000 char),
  c185               varchar2(4000 char),
  c186               varchar2(4000 char),
  c187               varchar2(4000 char),
  c188               varchar2(4000 char),
  c189               varchar2(4000 char),
  c190               varchar2(4000 char),
  c191               varchar2(4000 char),
  c192               varchar2(4000 char),
  c193               varchar2(4000 char),
  c194               varchar2(4000 char),
  c195               varchar2(4000 char),
  c196               varchar2(4000 char),
  c197               varchar2(4000 char),
  c198               varchar2(4000 char),
  c199               varchar2(4000 char),
  c200               varchar2(4000 char),
  constraint file_text_data_frd_id_fk foreign key ( frd_id )
    references file_raw_data ( frd_id ),
  constraint file_text_data_fmd_id_fk foreign key ( fmd_id )
    references file_meta_data ( fmd_id )
);
------
create sequence file_text_data_seq 
  minvalue 1 start with 1 increment by 1 cache 8;
------
create index file_text_data_ftd_id_idx on file_text_data (ftd_id);
