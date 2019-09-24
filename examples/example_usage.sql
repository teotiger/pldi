set serveroutput on;

begin
  utils.processing_file('countries.csv');
  file_text_data_api.insert_rows(i_frd_id => 1);
  utils.processing_file('Eviction_Notices.csv');
  utils.processing_file('tsv.tsv');
  utils.processing_file('unemployment.csv');
  utils.processing_file('categories.xlsx');
  utils.processing_file('financial_sample.xlsx');
  utils.processing_file('sample-xlsx-file.xlsx');
end;
/

select * from file_text_data order by 1, 2;
select * from file_raw_data;
select * from file_meta_data;

-- => tests !!!
-- tsv
begin
  file_raw_data_api.insert_row(i_filename=>'test.tsv',
  i_plain_text=>'Name	Age	Address
Paul	23	1115 W Franklin
Bessy the Cow	5	Big Farm Way
Zeke	45	W Main St
',
i_character_set => 'UTF-8'
  );
  file_text_data_api.insert_rows(i_filename=>'test.tsv');
end;
/
-- csv
begin
  file_raw_data_api.insert_row(i_filename=>'countries.csv',
  i_plain_text=>'"country","country_group","name_en","name_fr","name_de","latitude","longitude"
"at","eu","Austria","Autriche","Österreich","47.6965545","13.34598005"
"be","eu","Belgium","Belgique","Belgien","50.501045","4.47667405"
"bg","eu","Bulgaria","Bulgarie","Bulgarien","42.72567375","25.4823218"
"hr","non-eu","Croatia","Croatie","Kroatien","44.74664297","15.34084438"
"cy","eu","Cyprus","Chypre","Zypern","35.129141","33.4286823"
"cz","eu","Czech Republic","République tchèque","Tschechische Republik","49.803531","15.47499805"
"dk","eu","Denmark","Danemark","Dänemark","55.93968425","9.51668905"
"ee","eu","Estonia","Estonie","Estland","58.5924685","25.8069503"
"fi","eu","Finland","Finlande","Finnland","64.95015875","26.06756405"
"fr","eu","France","France","Frankreich","46.7109945","1.7185608"
"de","eu","Germany","Allemagne","Deutschland","51.16382538","10.4540478"
"gr","eu","Greece","Grèce","Griechenland","39.698467","21.57725572"
"hu","eu","Hungary","Hongrie","Ungarn","47.16116325","19.5042648"
"ie","eu","Ireland","Irlande","Irland","53.41526","-8.2391222"
"it","eu","Italy","Italie","Italien","42.504191","12.57378705"
"lv","eu","Latvia","Lettonie","Lettland","56.880117","24.60655505"
"lt","eu","Lithuania","Lituanie","Litauen","55.173687","23.9431678"
"lu","eu","Luxembourg","Luxembourg","Luxemburg","49.815319","6.13335155"
"mt","eu","Malta","Malte","Malta","35.902422","14.4474608"
"nl","eu","Netherlands","Pays-Bas","Niederlande","52.10811825","5.3301983"
"no","non-eu","Norway","Norvège","Norwegen","64.55645975","12.66576565"
"pl","eu","Poland","Pologne","Polen","51.91890725","19.1343338"
"pt","eu","Portugal","Portugal","Portugal","39.55806875","-7.84494095"
"ro","eu","Romania","Roumanie","Rumänien","45.94261125","24.99015155"
"sk","eu","Slovakia","Slovaquie","Slowakei","48.67264375","19.7000323"
"si","eu","Slovenia","Slovénie","Slowenien","46.14925925","14.98661705"
"es","eu","Spain","Espagne","Spanien","39.8950135","-2.9882957"
"se","eu","Sweden","Suède","Schweden","62.1984675","14.89630657"
"tr","non-eu","Turkey","Turquie","Türkei","38.95294205","35.43979471"
"uk","eu","United Kingdom","Royaume-Uni","Vereinigtes Königreich","54.315447","-2.23261195"
',
i_character_set => 'UTF-8'
  );
  file_text_data_api.insert_rows(i_filename=>'countries.csv');
end;
/