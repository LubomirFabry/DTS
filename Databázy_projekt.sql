/*
    Mazanie všetkých databáz ak sú už vytvorené
*/

DROP DATABASE IF EXISTS filip_kocis_vyroba;
DROP DATABASE IF EXISTS timotej_vronc_predaj;
DROP DATABASE IF EXISTS lubomir_fabry_oprava;
DROP DATABASE IF EXISTS zakaznik;


/*
    Vytvaranie databázy zakaznik a tabulky zakaznik_info
*/

CREATE DATABASE zakaznik DEFAULT CHARACTER SET utf8;
USE zakaznik;

CREATE TABLE zakaznik_info(
  id INT AUTO_INCREMENT PRIMARY KEY,
  meno VARCHAR(64) NOT NULL,
  priezvisko VARCHAR(64) NOT NULL,
  adresa VARCHAR(64) NOT NULL
);

/*
    Vlozenie informacii do tabulky zakaznik_info
*/


insert into zakaznik_info (meno, priezvisko, adresa) VALUES 
('Timotej', 'Vronc', '4534 Caliangt Parkway'), 
('Lubomir', 'Fabry', '21338 Spenser Park'),
('Filip', 'Kocis', '0 Shasta Center'),
('Friedrich', 'Saunper', '17951 Texas Pass'),
('Bride', 'Roxburgh', '35 Golf Course Way'),
('Rocky', 'Matevushev', '2 Manley Alley'),
('Homerus', 'Gooch', '2446 Stone Corner Alley'),
('Cedric', 'Rallinshaw', '52 Merchant Circle'),
('Shelbi', 'Wrennall', '9818 Bluestem Crossing'),
('Tuck', 'Cockett', '4 Mosinee Court');

/*
    Vytvaranie databázy filip_kocis_vyroba a tabuliek vybava, objednavky, potrebne_vyrobit. vyrobene_auta
*/

CREATE DATABASE filip_kocis_vyroba DEFAULT CHARACTER SET utf8;
USE filip_kocis_vyroba;

CREATE TABLE vybava(
    id INT PRIMARY KEY AUTO_INCREMENT,
    typ_vybavy varchar(255) NOT NULL,
    specialne_potahy VARCHAR(20) NOT NULL DEFAULT 'NIE',
    farba varchar(100) NOT NULL,
    pocet_vyfukov INT NOT NULL,
    zimne_gumy VARCHAR(20) NOT NULL DEFAULT 'NIE',
    spoiler VARCHAR(20) NOT NULL DEFAULT 'NIE'
);

/*
    Vlozenie informacii do tabulky vybava
*/

INSERT INTO vybava (typ_vybavy,specialne_potahy,farba,pocet_vyfukov,zimne_gumy,spoiler) VALUES
('sportova', 'ANO', 'cervena', 4, 'ANO', 'ANO'),
('letna', 'ANO', 'siva', 2, 'NIE', 'NIE'),
('zimna', 'ANO', 'biela', 4, 'ANO', 'NIE'),
('klasicka', 'NIE', 'siva', 1, 'ANO', 'NIE');

CREATE TABLE objednavky(
    id INT PRIMARY KEY AUTO_INCREMENT,
    zakaznik_id INT,
    nazov_auta VARCHAR(255) NOT NULL,
    znacka_auta VARCHAR(255) NOT NULL,
    model VARCHAR(255) NOT NULL,
    farba VARCHAR(255) NOT NULL,
    vybava_id INT,
    pocet INT DEFAULT 1,
    cena INT NOT NULL,
    datum_objednavky DATE NOT NULL,
    stav VARCHAR(100) NOT NULL DEFAULT 'čakajúca na vybavenie',
    FOREIGN KEY(zakaznik_id) REFERENCES zakaznik.zakaznik_info(id),
    FOREIGN KEY(vybava_id) REFERENCES vybava(id)
    );

/*
    Vlozenie informacii do tabulky objednavky
*/

INSERT INTO objednavky (zakaznik_id, nazov_auta, znacka_auta, model, farba, vybava_id, pocet, cena, datum_objednavky, stav) VALUES
(1, 'Ford Falcon', 'Ford', 'Falcon', 'cierna', 1, 1, 50000, '2020-8-22', 'čakajúca na vybavenie'),
(2, 'Wolkswagen Golf', 'Wolkswagen', 'Golf', 'modra', 3, 2, 20000, '2021-8-11', 'vybavena'),
(4,	'Toyota Avanza', 'Toyota', 'Avanza', 'siva', 4, 1, 60000, '2020-7-7', 'vybavena'),
(10, 'Toyota Corolla', 'Toyota', 'Corolla', 'cierna', 3, 2, 20000, '2020-9-20', 'čakajúca na vybavenie'),
(9,	'Toyota Avanza', 'Toyota', 'Avanza', 'cervena', 3, 1, 10000, '2020-9-20', 'vybavena'),
(8, 'Ford Falcon', 'Ford', 'Falcon', 'biela', 4, 3, 90000, '2020-7-1', 'čakajúca na vybavenie'),
(5, 'Wolkswagen Golf', 'Wolkswagen', 'Golf', 'azurova', 1, 1, 40000, '2018-1-12', 'vybavena'),
(3,	'Toyota Avanza', 'Toyota', 'Avanza', 'biela', 3, 1, 50000, '2019-11-6', 'čakajúca na vybavenie'),
(6, 'Wolkswagen Golf', 'Wolkswagen', 'Golf', 'modra', 4, 1, 30000, '2020-8-22', 'čakajúca na vybavenie'),
(2, 'Toyota Corolla', 'Toyota', 'Corolla', 'siva', 2, 1, 50000, '2020-8-22', 'vybavena');

CREATE TABLE potrebne_vyrobit(
    id INT PRIMARY KEY AUTO_INCREMENT,
    nazov_auta VARCHAR(255) NOT NULL,
    znacka_auta VARCHAR(255) NOT NULL,
    vybava_id INT,
    objednavka_id INT,
    FOREIGN KEY(objednavka_id) REFERENCES objednavky(id)
);

/*
    Vlozenie informacii do tabulky potrebne_vyrobit
*/

INSERT INTO potrebne_vyrobit (nazov_auta, znacka_auta, vybava_id, objednavka_id) 
    SELECT nazov_auta, znacka_auta, vybava_id, id 
    FROM objednavky 
    WHERE objednavky.stav = 'čakajúca na vybavenie';

CREATE TABLE vyrobene_auta(
    id INT PRIMARY KEY AUTO_INCREMENT,
    nazov_auta VARCHAR(255) NOT NULL,
    znacka_auta VARCHAR(255) NOT NULL,
    miesto_vyroby VARCHAR(255) NOT NULL,
    datum_vyroby DATE NOT NULL,
    objednavka_id INT,
    zakaznik_id INT,
    FOREIGN KEY(objednavka_id) REFERENCES objednavky(id),
    FOREIGN KEY(zakaznik_id) REFERENCES zakaznik.zakaznik_info(id)
);

/*
    Vlozenie informacii do tabulky vyrobene_auta
*/

INSERT INTO vyrobene_auta (nazov_auta, znacka_auta, miesto_vyroby, datum_vyroby,objednavka_id, zakaznik_id)
VALUES
('Wolkswagen Golf', 'Wolkswagen', 'Bratislava', '2021-8-29', 2, 2),
('Toyota Avanza', 'Toyota', 'Kosice', '2020-7-30', 3, 4),
('Wolkswagen Golf', 'Wolkswagen', 'Bratislava', '2021-9-30', 2, 2),
('Toyota Avanza', 'Toyota', 'Bratislava', '2020-10-15', 5, 9),
('Wolkswagen Golf', 'Wolkswagen', 'Kosice', '2018-1-29', 7, 5),
('Toyota Corolla', 'Toyota', 'Bratislava', '2020-8-22', 10, 2);

SELECT zakaznik.zakaznik_info.meno, zakaznik.zakaznik_info.priezvisko,
       nazov_auta, znacka_auta, miesto_vyroby, datum_vyroby
FROM zakaznik.zakaznik_info,
      vyrobene_auta
WHERE zakaznik_id = zakaznik.zakaznik_info.id ORDER BY datum_vyroby;

/*
    Vytvaranie databázy timotej_vronc_predaj a tabuliek sklad, objednavky. predane_auta
*/

CREATE DATABASE timotej_vronc_predaj DEFAULT CHARACTER SET utf8;
USE timotej_vronc_predaj;

CREATE TABLE sklad(
    id INT PRIMARY KEY AUTO_INCREMENT,
    nazov_auta VARCHAR(255) NOT NULL,
    znacka_auta VARCHAR(255) NOT NULL,
    model VARCHAR(255) NOT NULL,
    farba VARCHAR(255) NOT NULL,
    vybava VARCHAR(20) NOT NULL,
    rok_vyroby YEAR NOT NULL,
    miesto_vyroby VARCHAR(255) NOT NULL,
    pocet INT DEFAULT 1,
    cena INT NOT NULL
);

/*
    Vlozenie informacii do tabulky sklad
*/

INSERT INTO sklad (nazov_auta, znacka_auta, model, farba, vybava, rok_vyroby, miesto_vyroby, pocet, cena) VALUES
('Ford Falcon', 'Ford', 'Falcon', 'cierna', 'sportova', '2000', 'Bratislava', 4, 40000),
('Wolkswagen Golf', 'Wolkswagen', 'Golf', 'modra', 'zimna', '2005', 'Kosice', 2, 30000),
('Toyota Avanza', 'Toyota', 'Avanza', 'siva', 'letna', '2018', 'Kosice', 3, 25000),
('Toyota Corolla', 'Toyota', 'Corolla', 'cierna', 'klasicka', '2009', 'Kosice', 12, 45000),
('Toyota Avanza', 'Toyota', 'Avanza', 'cervena', 'klasicka', '2015', 'Bratislava', 1, 30000),
('Ford Falcon', 'Ford', 'Falcon', 'biela', 'sportova', '2017', 'Kosice', 5, 25000),
('Wolkswagen Golf', 'Wolkswagen', 'Golf', 'azurova', 'zimna', '2005', 'Zilina', 3, 40000),
('Toyota Avanza', 'Toyota', 'Avanza', 'biela', 'klasicka', '2005', 'Kosice', 5, 38000),
('Wolkswagen Golf', 'Wolkswagen', 'Golf', 'modra', 'sportova', '2009', 'Bratislava', 6, 30000),
('Toyota Corolla', 'Toyota', 'Corolla', 'siva', 'klasicka', '2008', 'Zilina', 5, 23000);

/*
    Vlozenie informacii do tabulky faktury
*/

CREATE TABLE faktury(
    id INT PRIMARY KEY AUTO_INCREMENT,
    zakaznik_id INT,
    nazov_auta VARCHAR(255) NOT NULL,
    znacka_auta VARCHAR(255) NOT NULL,
    auto_id INT,
    datum_uskutocnenia DATE NOT NULL,
    datum_vybavenia DATE NOT NULL,
    cena INT NOT NULL,
    FOREIGN KEY(zakaznik_id) REFERENCES zakaznik.zakaznik_info(id),
    FOREIGN KEY(auto_id) REFERENCES sklad(id)
    );

INSERT INTO faktury (zakaznik_id, nazov_auta, znacka_auta, auto_id, datum_uskutocnenia, datum_vybavenia, cena)
VALUES
(3, 'Ford Falcon', 'Ford', 6, '2019-8-30', '2019-9-5', 40500),
(1, 'Toyota Avanza', 'Toyota', 3, '2020-4-20', '2020-4-30', 25500),
(8, 'Wolkswagen Golf', 'Wolkswagen', 9, '2019-9-1', '2019-9-11', 30500),
(1, 'Toyota Corolla', 'Toyota', 10, '2019-9-3', '2019-9-20', 23500),
(5, 'Toyota Avanza', 'Toyota', 5, '2018-2-10', '2018-2-15', 25500),
(10, 'Wolkswagen Golf', 'Wolkswagen', 2, '2020-2-3', '2020-2-10', 38500),
(4, 'Wolkswagen Golf', 'Wolkswagen', 9, '2018-2-13', '2018-3-1', 30500),
(9, 'Toyota Corolla', 'Toyota', 10, '2019-4-7', '2019-4-15', 23500),
(6, 'Ford Falcon', 'Ford', 1, '2022-3-19', '2022-3-30', 40500),
(7, 'Wolkswagen Golf', 'Wolkswagen', 9, '2017-11-22', '2017-11-28', 30500);

/*
    Vlozenie informacii do tabulky predane_auta
*/

CREATE TABLE predane_auta(
    id INT PRIMARY KEY AUTO_INCREMENT,
    zakaznik_id INT,
    nazov_auta VARCHAR(255) NOT NULL,
    znacka_auta VARCHAR(255) NOT NULL,
    datum_predania DATE NOT NULL,
    objednavka_id INT,
    FOREIGN KEY(zakaznik_id) REFERENCES zakaznik.zakaznik_info(id),
    FOREIGN KEY(objednavka_id) REFERENCES faktury(id)
);

INSERT INTO 
    predane_auta (zakaznik_id, nazov_auta, znacka_auta, datum_predania, objednavka_id) 
    SELECT zakaznik_id, nazov_auta, znacka_auta, datum_vybavenia, id;

SELECT zakaznik.zakaznik_info.meno, zakaznik.zakaznik_info.priezvisko,
       nazov_auta, znacka_auta, datum_predania
FROM zakaznik.zakaznik_info,
      predane_auta
WHERE zakaznik_id = zakaznik.zakaznik_info.id ORDER BY datum_predania ORDER BY datum_vybavenia;


/*
    Vytvaranie databázy lubomir_fabry_oprava a tabuliek sklad, sluzby. objednavky
*/

CREATE DATABASE lubomir_fabry_oprava DEFAULT CHARACTER SET utf8;
USE lubomir_fabry_oprava;

CREATE TABLE diely(
  id INT PRIMARY KEY AUTO_INCREMENT,
  nazov_dielu VARCHAR(255) NOT NULL,
  pocet_kusov INT NOT NULL,
  cena_dielu INT NOT NULL
);

/*
    Vlozenie informacii do tabulky diely
*/

INSERT INTO diely (nazov_dielu, pocet_kusov, cena_dielu)
VALUES
('motor', 2, 5000), ('podvozok', 1, 8000),
('kapota', 5, 800), ('vyfuk', 20, 300),
('predne dvere lave', 12, 200), ('predne dvere prave', 8, 200),
('zadne dvere lave', 12, 180), ('zadne dvere prave', 8, 180),
('puklice', 100, 200), ('brzdy', 30, 100),
('prevodovka', 15, 200), ('karburator', 30, 300);

CREATE TABLE sluzby(
    id INT PRIMARY KEY AUTO_INCREMENT,
    nazov VARCHAR(255) NOT NULL,
    potrebny_diel_id INT,
    doba_trvania_h INT NOT NULL,
    cena INT NOT NULL,
    FOREIGN KEY(potrebny_diel_id) REFERENCES diely(id)
);

/*
    Vlozenie informacii do tabulky sluzby
*/

INSERT INTO sluzby (nazov, potrebny_diel_id, doba_trvania_h, cena)
VALUES
('oprava motoru', 1, 20, 6000),
('vymena puklice', 9, 2, 300),
('oprava prevodovky', 11, 13, 600),
('vymena karburatora', 12, 8, 500),
('vymena prednych lavych dveri', 4, 2, 300),
('vymena prednych pravych dveri', 5, 2, 300),
('vymena zadnych lavych dveri', 6, 1, 300),
('vymena zadnych pravych dveri', 7, 1, 300);

INSERT INTO sluzby (nazov, doba_trvania_h, cena)
VALUES
('vseobecna kontrola', 3, 500),
('cistenie vyfuku', 2, 200),
('cistenie interieru', 3, 250),
('precipovanie', 5, 2000);

CREATE TABLE objednavky(
    id INT PRIMARY KEY AUTO_INCREMENT,
    zakaznik_id INT,
    pricina VARCHAR(255),
    nazov_auta VARCHAR(255) NOT NULL,
    znacka_auta VARCHAR(255) NOT NULL,
    sluzba_id INT NOT NULL,
    datum_objednavky DATE NOT NULL,
    cena INT NOT NULL,
    stav VARCHAR(100) DEFAULT 'v oprave',
    FOREIGN KEY(zakaznik_id) REFERENCES zakaznik.zakaznik_info(id),
    FOREIGN KEY(sluzba_id) REFERENCES sluzby(id)
);

/*
    Vlozenie informacii do tabulky objednavky
*/

INSERT INTO objednavky (zakaznik_id, pricina, nazov_auta, znacka_auta, sluzba_id, datum_objednavky, cena, stav)
VALUES
(1, 'poskodeny motor', 'Wolkswagen Golf', 'Wolkswagen', 1, '2019-3-29', 6000, 'v oprave'),
(3, 'znicena puklica', 'Toyota Corolla', 'Toyota', 2, '2017-10-3', 300, 'vybavene'),
(5, 'pokazene predne dvere lave', 'Ford Falcon', 'Ford', 5, '2021-6-3', 300, 'vybavene'),
(4, 'neistota funkcnosti auta', 'Wolkswagen Golf', 'Wolkswagen', 9, '2017-12-30', 500, 'vybavene'),
(8, 'spinavy interier', 'Ford Falcon', 'Ford', 11, '2017-6-9', 250, 'v oprave'),
(1, 'slaby vykon', 'Toyota Avanza', 'Toyota', 12, '2020-2-14', 2000, 'v oprave'),
(2, 'spinavy vyfuk', 'Ford Falcon', 'Ford', 10, '2018-1-22', 200, 'vybavene'),
(5, 'pokazeny motor','Toyota Corolla', 'Toyota', 1, '2017-10-19', 6000, 'v oprave'),
(10, 'spinavy vyfuk','Wolkswagen Golf', 'Wolkswagen', 10, '2020-9-4', 200, 'vybavene'),
(7, 'neistota funkcnosti auta', 'Toyota Avanza', 'Toyota', 9, '2021-12-19', 500, 'vybavene');

SELECT zakaznik.zakaznik_info.meno, zakaznik.zakaznik_info.priezvisko,
       sluzby.nazov AS sluzba, nazov_auta, znacka_auta, CONCAT(objednavky.cena, ' €') AS 'cena'
FROM zakaznik.zakaznik_info,
      objednavky, sluzby
WHERE zakaznik_id = zakaznik.zakaznik_info.id AND sluzba_id = sluzby.id ORDER BY datum_objednavky;