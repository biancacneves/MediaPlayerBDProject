-- ====================================
-- SCRIPT DDL + DML - SISTEMA DE STREAMING MUSICAL
-- ====================================
-- Projeto: MediaPlayerBDProject
-- Descrição: Banco de dados relacional para sistema de streaming de música
-- SGBD: SQLite 3
-- Normalização: Terceira Forma Normal (3FN)
-- ====================================

-- ====================================
-- REMOÇÃO DE TABELAS (se existirem)
-- ====================================

DROP TABLE IF EXISTS HISTORICO_REPRODUCAO;
DROP TABLE IF EXISTS PLAYLIST_MUSICA;
DROP TABLE IF EXISTS PLAYLIST;
DROP TABLE IF EXISTS MUSICA;
DROP TABLE IF EXISTS ALBUM;
DROP TABLE IF EXISTS ARTISTA;
DROP TABLE IF EXISTS USUARIO;

-- ====================================
-- CRIAÇÃO DAS TABELAS (DDL)
-- ====================================

CREATE TABLE ARTISTA (
    id_artista INTEGER PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE ALBUM (
    id_album INTEGER PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    ano_lancamento INTEGER NOT NULL,
    genero VARCHAR(50) NOT NULL,
    id_artista INTEGER NOT NULL,
    FOREIGN KEY (id_artista) REFERENCES ARTISTA(id_artista)
);

CREATE TABLE MUSICA (
    id_musica INTEGER PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    duracao INTEGER NOT NULL,
    url_musica VARCHAR(255) NOT NULL,
    id_album INTEGER NOT NULL,
    FOREIGN KEY (id_album) REFERENCES ALBUM(id_album)
);

CREATE TABLE USUARIO (
    id_usuario INTEGER PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL
);

CREATE TABLE PLAYLIST (
    id_playlist INTEGER PRIMARY KEY,
    nome_playlist VARCHAR(100) NOT NULL,
    data_criacao DATE DEFAULT CURRENT_DATE,
    id_usuario INTEGER NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario)
);

CREATE TABLE PLAYLIST_MUSICA (
    id_playlist INTEGER NOT NULL,
    id_musica INTEGER NOT NULL,
    data_adicao DATE NOT NULL,
    PRIMARY KEY (id_playlist, id_musica),
    FOREIGN KEY (id_playlist) REFERENCES PLAYLIST(id_playlist),
    FOREIGN KEY (id_musica) REFERENCES MUSICA(id_musica)
);

CREATE TABLE HISTORICO_REPRODUCAO (
    id_usuario INTEGER NOT NULL,
    id_musica INTEGER NOT NULL,
    data_hora_reproducao DATETIME NOT NULL,
    PRIMARY KEY (id_usuario, id_musica, data_hora_reproducao),
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario),
    FOREIGN KEY (id_musica) REFERENCES MUSICA(id_musica)
);

-- ====================================
-- ÍNDICES PARA OTIMIZAÇÃO
-- ====================================

-- Índice para busca de álbuns por artista
CREATE INDEX idx_album_artista ON ALBUM(id_artista);

-- Índice para busca de músicas por álbum
CREATE INDEX idx_musica_album ON MUSICA(id_album);

-- Índice para busca de playlists por usuário
CREATE INDEX idx_playlist_usuario ON PLAYLIST(id_usuario);

-- Índice para busca de músicas em playlists
CREATE INDEX idx_playlist_musica_playlist ON PLAYLIST_MUSICA(id_playlist);
CREATE INDEX idx_playlist_musica_musica ON PLAYLIST_MUSICA(id_musica);

-- Índice para busca no histórico por usuário
CREATE INDEX idx_historico_usuario ON HISTORICO_REPRODUCAO(id_usuario);

-- Índice para busca no histórico por música (músicas mais tocadas)
CREATE INDEX idx_historico_musica ON HISTORICO_REPRODUCAO(id_musica);

-- Índice para busca no histórico por data/hora
CREATE INDEX idx_historico_data ON HISTORICO_REPRODUCAO(data_hora_reproducao);

-- Índice para busca de usuários por email (login)
CREATE INDEX idx_usuario_email ON USUARIO(email);

-- ====================================
-- INSERÇÃO DE DADOS DE TESTE (DML)
-- ====================================

-- ====================================
-- INSERÇÃO DE DADOS DE TESTE (DML)
-- ====================================

-- Inserção de Artistas
INSERT INTO ARTISTA VALUES (1, 'Coldplay');
INSERT INTO ARTISTA VALUES (2, 'The Beatles');
INSERT INTO ARTISTA VALUES (3, 'Taylor Swift');
INSERT INTO ARTISTA VALUES (4, 'Ed Sheeran');
INSERT INTO ARTISTA VALUES (5, 'Imagine Dragons');
INSERT INTO ARTISTA VALUES (6, 'Elton John');
INSERT INTO ARTISTA VALUES (7, 'Djavan');
INSERT INTO ARTISTA VALUES (8, 'Gal Costa');
INSERT INTO ARTISTA VALUES (9, 'Rita Lee');
INSERT INTO ARTISTA VALUES (10, 'The Cure');

-- Inserção de Álbuns
INSERT INTO ALBUM VALUES (1, 'Parachutes', 2000, 'Rock', 1);
INSERT INTO ALBUM VALUES (2, 'A Rush of Blood to the Head', 2002, 'Rock', 1);
INSERT INTO ALBUM VALUES (3, 'Abbey Road', 1969, 'Rock', 2);
INSERT INTO ALBUM VALUES (4, 'Let It Be', 1970, 'Rock', 2);
INSERT INTO ALBUM VALUES (5, '1989', 2014, 'Pop', 3);
INSERT INTO ALBUM VALUES (6, 'Midnights', 2022, 'Pop', 3);
INSERT INTO ALBUM VALUES (7, 'Divide', 2017, 'Pop', 4);
INSERT INTO ALBUM VALUES (8, 'Multiply', 2014, 'Pop', 4);
INSERT INTO ALBUM VALUES (9, 'Night Visions', 2012, 'Rock', 5);
INSERT INTO ALBUM VALUES (10, 'Evolve', 2017, 'Rock', 5);
INSERT INTO ALBUM VALUES (11, 'Goodbye Yellow Brick Road', 1973, 'Rock', 6);
INSERT INTO ALBUM VALUES (12, 'Rocket Man', 1972, 'Rock', 6);
INSERT INTO ALBUM VALUES (13, 'Luz', 1982, 'MPB', 7);
INSERT INTO ALBUM VALUES (14, 'Samurai', 1982, 'MPB', 7);
INSERT INTO ALBUM VALUES (15, 'Índia', 1973, 'MPB', 8);
INSERT INTO ALBUM VALUES (16, 'Gal Tropical', 1979, 'MPB', 8);
INSERT INTO ALBUM VALUES (17, 'Fruto Proibido', 1975, 'Rock', 9);
INSERT INTO ALBUM VALUES (18, 'Rita Lee', 1980, 'Rock', 9);
INSERT INTO ALBUM VALUES (19, 'Disintegration', 1989, 'Rock', 10);
INSERT INTO ALBUM VALUES (20, 'Wish', 1992, 'Rock', 10);

-- Inserção de Músicas
-- Coldplay
INSERT INTO MUSICA VALUES (1, 'Yellow', 260, 'http://musica/yellow', 1);
INSERT INTO MUSICA VALUES (2, 'Trouble', 270, 'http://musica/trouble', 1);
INSERT INTO MUSICA VALUES (3, 'The Scientist', 309, 'http://musica/scientist', 2);
INSERT INTO MUSICA VALUES (29, 'Fix You', 296, 'http://musica/fixyou', 2);

-- The Beatles
INSERT INTO MUSICA VALUES (4, 'Come Together', 259, 'http://musica/cometogether', 3);
INSERT INTO MUSICA VALUES (5, 'Here Comes The Sun', 185, 'http://musica/sun', 3);
INSERT INTO MUSICA VALUES (6, 'Let It Be', 243, 'http://musica/letitbe', 4);

-- Taylor Swift
INSERT INTO MUSICA VALUES (7, 'Shake It Off', 219, 'http://musica/shakeitoff', 5);
INSERT INTO MUSICA VALUES (8, 'Blank Space', 231, 'http://musica/blankspace', 5);
INSERT INTO MUSICA VALUES (9, 'Style', 231, 'http://musica/style', 5);

-- Ed Sheeran
INSERT INTO MUSICA VALUES (10, 'Shape of You', 233, 'http://musica/shape', 7);
INSERT INTO MUSICA VALUES (11, 'Perfect', 263, 'http://musica/perfect', 7);
INSERT INTO MUSICA VALUES (12, 'Castle on the Hill', 261, 'http://musica/castle', 8);

-- Imagine Dragons
INSERT INTO MUSICA VALUES (13, 'Radioactive', 186, 'http://musica/radioactive', 9);
INSERT INTO MUSICA VALUES (14, 'Demons', 175, 'http://musica/demons', 9);
INSERT INTO MUSICA VALUES (15, 'It''s Time', 240, 'http://musica/itstime', 10);

-- Elton John
INSERT INTO MUSICA VALUES (16, 'Rocket Man', 284, 'http://musica/rocketman', 12);
INSERT INTO MUSICA VALUES (17, 'Tiny Dancer', 376, 'http://musica/tinydancer', 11);
INSERT INTO MUSICA VALUES (30, 'Yellow Brick Road', 257, 'http://musica/yellowbrick', 11);

-- Djavan
INSERT INTO MUSICA VALUES (18, 'Flor de Lis', 250, 'http://musica/flordelis', 13);
INSERT INTO MUSICA VALUES (19, 'Samurai', 280, 'http://musica/samurai', 14);
INSERT INTO MUSICA VALUES (26, 'Azul', 265, 'http://musica/azul', 13);

-- Gal Costa
INSERT INTO MUSICA VALUES (20, 'Baby', 195, 'http://musica/baby', 15);
INSERT INTO MUSICA VALUES (21, 'Índia', 290, 'http://musica/india', 15);
INSERT INTO MUSICA VALUES (27, 'Meu Bem, Meu Mal', 240, 'http://musica/meubem', 16);

-- Rita Lee
INSERT INTO MUSICA VALUES (22, 'Ovelha Negra', 215, 'http://musica/ovelhane', 17);
INSERT INTO MUSICA VALUES (23, 'Mania de Você', 230, 'http://musica/mania', 17);
INSERT INTO MUSICA VALUES (28, 'Agora Só Falta Você', 205, 'http://musica/agora', 18);

-- The Cure
INSERT INTO MUSICA VALUES (24, 'Lovesong', 211, 'http://musica/lovesong', 19);
INSERT INTO MUSICA VALUES (25, 'Boys Don''t Cry', 159, 'http://musica/boysdontcry', 19);

-- Inserção de Usuários
INSERT INTO USUARIO VALUES (1, 'Yasmin Silva', 'yasmin@email.com', 'hash123');
INSERT INTO USUARIO VALUES (2, 'João Santos', 'joao@email.com', 'hash456');
INSERT INTO USUARIO VALUES (3, 'Maria Oliveira', 'maria@email.com', 'hash789');
INSERT INTO USUARIO VALUES (4, 'Pedro Costa', 'pedro@email.com', 'hash101');
INSERT INTO USUARIO VALUES (5, 'Gabriela', 'gabriela@email.com', 'hash202');
INSERT INTO USUARIO VALUES (6, 'Rita', 'rita@email.com', 'hash303');

-- Inserção de Playlists
INSERT INTO PLAYLIST (id_playlist, nome_playlist, data_criacao, id_usuario) 
VALUES (1, 'Favoritas', '2023-10-27', 1);
INSERT INTO PLAYLIST (id_playlist, nome_playlist, data_criacao, id_usuario) 
VALUES (2, 'Rock Clássico', '2023-11-01', 1);
INSERT INTO PLAYLIST (id_playlist, nome_playlist, data_criacao, id_usuario) 
VALUES (3, 'Treino', '2023-11-05', 2);
INSERT INTO PLAYLIST (id_playlist, nome_playlist, data_criacao, id_usuario) 
VALUES (4, 'Românticas', '2023-11-10', 3);
INSERT INTO PLAYLIST (id_playlist, nome_playlist, data_criacao, id_usuario) 
VALUES (5, 'Pop Hits', '2023-11-15', 4);

-- Relacionamento Playlist-Música
-- Playlist 1: Favoritas (Yasmin)
INSERT INTO PLAYLIST_MUSICA VALUES (1, 1, '2023-10-27');
INSERT INTO PLAYLIST_MUSICA VALUES (1, 2, '2023-10-27');
INSERT INTO PLAYLIST_MUSICA VALUES (1, 10, '2023-10-28');
INSERT INTO PLAYLIST_MUSICA VALUES (1, 11, '2023-10-29');
INSERT INTO PLAYLIST_MUSICA VALUES (1, 18, '2023-10-30');

-- Playlist 2: Rock Clássico (Yasmin)
INSERT INTO PLAYLIST_MUSICA VALUES (2, 4, '2023-11-01');
INSERT INTO PLAYLIST_MUSICA VALUES (2, 5, '2023-11-01');
INSERT INTO PLAYLIST_MUSICA VALUES (2, 6, '2023-11-01');
INSERT INTO PLAYLIST_MUSICA VALUES (2, 16, '2023-11-02');
INSERT INTO PLAYLIST_MUSICA VALUES (2, 17, '2023-11-02');

-- Playlist 3: Treino (João)
INSERT INTO PLAYLIST_MUSICA VALUES (3, 13, '2023-11-05');
INSERT INTO PLAYLIST_MUSICA VALUES (3, 14, '2023-11-05');
INSERT INTO PLAYLIST_MUSICA VALUES (3, 7, '2023-11-06');
INSERT INTO PLAYLIST_MUSICA VALUES (3, 15, '2023-11-06');

-- Playlist 4: Românticas (Maria)
INSERT INTO PLAYLIST_MUSICA VALUES (4, 11, '2023-11-10');
INSERT INTO PLAYLIST_MUSICA VALUES (4, 24, '2023-11-10');
INSERT INTO PLAYLIST_MUSICA VALUES (4, 3, '2023-11-11');
INSERT INTO PLAYLIST_MUSICA VALUES (4, 6, '2023-11-11');
INSERT INTO PLAYLIST_MUSICA VALUES (4, 29, '2023-11-12');

-- Playlist 5: Pop Hits (Pedro)
INSERT INTO PLAYLIST_MUSICA VALUES (5, 7, '2023-11-15');
INSERT INTO PLAYLIST_MUSICA VALUES (5, 8, '2023-11-15');
INSERT INTO PLAYLIST_MUSICA VALUES (5, 9, '2023-11-15');
INSERT INTO PLAYLIST_MUSICA VALUES (5, 10, '2023-11-16');

-- Histórico de Reprodução
-- Yasmin
INSERT INTO HISTORICO_REPRODUCAO VALUES (1, 1, '2023-10-27 10:00:00');
INSERT INTO HISTORICO_REPRODUCAO VALUES (1, 1, '2023-10-27 10:05:00');
INSERT INTO HISTORICO_REPRODUCAO VALUES (1, 2, '2023-10-27 10:10:00');
INSERT INTO HISTORICO_REPRODUCAO VALUES (1, 10, '2023-10-28 15:30:00');
INSERT INTO HISTORICO_REPRODUCAO VALUES (1, 11, '2023-10-28 15:35:00');
INSERT INTO HISTORICO_REPRODUCAO VALUES (1, 4, '2023-11-01 20:00:00');
INSERT INTO HISTORICO_REPRODUCAO VALUES (1, 5, '2023-11-01 20:05:00');
INSERT INTO HISTORICO_REPRODUCAO VALUES (1, 18, '2023-11-02 14:20:00');

-- João
INSERT INTO HISTORICO_REPRODUCAO VALUES (2, 13, '2023-11-05 07:00:00');
INSERT INTO HISTORICO_REPRODUCAO VALUES (2, 14, '2023-11-05 07:03:00');
INSERT INTO HISTORICO_REPRODUCAO VALUES (2, 7, '2023-11-05 07:06:00');
INSERT INTO HISTORICO_REPRODUCAO VALUES (2, 15, '2023-11-05 07:10:00');
INSERT INTO HISTORICO_REPRODUCAO VALUES (2, 13, '2023-11-06 07:00:00');

-- Maria
INSERT INTO HISTORICO_REPRODUCAO VALUES (3, 11, '2023-11-10 21:00:00');
INSERT INTO HISTORICO_REPRODUCAO VALUES (3, 24, '2023-11-10 21:05:00');
INSERT INTO HISTORICO_REPRODUCAO VALUES (3, 3, '2023-11-11 19:00:00');
INSERT INTO HISTORICO_REPRODUCAO VALUES (3, 6, '2023-11-11 19:05:00');
INSERT INTO HISTORICO_REPRODUCAO VALUES (3, 11, '2023-11-12 22:00:00');
INSERT INTO HISTORICO_REPRODUCAO VALUES (3, 29, '2023-11-12 22:15:00');

-- Pedro
INSERT INTO HISTORICO_REPRODUCAO VALUES (4, 7, '2023-11-15 14:00:00');
INSERT INTO HISTORICO_REPRODUCAO VALUES (4, 8, '2023-11-15 14:03:00');
INSERT INTO HISTORICO_REPRODUCAO VALUES (4, 9, '2023-11-15 14:06:00');
INSERT INTO HISTORICO_REPRODUCAO VALUES (4, 10, '2023-11-16 16:00:00');
INSERT INTO HISTORICO_REPRODUCAO VALUES (4, 10, '2023-11-17 18:00:00');

-- Gabriela
INSERT INTO HISTORICO_REPRODUCAO VALUES (5, 18, '2023-11-18 10:00:00');
INSERT INTO HISTORICO_REPRODUCAO VALUES (5, 19, '2023-11-18 10:05:00');
INSERT INTO HISTORICO_REPRODUCAO VALUES (5, 20, '2023-11-18 10:10:00');
INSERT INTO HISTORICO_REPRODUCAO VALUES (5, 26, '2023-11-18 11:00:00');

-- Rita
INSERT INTO HISTORICO_REPRODUCAO VALUES (6, 22, '2023-11-19 15:00:00');
INSERT INTO HISTORICO_REPRODUCAO VALUES (6, 23, '2023-11-19 15:04:00');
INSERT INTO HISTORICO_REPRODUCAO VALUES (6, 28, '2023-11-19 15:08:00');
INSERT INTO HISTORICO_REPRODUCAO VALUES (6, 21, '2023-11-19 16:00:00');