-- 1️⃣ Base de données
CREATE DATABASE bibliotheque;
USE bibliotheque;

-- 2️⃣ Tables
CREATE TABLE auteur (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(255) NOT NULL
);

CREATE TABLE ouvrage (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titre VARCHAR(200) NOT NULL,
    disponible TINYINT(1) DEFAULT 1,
    auteur_id INT,
    FOREIGN KEY (auteur_id) REFERENCES auteur(id) ON DELETE CASCADE
);

CREATE TABLE abonne (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100),
    email VARCHAR(255) UNIQUE
);

CREATE TABLE emprunt (
    id_emprunt INT AUTO_INCREMENT PRIMARY KEY,
    ouvrage_id INT,
    abonne_id INT,
    date_debut DATE,
    date_fin DATE,
    FOREIGN KEY (ouvrage_id) REFERENCES ouvrage(id),
    FOREIGN KEY (abonne_id) REFERENCES abonne(id)
);

-- 3️⃣ Ajouter des données
INSERT INTO auteur (nom) VALUES ('Victor Hugo'), ('George Orwell'), ('Jane Austen');

INSERT INTO ouvrage (titre, disponible, auteur_id) 
VALUES ('Les Misérables', 1, 1), ('1984', 1, 2), ('Pride and Prejudice', 1, 3);

INSERT INTO abonne (nom, email) VALUES ('Karim', 'karim@mail.com'), ('Lucie', 'lucie@mail.com');

INSERT INTO emprunt (ouvrage_id, abonne_id, date_debut) VALUES (2, 1, '2025-06-18');

-- 4️⃣ Sélection
SELECT * FROM auteur;
SELECT * FROM ouvrage;
SELECT * FROM abonne;
SELECT * FROM emprunt;

-- 5️⃣ Update
UPDATE ouvrage SET disponible = 0 WHERE titre = 'Les Misérables';
UPDATE abonne SET email = 'karim.new@mail.com' WHERE nom = 'Karim';
UPDATE emprunt SET date_fin = '2025-12-09' WHERE id_emprunt = 1;

-- 6️⃣ Delete
DELETE FROM abonne WHERE nom = 'Lucie';

-- Créer un ouvrage et emprunt pour test DELETE bloqué
INSERT INTO ouvrage (titre, disponible, auteur_id) VALUES ('Test Livre', 1, 1);
SET @id_test = LAST_INSERT_ID();

INSERT INTO emprunt (ouvrage_id, abonne_id, date_debut) VALUES (@id_test, 1, '2025-12-09');

-- DELETE qui ne devrait pas marcher si FK restrictive (ici MySQL va supprimer car pas CHECK)
DELETE FROM ouvrage WHERE id = @id_test;

-- Supprimer l’emprunt puis l’ouvrage
DELETE FROM emprunt WHERE id_ouvrage = @id_test;
DELETE FROM ouvrage WHERE id = @id_test;

-- 7️⃣ Transaction simple
START TRANSACTION;
INSERT INTO abonne (nom, email) VALUES ('Samir', 'samir@mail.com');
SET @id_samir = LAST_INSERT_ID();
INSERT INTO emprunt (ouvrage_id, abonne_id, date_debut) VALUES (3, @id_samir, '2025-12-09');
COMMIT;

