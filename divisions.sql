use championnat;

drop table if exists divisions;

create table divisions (
division_id int not null auto_increment primary key, 
nom varchar(20)
);

insert into divisions (nom)
values
('D1'),
('L1'),
('D2'),
('L2'),
('Division inconnue');
