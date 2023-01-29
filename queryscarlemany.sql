

--Ignacio Esteban
--Manuel Rodríguez
--Javier Ballester
--Iván Revuelta
--Sergio Olmo




-- RATINGS
CREATE TABLE ratings(
tcont char(10) primary key,
averagerating real,
numVotes integer
);

COPY ratings
FROM 'C:\Users\Administrador\Downloads\imdb\title.ratings.tsv'
DELIMITER E'\t'
CSV HEADER;

SELECT *
FROM ratings limit(10);


-- TITLE BASICS
CREATE TABLE title_basics(
tconst char(10) PRIMARY KEY,
titleType varchar(100),
primaryTitle varchar(500),
originalTitle varchar(500),
isAdult boolean,
startYear INTEGER,
endYear INTEGER,
runtimeMinutes INTEGER,
genres varchar(200)	 
);

COPY title_basics
FROM 'C:\Users\Administrador\Downloads\imdb\title.basics.tsv'
DELIMITER E'\t'
NULL AS '\N'
CSV HEADER;

SELECT *
FROM title_basics limit(10);

-- NAME BASICS
CREATE TABLE name_basics(
nconst char(10) PRIMARY KEY,
primaryName varchar(250),
birthYear INTEGER,
deathYear INTEGER,
primaryProfession varchar(250),
knownForTitles varchar(1000)
);

COPY name_basics
FROM 'C:\Users\Administrador\Downloads\imdb\name.basics.tsv'
DELIMITER E'\t'
NULL AS '\N'
CSV HEADER;

SELECT *
FROM name_basics limit(10);



-- EPISODE
CREATE TABLE title_episode(
	tconst char(10),
	parentTconst char(10),
	seasonNumber int,
	episodeNUmber int
	);

SELECT *
FROM title_episode limit(10);
	
COPY title_episode
FROM 'C:\Users\Administrador\Downloads\imdb\title.episode.tsv'
DELIMITER E'\t'
NULL AS '\N'
CSV HEADER;


--FILTRAR LA MEJOR SERIE 
SELECT t.originaltitle, r.averagerating
FROM title_basics t, ratings r
WHERE (r.tcont = t.tconst) and (t.titletype = 'tvSeries')
order by r.averagerating desc;

-- Al observar que la puntuación med. es de 10, añadimos el número de votos para verificar la puntuación
SELECT t.originaltitle, MAX(r.averagerating), max(r.numvotes)
FROM title_basics t
JOIN ratings r ON t.tconst = r.tcont
WHERE (t.titletype = 'tvSeries') and (r.averagerating = 10)
GROUP BY t.originaltitle, r.averagerating
ORDER BY max(r.numvotes) DESC;

--Filtramos las series según teniendo en cuenta el número de votos:
SELECT t.originaltitle, MAX(r.averagerating), max(r.numvotes)
FROM title_basics t
JOIN ratings r ON t.tconst = r.tcont
WHERE t.titletype = 'tvSeries'
GROUP BY t.originaltitle, r.averagerating
ORDER BY max(r.numvotes) DESC;

--FILTRAMOS PARA MOSTRAR TEMPORADAS Y CAPITULOS
		--SELECT t.originaltitle, e.seasonnumber, e.episodenumber
		--FROM title_basics t
		--JOIN title_episode e ON t.tconst = e.parenttconst
		--WHERE t.originaltitle = 'Breaking Bad';
		
		--select t.originaltitle, e.seasonnumber,SUM(e.episodenumber) as total_episodes
		--from title_episode e
		--join title_basics t ON e.parenttconst = t.tconst
		--where t.originaltitle = 'Breaking Bad'
		--GROUP by e.seasonnumber, t.originaltitle;
		
select t.originaltitle, e.seasonnumber,COUNT(e.episodenumber) as total_episodes
from title_episode e
join title_basics t ON e.parenttconst = t.tconst
where t.originaltitle = 'Breaking Bad'
GROUP by e.seasonnumber, t.originaltitle;



--FILTRAMOS PARA MOSTRAR EL DIRECTOR
SELECT t.tconst, t.originaltitle, n.primaryname
FROM name_basics n
JOIN title_basics t ON n.knownfortitles = t.tconst
WHERE t.originaltitle = 'Breaking Bad' and (n.primaryprofession like '%Director%')
GROUP BY t.tconst, t.originaltitle, n.primaryname;

select * from name_basics where knownfortitles = 'tt0903747';


SELECT * FROM name_basics
WHERE knownfortitles = 'tt0903747'
ORDER BY primaryname ASC
-- Código breaking bad
	--"tt0903747 "



select t.originaltitle, n.primaryname, n.primaryprofession
from name_basics n
JOIN title_basics t ON n.knownfortitles = t.tconst
where n.primaryname = 'Christopher King' and n.primaryprofession <> '' 
GROUP BY t.originaltitle, n.primaryname, n.primaryprofession
HAVING n.primaryprofession='actor';





--AL NO HABER DIRECTOR, COGEMOS AL CHRISTPHOER KING
select *
from name_basics 
where primaryname = 'Christopher King' 
limit(10);



--MOSTRAMOS NOMBRES DE OBRAS QUE HA PARTICIPADO
select t.originaltitle, n.primaryname, n.primaryprofession
from name_basics n
JOIN title_basics t ON n.knownfortitles = t.tconst
where n.primaryname = 'Christopher King' and n.primaryprofession <> '' 



--MOSTRAMOS AL PERSONAL QUE TRABAJÓ EN AVATAR
SELECT t.originaltitle, r.averagerating, n.primaryname, n.primaryprofession
FROM title_basics t
INNER JOIN ratings r ON t.tconst = r.tcont
INNER JOIN name_basics n ON t.tconst = n.knownfortitles
WHERE (t.originaltitle = 'Avatar')
ORDER BY primaryname ASC;





-- FIN













SELECT *
FROM name_basics limit(20);














select * from title


-- PASO 2 SELECCIONAR CONDICIONAL
SELECT t.originaltitle, r.averagerating
FROM title_basics t, ratings r
WHERE (r.tcont = t.tconst) and (t.originaltitle like '%Avatar%') and (t.startyear = 2009) and (t.titletype = 'movie');


SELECT AVG(r.averagerating)
FROM title_basics t, ratings r
WHERE (r.tcont = t.tconst) and (t.genres like '%Horror%') and (t.titletype = 'movie');


-- PASO 2 SELECCIONAR CONDICIONAL
SELECT t.originaltitle, r.averagerating
FROM title_basics t, ratings r
WHERE (r.tcont = t.tconst) and  (r.averagerating = 10);

select * from title_basics LIMIT(4);

SELECT t.originaltitle, r.averagerating
FROM title_basics t, ratings r
WHERE (r.tcont = t.tconst) and (t.isadult = true) ;


select * from title_basics where (isadult = true);

SELECT t.originaltitle, r.averagerating
FROM title_basics t, ratings r
WHERE  (t.titletype = 'movie') and (isadult = true);





--NACHO
SELECT MIN(r.averagerating), MAX(r.averagerating), AVG(r.averagerating)
FROM title_basics t
JOIN ratings r ON r.tcont = t.tconst
WHERE t.titletype = 'short' AND t.genres LIKE '%Comedy%'
--GROUP BY t.tconst
HAVING AVG(r.numvotes) > 300 AND AVG(r.averagerating) > 6.0;

-- QUERY 2 ACTIVIDAD GRUPAL
SELECT t.originaltitle, r.averagerating, COUNT(*) FROM title_basics t, ratings r
WHERE (r.tcont = t.tconst) and (t.titletype = 'tvEpisode') 
GROUP BY r.numVotes desc
HAVING t.startyear<>2012



