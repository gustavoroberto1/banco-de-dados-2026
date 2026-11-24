
-- ============================================
-- 1. CRIAR JOGADOR
-- ============================================

CREATE TABLE jogador (
    id_jogador SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ============================================
-- 2. CRIAR PERFIL (1:1)
-- CHAVE ESTRANGEIRA NO CREATE TABLE
-- ============================================

CREATE TABLE perfil (
    id_perfil SERIAL PRIMARY KEY,
    nickname VARCHAR(50) NOT NULL,
    ranking INT,
    descricao TEXT,
    id_jogador INT NOT NULL UNIQUE
        REFERENCES jogador(id_jogador)
);


-- ============================================
-- 3. CRIAR EQUIPE
-- ============================================

CREATE TABLE equipe (
    id_equipe SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    sigla VARCHAR(10),
    data_criacao DATE
);


-- ============================================
-- 4. RELACIONAR JOGADOR COM EQUIPE (1:N)
-- UTILIZANDO ALTER TABLE
-- ============================================

ALTER TABLE jogador ADD COLUMN id_equipe INT;
ALTER TABLE jogador ADD CONSTRAINT fk_jogador_equipe FOREIGN KEY (id_equipe) REFERENCES equipe(id_equipe);

INSERT INTO jogador (nome, email) VALUES ('Joãozinho da Silva', 'jaosival@gmail.com')
INSERT INTO jogador (nome, email) VALUES ('Pedrinh Manoel', 'pedrinh@gmail.com')

SELECT * FROM jogador

INSERT INTO perfil (nickname, ranking, descricao, id_jogador)
VALUES ('PEDROCA', 500, 'sEI LÁ, NUCA VI', 2)

SELECT * FROM perfil

CREATE TABLE jogo (
	id_jogo SERIAL PRIMARY KEY,
	nome VARCHAR(100) NOT NULL,
	categoria VARCHAR(50),
	desenvolvedora VARCHAR(100)
)

INSERT INTO jogo (nome, categoria, desenvolvedora) VALUES 
('Counter Strike 2', 'FPS', 'Valve'),
('League of Legends', 'MOBA', 'RIOT Games'),
('Valorante', 'FPS', 'RIOT Games')

SELECT * FROM jogo

CREATE TABLE campeonato (
	campeonado_id SERIAL PRIMARY KEY, 
	nome VARCHAR(100) NOT NULL,
	premiacao DECIMAL(10, 2),
	data_inicio DATE,
	id_jogo INT NOT NULL REFERENCES jogo(id_jogo)
);

INSERT INTO campeonato (nome, premiacao, data_inicio, id_jogo)
VALUES ('Major Singapura CS2', 1000000.0, '2026-11-23', 1)

SELECT * FROM campeonato

CREATE TYPE STATUS_INSCRICAO AS ENUM ('EM ANALISE', 'APROVADO', 'REPROVADO');
CREATE TABLE inscricao (
	inscricao_id SERIAL PRIMARY KEY,
	data_inscricao DATE NOT NULL,
	status STATUS_INSCRICAO,
	campeonato_id INT NOT NULL REFERENCES campeonato(campeonado_id),
	equipe_id INT NOT NULL REFERENCES equipe(id_equipe)
);

INSERT INTO equipe VALUES (DEFAULT, 'FURIA', 'FUR', '2026-10-10')

INSERT INTO inscricao (data_inscricao, status, campeonato_id, equipe_id)
VALUES ('2026-11-10', 'EM ANALISE', 2, 1)


SELECT 
	inscricao.status,
	inscricao.data_inscricao,
	equipe.nome,
	equipe.sigla,
	campeonato.nome,
	campeonato.premiacao,
	campeonato.data_inicio
FROM inscricao 
	INNER JOIN equipe ON inscricao.equipe_id = equipe.id_equipe
	INNER JOIN campeonato ON inscricao.campeonato_id = campeonato.campeonado_id


CREATE TABLE partida (
	id_partida SERIAL PRIMARY KEY,
	data_partida TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	rodada INT NOT NULL,
);

ALTER TABLE partida ADD COLUMN id_campeonato INT NOT NULL;
ALTER TABLE partida ADD CONSTRAINT fk_partida_campeonato FOREIGN KEY (id_campeonato)
REFERENCES campeonato(campeonado_id)

INSERT INTO partida (data_partida, rodada, id_campeonato) 
VALUES ('2026-11-24', 1, 2)

SELECT * FROM partida

CREATE TABLE equipe_partida (
	id_equipe_partida SERIAL PRIMARY KEY,
	pontuacao INT DEFAULT 0,
	id_partida INT NOT NULL REFERENCES partida(id_partida),
	id_equipe INT NOT NULL REFERENCES equipe(id_equipe)
)


SELECT * FROM equipe

