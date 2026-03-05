-- ====================================
-- Povoamento complementar para testes
-- Objetivo: deixar as tabelas principais com 50+ registros
-- Banco: PostgreSQL
-- ====================================

BEGIN;

-- Artistas: gera IDs de 11 a 60

INSERT INTO ARTISTA (id_artista, nome)
SELECT id_artista, nome
FROM (
    SELECT
        gs AS id_artista,
        (ARRAY[
            'Adele','Billie Eilish','Dua Lipa','Olivia Rodrigo','Harry Styles',
            'The Weeknd','Bruno Mars','Arctic Monkeys','Foo Fighters','Radiohead',
            'Metallica','Nirvana','Pearl Jam','U2','Oasis',
            'Imagine Dragons','Maroon 5','OneRepublic','Linkin Park','Coldplay',
            'Sam Smith','Sia','Lana Del Rey','Shawn Mendes','Ed Sheeran',
            'Beyoncé','Rihanna','Katy Perry','Lady Gaga','Miley Cyrus',
            'Post Malone','Travis Scott','Drake','Kendrick Lamar','J. Cole',
            'Anitta','Ludmilla','Iza','Pabllo Vittar','Jão',
            'Gilberto Gil','Caetano Veloso','Marisa Monte','Seu Jorge','Djavan',
            'Gal Costa','Rita Lee','Skank','Capital Inicial','Legião Urbana'
        ])[1 + ((gs - 11) % 50)] AS nome
    FROM generate_series(11, 60) AS gs
) AS dados
ON CONFLICT (id_artista) DO UPDATE
SET nome = EXCLUDED.nome;

-- Álbuns: distribui entre os artistas e alterna gêneros
INSERT INTO ALBUM (id_album, titulo, ano_lancamento, genero, id_artista)
SELECT id_album, titulo, ano_lancamento, genero, id_artista
FROM (
    SELECT
        gs AS id_album,
        (ARRAY[
            '21','When We All Fall Asleep, Where Do We Go?','Future Nostalgia','SOUR','Fine Line',
            'After Hours','Doo-Wops & Hooligans','AM','Wasting Light','OK Computer',
            'Master of Puppets','Nevermind','Ten','The Joshua Tree','(What''s the Story) Morning Glory?',
            'Night Visions','Songs About Jane','Native','Hybrid Theory','A Rush of Blood to the Head',
            'In the Lonely Hour','1000 Forms of Fear','Born to Die','Illuminate','Divide',
            'Lemonade','ANTI','Teenage Dream','The Fame','Plastic Hearts',
            'Hollywood''s Bleeding','Astroworld','Scorpion','DAMN.','2014 Forest Hills Drive',
            'Versions of Me','Numanice','Dona de Mim','Não Para Não','Lobos',
            'Refavela','Transa','Memórias, Crônicas e Declarações de Amor','Músicas para Churrasco, Vol. 1','Luz',
            'India','Fruto Proibido','Calango','Acústico MTV','Dois'
        ])[1 + ((gs - 21) % 50)] || ' (' || gs || ')' AS titulo,
        1980 + (gs % 44) AS ano_lancamento,
        CASE
            WHEN gs % 4 = 0 THEN 'Rock'
            WHEN gs % 4 = 1 THEN 'Pop'
            WHEN gs % 4 = 2 THEN 'MPB'
            ELSE 'Indie'
        END AS genero,
        ((gs - 1) % 60) + 1 AS id_artista
    FROM generate_series(21, 80) AS gs
) AS dados
ON CONFLICT (id_album) DO UPDATE
SET titulo = EXCLUDED.titulo,
    ano_lancamento = EXCLUDED.ano_lancamento,
    genero = EXCLUDED.genero,
    id_artista = EXCLUDED.id_artista;

-- Músicas: liga cada faixa a um álbum válido
INSERT INTO MUSICA (id_musica, titulo, duracao, url_musica, id_album)
SELECT id_musica, titulo, duracao, url_musica, id_album
FROM (
    SELECT
        gs AS id_musica,
        (ARRAY[
            'Rolling in the Deep','Bad Guy','Levitating','drivers license','Watermelon Sugar',
            'Blinding Lights','Just the Way You Are','Do I Wanna Know?','These Days','Karma Police',
            'Battery','Smells Like Teen Spirit','Alive','With or Without You','Wonderwall',
            'Demons','This Love','Counting Stars','In the End','The Scientist',
            'Stay With Me','Chandelier','Summertime Sadness','Stitches','Shape of You',
            'Formation','Diamonds','Firework','Poker Face','Midnight Sky',
            'Circles','Sicko Mode','God''s Plan','HUMBLE.','No Role Modelz',
            'Envolver','Cheguei','Pesadão','Disk Me','Idiota',
            'Palco','Sozinho','Ainda Bem','Amiga da Minha Mulher','Flor de Lis',
            'Baby','Ovelha Negra','Garota Nacional','Primeiros Erros','Tempo Perdido',
            'Viva La Vida','Yellow','Photograph','Thinking Out Loud','Shallow',
            'Believer','Radioactive','Numb','Fix You','Happier'
        ])[1 + ((gs - 31) % 60)] || ' #' || gs AS titulo,
        150 + (gs % 240) AS duracao,
        'https://media.local/tracks/faixa_' || gs || '.mp3' AS url_musica,
        ((gs - 1) % 80) + 1 AS id_album
    FROM generate_series(31, 120) AS gs
) AS dados
ON CONFLICT (id_musica) DO UPDATE
SET titulo = EXCLUDED.titulo,
    duracao = EXCLUDED.duracao,
    url_musica = EXCLUDED.url_musica,
    id_album = EXCLUDED.id_album;

-- Usuários: cria massa de teste com email único
INSERT INTO USUARIO (id_usuario, nome, email, senha)
SELECT id_usuario, nome, email, senha
FROM (
    SELECT
        gs AS id_usuario,
        (ARRAY[
            'Lucas Almeida','Beatriz Souza','Rafael Lima','Camila Rocha','Thiago Martins',
            'Fernanda Costa','Gustavo Ribeiro','Patricia Gomes','Renato Carvalho','Juliana Dias',
            'Matheus Oliveira','Vanessa Barbosa','Felipe Araujo','Larissa Nunes','Bruno Cardoso',
            'Mariana Teixeira','Diego Ferreira','Aline Rodrigues','Caio Melo','Priscila Batista',
            'Eduardo Moraes','Leticia Pires','Vinicius Santos','Carolina Freitas','Rodrigo Lopes',
            'Amanda Cavalcanti','Igor Monteiro','Bianca Alves','Henrique Porto','Tatiane Xavier',
            'Leonardo Farias','Isabela Cunha','Anderson Vieira','Natalia Prado','Paulo Henrique',
            'Renata Sales','Daniel Moura','Gabriela Andrade','Marcelo Peixoto','Bruna Campos',
            'Vitor Fernandes','Elisa Tavares','Douglas Ramos','Carla Medeiros','Otavio Neves',
            'Monica Barros','Cesar Magalhaes','Simone Aguiar','Murilo Fonseca','Alice Brito',
            'Heitor Antunes','Talita Pinheiro','Sergio Paiva','Clara Melo'
        ])[1 + ((gs - 7) % 54)] AS nome,
        'usuario.real.' || gs || '@mail.com' AS email,
        'hash' || gs AS senha
    FROM generate_series(7, 60) AS gs
) AS dados
ON CONFLICT (id_usuario) DO UPDATE
SET nome = EXCLUDED.nome,
    email = EXCLUDED.email,
    senha = EXCLUDED.senha;

-- Playlists: cria playlists distribuídas entre os usuários
INSERT INTO PLAYLIST (id_playlist, nome_playlist, data_criacao, id_usuario)
SELECT id_playlist, nome_playlist, data_criacao, id_usuario
FROM (
    SELECT
        gs AS id_playlist,
        'Playlist Gerada ' || gs AS nome_playlist,
        DATE '2024-01-01' + ((gs % 365) * INTERVAL '1 day') AS data_criacao,
        ((gs - 1) % 60) + 1 AS id_usuario
    FROM generate_series(6, 65) AS gs
) AS dados
ON CONFLICT (id_playlist) DO NOTHING;

-- Playlist x Música: adiciona 3 músicas por playlist
INSERT INTO PLAYLIST_MUSICA (id_playlist, id_musica, data_adicao)
SELECT
    p.id_playlist,
    (((p.id_playlist * 7) + offs) % 120) + 1 AS id_musica,
    DATE '2024-01-01' + (((p.id_playlist * 7) + offs) % 365) * INTERVAL '1 day' AS data_adicao
FROM PLAYLIST p
CROSS JOIN generate_series(0, 2) AS offs
ON CONFLICT (id_playlist, id_musica) DO NOTHING;

-- Histórico: adiciona reproduções por usuário em datas diferentes
INSERT INTO HISTORICO_REPRODUCAO (id_usuario, id_musica, data_hora_reproducao)
SELECT
    u.id_usuario,
    (((u.id_usuario * 11) + rep) % 120) + 1 AS id_musica,
    TIMESTAMP '2024-01-01 08:00:00' + ((u.id_usuario * 5 + rep) * INTERVAL '1 hour') AS data_hora_reproducao
FROM USUARIO u
CROSS JOIN generate_series(1, 5) AS rep
ON CONFLICT (id_usuario, id_musica, data_hora_reproducao) DO NOTHING;

-- Sincroniza sequências com o maior ID existente
SELECT setval('artista_id_artista_seq', COALESCE((SELECT MAX(id_artista) FROM ARTISTA), 1));
SELECT setval('album_id_album_seq', COALESCE((SELECT MAX(id_album) FROM ALBUM), 1));
SELECT setval('musica_id_musica_seq', COALESCE((SELECT MAX(id_musica) FROM MUSICA), 1));
SELECT setval('usuario_id_usuario_seq', COALESCE((SELECT MAX(id_usuario) FROM USUARIO), 1));
SELECT setval('playlist_id_playlist_seq', COALESCE((SELECT MAX(id_playlist) FROM PLAYLIST), 1));

COMMIT;

-- Conferência rápida de volume após o povoamento
SELECT 'ARTISTA' AS tabela, COUNT(*) AS total FROM ARTISTA
UNION ALL
SELECT 'ALBUM', COUNT(*) FROM ALBUM
UNION ALL
SELECT 'MUSICA', COUNT(*) FROM MUSICA
UNION ALL
SELECT 'USUARIO', COUNT(*) FROM USUARIO
UNION ALL
SELECT 'PLAYLIST', COUNT(*) FROM PLAYLIST
UNION ALL
SELECT 'PLAYLIST_MUSICA', COUNT(*) FROM PLAYLIST_MUSICA
UNION ALL
SELECT 'HISTORICO_REPRODUCAO', COUNT(*) FROM HISTORICO_REPRODUCAO
ORDER BY tabela;
