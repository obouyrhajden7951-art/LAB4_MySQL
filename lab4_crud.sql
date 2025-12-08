-- lab4_crud.sql
-- Lab 4 : Manipulation des données (CRUD + Transactions)

-- 1️⃣ Sélection de la base
USE bibliotheque;

-- ===========================
-- 2️⃣ INSERT : auteurs
-- ===========================
INSERT INTO auteur (nom)
VALUES
  ('Victor Hugo'),
  ('George Orwell'),
  ('Jane Austen');

SELECT * FROM auteur;

-- ===========================
-- 2️⃣ INSERT : ouvrages
-- ===========================
-- Vérifier que la colonne "disponibilite" existe
DESCRIBE ouvrage;

-- Insérer les ouvrages
INSERT INTO ouvrage (titre, disponibilite, id_auteur)
VALUES
  ('Les Misérables', TRUE, 1),       -- Victor Hugo
  ('1984', FALSE, 2),                -- George Orwell
  ('Pride and Prejudice', TRUE, 3);  -- Jane Austen

SELECT * FROM ouvrage;

-- ===========================
-- 2️⃣ INSERT : abonnés
-- ===========================
INSERT INTO abonne (nom, email)
VALUES 
  ('Karim', 'karim@mail.com'),
  ('Lucie', 'lucie@mail.com');

SELECT * FROM abonne;

-- ===========================
-- 2️⃣ INSERT : emprunts
-- ===========================
INSERT INTO emprunt (id_ouvrage, id_abonne, date_debut)
VALUES
  (2, 1, '2025-06-18');  -- Karim emprunte '1984'

SELECT * FROM emprunt;

-- ===========================
-- 3️⃣ UPDATE : modifier des données
-- ===========================
-- Marquer un ouvrage comme indisponible
UPDATE ouvrage
SET disponibilite = FALSE
WHERE titre = 'Les Misérables';

-- Mettre à jour l'email d'un abonné
UPDATE abonne
SET email = 'karim.new@mail.com'
WHERE nom = 'Karim';

-- Clôturer un emprunt
UPDATE emprunt
SET date_fin = CURDATE()
WHERE id_emprunt = 1;

SELECT * FROM ouvrage;
SELECT * FROM abonne;
SELECT * FROM emprunt;

-- ===========================
-- 4️⃣ DELETE : supprimer des enregistrements
-- ===========================

-- Supprimer un abonné et ses emprunts (ON DELETE CASCADE)
DELETE FROM abonne
WHERE nom = 'Lucie';

SELECT * FROM abonne;
SELECT * FROM emprunt;

-- Tenter de supprimer un ouvrage emprunté (bloqué par contrainte)
DELETE FROM ouvrage
WHERE id_ouvrage = 2; -- Doit échouer si emprunt non clôturé

-- Supprimer un auteur et ses ouvrages (optionnel : cascade si configurée)
-- Si ON DELETE CASCADE n'est pas actif, supprimer d'abord les ouvrages :
DELETE FROM ouvrage
WHERE id_auteur = 2; -- George Orwell

DELETE FROM auteur
WHERE nom = 'George Orwell';

SELECT * FROM auteur;
SELECT * FROM ouvrage;

-- ===========================
-- 5️⃣ Transactions
-- ===========================
START TRANSACTION;

INSERT INTO abonne (nom, email)
VALUES ('Samir', 'samir@mail.com');

INSERT INTO emprunt (id_ouvrage, id_abonne, date_debut)
VALUES (3, LAST_INSERT_ID(), '2025-06-19');

-- Valider la transaction
COMMIT;

SELECT * FROM abonne;
SELECT * FROM emprunt;
