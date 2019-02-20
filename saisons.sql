use championnat;

drop table if exists saisons;

create table saisons (
saison_id int auto_increment not null primary key,
annee int(4) not null
);

insert into saisons (annee)
values
('0000'); -- en cas de valeur nulle.

insert into saisons (annee) (select distinct(saison) from resultats);
