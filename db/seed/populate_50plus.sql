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
    SELECT gs AS id_artista, 'Artista Gerado ' || gs AS nome
    FROM generate_series(11, 60) AS gs
) AS dados
ON CONFLICT (id_artista) DO NOTHING;

-- Álbuns: distribui entre os artistas e alterna gêneros
INSERT INTO ALBUM (id_album, titulo, ano_lancamento, genero, id_artista)
SELECT id_album, titulo, ano_lancamento, genero, id_artista
FROM (
    SELECT
        gs AS id_album,
        'Album Gerado ' || gs AS titulo,
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
ON CONFLICT (id_album) DO NOTHING;

-- Músicas: liga cada faixa a um álbum válido
INSERT INTO MUSICA (id_musica, titulo, duracao, url_musica, id_album)
SELECT id_musica, titulo, duracao, url_musica, id_album
FROM (
    SELECT
        gs AS id_musica,
        'Musica Gerada ' || gs AS titulo,
        150 + (gs % 240) AS duracao,
        'http://musica/gerada_' || gs AS url_musica,
        ((gs - 1) % 80) + 1 AS id_album
    FROM generate_series(31, 120) AS gs
) AS dados
ON CONFLICT (id_musica) DO NOTHING;

-- Usuários: cria massa de teste com email único
INSERT INTO USUARIO (id_usuario, nome, email, senha)
SELECT id_usuario, nome, email, senha
FROM (
    SELECT
        gs AS id_usuario,
        'Usuario Gerado ' || gs AS nome,
        'usuario' || gs || '@email.com' AS email,
        'hash' || gs AS senha
    FROM generate_series(7, 60) AS gs
) AS dados
ON CONFLICT (id_usuario) DO NOTHING;

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
