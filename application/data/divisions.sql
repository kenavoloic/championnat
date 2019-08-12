USE championnat;

DROP TABLE IF EXISTS divisions;

CREATE TABLE divisions (
division_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
nom VARCHAR(20)
);

INSERT INTO divisions (nom)
VALUES
('D1'),
('L1'),
('D2'),
('L2'),
('Division inconnue');
