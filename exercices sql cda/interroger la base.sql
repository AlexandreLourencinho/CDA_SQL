/*REQUÊTES INTERROGER LA BASE*/
-- 2) Afficher toutes les informations concernant les départements.
SELECT * FROM dept;
-- 3) Afficher le nom, la date d'embauche, le numéro du supérieur, le numéro de département et le salaire de tous les employés. 
SELECT nom,dateemb,nosup,nodep,salaire FROM employe;
-- 4) Afficher le titre de tous les employés.
SELECT titre FROM employe;
-- 5) Afficher les différentes valeurs des titres des employés.
SELECT DISTINCT titre FROM employe;
-- 6) Afficher le nom, le numéro d'employé et le numéro du département des employés dont le titre est «Secrétaire».
SELECT nom,noemp,nodep FROM employe
WHERE titre="secrétaire";
-- 7)  Afficher le nom et le numéro de département dont le numéro de département est supérieur à 40.
SELECT nom,noemp,nodep FROM employe
WHERE nodep > 40;
-- 8) Afficher le nom et le prénom des employés dont le nom est alphabétiquement antérieur au prénom. 
SELECT nom,prenom FROM employe
WHERE nom < prenom;
-- 9) Afficher le nom, le salaire et le numéro du département des employés dont le titre est «Représentant», le numéro de département est 35et le salaire est supérieur à 20000.
SELECT nom,salaire,nodep FROM employe
WHERE titre = "représentant" AND nodep = 35 AND salaire > 20000;
-- 10) Afficher le nom, le titre et le salaire des employés dont le titre est «Représentant» ou dont le titre est «Président».
SELECT nom,salaire,titre FROM employe
WHERE titre = "représentant" OR titre = "président";
-- 11) Afficher le nom, le titre, le numéro de département, le salaire des employés du département 34, dont le titre est «Représentant» ou «Secrétaire». 
SELECT nom,salaire,titre,nodep FROM employe
WHERE nodep = 34 AND titre = "représentant" OR nodep = 34 AND titre = "secrétaire";
-- 12) Afficher le nom, le titre, le numéro de département, le salaire des employés dont le titre est Représentant, ou dont le titre est Secrétaire dans le département numéro 34. 
SELECT nom,salaire,titre,nodep FROM employe
WHERE titre = "représentant" OR titre = "secrétaire" AND nodep = 34;
-- 13) Afficher le nom, et le salaire des employés dont le salaire est compris entre 20000et 30000. 
SELECT nom,salaire FROM employe
WHERE salaire > 20000 AND salaire < 30000;
-- 14) pas de quatorze..
-- 15) Afficher le nom des employés commençant par la lettre «H». 
SELECT nom FROM employe
WHERE nom LIKE "h%";
-- 16) Afficher le nom des employés se terminant par la lettre «n»
SELECT nom FROM employe
WHERE nom LIKE "%n";
-- 17) Afficher le nom des employés contenant la lettre «u» en 3èmeposition. 
SELECT nom FROM employe
WHERE nom LIKE "__u%";
-- 18)Afficher le salaire et le nom des employés du service 41classés par salaire croissant. 
SELECT nom,salaire FROM employe
WHERE nodep = 41
ORDER BY salaire ASC;
-- 19) Afficher le salaire et le nom des employés du service 41classés par salaire décroissant.
SELECT nom,salaire FROM employe
WHERE nodep= 41
ORDER BY salaire DESC;
-- 20) Afficher le titre, le salaire et le nom des employés classés par titre croissant et par salaire décroissant. 
SELECT titre,salaire nom FROM employe
ORDER BY titre ASC,salaire DESC;
-- 21) Afficher le taux de commission, le salaire et le nom des employés classés par taux de commission croissante. 
SELECT nom,salaire,tauxcom FROM employe
ORDER BY tauxcom ASC;
-- 22) Afficher le nom, le salaire, le taux de commission et le titre des employés dont le taux de commission n'est pas renseigné. 
SELECT nom,salaire,tauxcom,titre FROM employe
WHERE tauxcom IS NULL;
-- 23) Afficher le nom, le salaire, le taux de commission et le titre des employés dont le taux de commission est renseigné. 
SELECT nom,salaire,tauxcom,titre FROM employe
WHERE tauxcom IS NOT NULL;
-- 24) Afficher le nom, le salaire, le taux de commission, le titre des employés dont le taux de commission est inférieur à 15.
SELECT nom,salaire,tauxcom,titre FROM employe
WHERE tauxcom < 15;
-- 25) Afficher le nom, le salaire, le taux de commission, le titre des employés dont le taux de commission est supérieur à 15. 
SELECT nom,salaire,tauxcom,titre FROM employe
WHERE tauxcom > 15;
-- 26) Afficher le nom, le salaire, le taux de commission et la commission des employés dont le taux de commission n'est pas nul.(la commission est calculée en multipliant le salaire par le taux de commission)
SELECT nom,salaire,tauxcom,(salaire*tauxcom) AS commission FROM employe
WHERE tauxcom IS NOT NULL;
-- 27) Afficher le nom, le salaire, le taux de commission, la commission des employés dont le taux de commission n'est pas nul, classé par taux de commission croissant.
SELECT nom, salaire,tauxcom,(salaire*tauxcom) AS commission FROM employe
WHERE tauxcom IS NOT NULL
ORDER BY tauxcom ASC;
-- 28) Afficher le nom et le prénom (concaténés) des employés. Renommer les colonnes
SELECT CONCAT(nom," ",prenom) AS nom_et_prenom FROM employe;
-- 29) Afficher les 5 premières lettres du nom des employés.
SELECT SUBSTRING(nom, 1, 5) AS "les 5 premières lettres des noms des employés" FROM employe;
-- 30) Afficher le nom et le rang de la lettre«r» dans le nom des employés. 
SELECT nom,LOCATE("r", nom) AS "position du r" FROM employe;
-- 31) Afficher le nom, le nom en majuscule et le nom en minuscule de l'employé dont le nom est Vrante. 
SELECT nom,UPPER(nom) AS "nom en majuscule",LOWER(nom) AS "nom en minuscule" FROM employe
WHERE nom="vrante";
-- 32) Afficher le nom et le nombre de caractères du nom des employés. 
SELECT nom, LENGTH(nom) AS "nombre de lettres" FROM employe;

/* PARTIE 2*/
-- *Partie 2* 
-- Rechercher le prénom des employés et le numéro de la région de leur département.
SELECT prenom,noregion AS "numéro de région" FROM employe,dept 
WHERE nodept = nodep;
-- Rechercher le numéro du département, le nom du département, le nom des employés classés par numéro de département (renommer les tables utilisées).
SELECT nodep AS "numéro de département",dept.nom AS "nom de département",employe.nom AS "nom de l'employé" FROM employe,dept 
WHERE nodep=nodept 
ORDER BY nodep DESC;
-- Rechercher le nom des employés du département Distribution.
SELECT employe.nom FROM employe,dept 
WHERE nodep=nodept AND dept.nom = "distribution";
-- Rechercher le nom et le salaire des employés qui gagnent plus que leur patron, et le nom et le salaire de leur patron.
SELECT e1.nom AS "nom employé",e1.salaire AS "salaire employé",e2.nom AS "nom du patron",e2.salaire AS "salaire du patron" FROM employe AS e1, employe AS e2 
WHERE e1.nosup=e2.noemp AND e1.salaire>e2.salaire;
-- Rechercher le nom et le titre des employés qui ont le même titre que Amartakaldire.
SELECT nom,titre FROM employe 
WHERE titre= (SELECT titre FROM employe WHERE nom = "Amartakaldire");
-- Rechercher le nom, le salaire et le numéro de département des employés qui gagnent plus qu'un seul employé du département 31, classés par numéro de département et salaire.
SELECT nom,salaire,nodep FROM employe
WHERE salaire > ANY (SELECT salaire FROM employe WHERE nodep = 31)
ORDER BY nodep,salaire;
-- Rechercher le nom, le salaire et le numéro de département des employés qui gagnent plus que tous les employés du département 31, classés par numéro de département et salaire.
SELECT nom,salaire,nodep FROM employe
WHERE salaire > ALL(SELECT salaire FROM employe WHERE nodep = 31) 
ORDER BY nodep,salaire;
-- Rechercher le nom et le titre des employés du service 31 qui ont un titre que l'on trouve dans le département 32.
SELECT nom, titre FROM employe
WHERE titre = ANY(SELECT titre FROM employe WHERE nodep = 32);
-- Rechercher le nom et le titre des employés du service 31 qui ont un titre l'on ne trouve pas dans le département 32.
SELECT nom,titre FROM employe
WHERE titre NOT IN (SELECT titre FROM employe WHERE nodep = 32);
-- Rechercher le nom, le titre et le salaire des employés qui ont le même titre et le même salaire que Fairant.
SELECT nom,titre,salaire FROM employe
WHERE titre =(SELECT titre FROM employe WHERE nom="Fairent") AND salaire = (SELECT salaire FROM employe WHERE nom="fairent");
-- Rechercher le numéro de département, le nom du département, le nom des employés, en affichant aussi les départements dans lesquels il n'y a personne, classés par numéro de département.
SELECT dept.nodept,dept.nom AS "nom du département",employe.nom AS "nom employé" FROM employe
RIGHT JOIN dept ON nodep=nodept
ORDER BY nodept;
-- Calculer le nombre d'employés de chaque titre.
SELECT COUNT(titre) AS "nombre d'employé portant le titre", titre FROM employe
GROUP BY titre;
-- Calculer la moyenne des salaires et leur somme, par région.
SELECT AVG(salaire) AS "salaire moyen",SUM(salaire) AS 'total des salaires', noregion AS 'numéro de région' FROM employe,dept
WHERE nodep=nodept
GROUP BY noregion;
-- Afficher les numéros des départements ayant au moins 3 employés.
SELECT nodep AS "départements ayant plus de 3 employés" FROM employe
GROUP BY nodep
HAVING COUNT(*)>=3;
-- Afficher les lettres qui sont l'initiale d'au moins trois employés
SELECT LEFT(nom,1) AS initiale FROM employe
GROUP BY initiale
HAVING COUNT(initiale) >= 3;
-- Rechercher le salaire maximum et le salaire minimum parmi tous les salariés et l'écart entre les deux.
SELECT MAX(salaire) AS maximum,MIN(salaire) AS minimum ,MAX(salaire)-MIN(salaire) AS "difference entre le salaire max et le salaire min" FROM employe;
-- Rechercher le nombre de titres différents.
SELECT COUNT(DISTINCT titre) AS "nombre de titres" FROM employe;
-- Pour chaque titre, compter le nombre d'employés possédant ce titre.
SELECT titre,COUNT(titre) AS "nombre d'employés portant ce titre" FROM employe
GROUP BY titre;
-- Pour chaque nom de département, afficher le nom du département et le nombre d'employés.
SELECT COUNT(employe.nom),dept.nom,dept.nodept FROM employe 
JOIN dept ON nodep=nodepT
GROUP BY nodept;
-- Rechercher les titres et la moyenne des salaires par titre dont la moyenne est supérieure à la moyenne des salaires des Représentants.
SELECT titre,AVG(salaire) FROM employe
GROUP BY titre 
HAVING AVG(salaire)>(SELECT AVG(salaire) FROM employe WHERE titre="représentant");
-- 10.Rechercher le nombre de salaires renseignés et le nombre de taux de commission renseignés.
SELECT COUNT(salaire), COUNT(tauxcom) FROM employe
WHERE salaire IS NOT NULL OR tauxcom IS NOT NULL;
