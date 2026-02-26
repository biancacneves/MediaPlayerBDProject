-- ====================================
-- CONSULTAS SQL ÚTEIS E AVANÇADAS
-- Sistema de Streaming Musical
-- ====================================

-- ====================================
-- 1. CONSULTAS BÁSICAS
-- ====================================

-- Listar todas as músicas com informações do álbum e artista
SELECT 
    m.titulo AS musica,
    m.duracao,
    al.titulo AS album,
    al.ano_lancamento,
    ar.nome AS artista,
    al.genero
FROM MUSICA m
JOIN ALBUM al ON m.id_album = al.id_album
JOIN ARTISTA ar ON al.id_artista = ar.id_artista
ORDER BY ar.nome, al.ano_lancamento, m.titulo;

-- Listar todas as playlists de um usuário específico
SELECT 
    p.nome_playlist,
    p.data_criacao,
    COUNT(pm.id_musica) AS total_musicas
FROM PLAYLIST p
LEFT JOIN PLAYLIST_MUSICA pm ON p.id_playlist = pm.id_playlist
WHERE p.id_usuario = 1
GROUP BY p.id_playlist, p.nome_playlist, p.data_criacao
ORDER BY p.data_criacao DESC;

-- Músicas de uma playlist específica com detalhes
SELECT 
    m.titulo AS musica,
    ar.nome AS artista,
    al.titulo AS album,
    m.duracao,
    pm.data_adicao
FROM PLAYLIST_MUSICA pm
JOIN MUSICA m ON pm.id_musica = m.id_musica
JOIN ALBUM al ON m.id_album = al.id_album
JOIN ARTISTA ar ON al.id_artista = ar.id_artista
WHERE pm.id_playlist = 1
ORDER BY pm.data_adicao DESC;

-- ====================================
-- 2. CONSULTAS COM AGREGAÇÃO
-- ====================================

-- Músicas mais reproduzidas (top 10)
SELECT 
    m.titulo AS musica,
    ar.nome AS artista,
    COUNT(*) AS total_reproducoes
FROM HISTORICO_REPRODUCAO h
JOIN MUSICA m ON h.id_musica = m.id_musica
JOIN ALBUM al ON m.id_album = al.id_album
JOIN ARTISTA ar ON al.id_artista = ar.id_artista
GROUP BY m.id_musica, m.titulo, ar.nome
ORDER BY total_reproducoes DESC
LIMIT 10;

-- Artistas mais ouvidos
SELECT 
    ar.nome AS artista,
    COUNT(*) AS total_reproducoes,
    COUNT(DISTINCT h.id_usuario) AS usuarios_unicos
FROM HISTORICO_REPRODUCAO h
JOIN MUSICA m ON h.id_musica = m.id_musica
JOIN ALBUM al ON m.id_album = al.id_album
JOIN ARTISTA ar ON al.id_artista = ar.id_artista
GROUP BY ar.id_artista, ar.nome
ORDER BY total_reproducoes DESC;

-- Usuário mais ativo (que mais escuta música)
SELECT 
    u.nome AS usuario,
    u.email,
    COUNT(*) AS total_reproducoes,
    COUNT(DISTINCT h.id_musica) AS musicas_diferentes
FROM USUARIO u
JOIN HISTORICO_REPRODUCAO h ON u.id_usuario = h.id_usuario
GROUP BY u.id_usuario, u.nome, u.email
ORDER BY total_reproducoes DESC;

-- Duração total de cada playlist (em minutos)
SELECT 
    p.nome_playlist,
    u.nome AS criador,
    COUNT(pm.id_musica) AS total_musicas,
    SUM(m.duracao) AS duracao_total_segundos,
    ROUND(SUM(m.duracao) / 60.0, 2) AS duracao_total_minutos
FROM PLAYLIST p
JOIN USUARIO u ON p.id_usuario = u.id_usuario
LEFT JOIN PLAYLIST_MUSICA pm ON p.id_playlist = pm.id_playlist
LEFT JOIN MUSICA m ON pm.id_musica = m.id_musica
GROUP BY p.id_playlist, p.nome_playlist, u.nome
ORDER BY duracao_total_segundos DESC;

-- ====================================
-- 3. CONSULTAS TEMPORAIS
-- ====================================

-- Histórico de reprodução de um usuário específico (últimos 30 dias)
SELECT 
    h.data_hora_reproducao,
    m.titulo AS musica,
    ar.nome AS artista,
    al.titulo AS album
FROM HISTORICO_REPRODUCAO h
JOIN MUSICA m ON h.id_musica = m.id_musica
JOIN ALBUM al ON m.id_album = al.id_album
JOIN ARTISTA ar ON al.id_artista = ar.id_artista
WHERE h.id_usuario = 1
  AND h.data_hora_reproducao >= datetime('now', '-30 days')
ORDER BY h.data_hora_reproducao DESC;

-- Músicas adicionadas recentemente às playlists
SELECT 
    p.nome_playlist,
    u.nome AS criador,
    m.titulo AS musica,
    ar.nome AS artista,
    pm.data_adicao
FROM PLAYLIST_MUSICA pm
JOIN PLAYLIST p ON pm.id_playlist = p.id_playlist
JOIN USUARIO u ON p.id_usuario = u.id_usuario
JOIN MUSICA m ON pm.id_musica = m.id_musica
JOIN ALBUM al ON m.id_album = al.id_album
JOIN ARTISTA ar ON al.id_artista = ar.id_artista
WHERE pm.data_adicao >= date('now', '-7 days')
ORDER BY pm.data_adicao DESC;

-- ====================================
-- 4. CONSULTAS AVANÇADAS
-- ====================================

-- Músicas que estão em múltiplas playlists
SELECT 
    m.titulo AS musica,
    ar.nome AS artista,
    COUNT(DISTINCT pm.id_playlist) AS total_playlists
FROM MUSICA m
JOIN ALBUM al ON m.id_album = al.id_album
JOIN ARTISTA ar ON al.id_artista = ar.id_artista
JOIN PLAYLIST_MUSICA pm ON m.id_musica = pm.id_musica
GROUP BY m.id_musica, m.titulo, ar.nome
HAVING COUNT(DISTINCT pm.id_playlist) > 1
ORDER BY total_playlists DESC;

-- Playlists com músicas de um artista específico
SELECT DISTINCT
    p.nome_playlist,
    u.nome AS criador,
    COUNT(m.id_musica) AS musicas_do_artista
FROM PLAYLIST p
JOIN USUARIO u ON p.id_usuario = u.id_usuario
JOIN PLAYLIST_MUSICA pm ON p.id_playlist = pm.id_playlist
JOIN MUSICA m ON pm.id_musica = m.id_musica
JOIN ALBUM al ON m.id_album = al.id_album
JOIN ARTISTA ar ON al.id_artista = ar.id_artista
WHERE ar.nome = 'Coldplay'
GROUP BY p.id_playlist, p.nome_playlist, u.nome
ORDER BY musicas_do_artista DESC;

-- Usuários que nunca reproduziram músicas
SELECT 
    u.id_usuario,
    u.nome,
    u.email
FROM USUARIO u
LEFT JOIN HISTORICO_REPRODUCAO h ON u.id_usuario = h.id_usuario
WHERE h.id_usuario IS NULL;

-- Músicas que nunca foram reproduzidas
SELECT 
    m.titulo AS musica,
    ar.nome AS artista,
    al.titulo AS album
FROM MUSICA m
JOIN ALBUM al ON m.id_album = al.id_album
JOIN ARTISTA ar ON al.id_artista = ar.id_artista
LEFT JOIN HISTORICO_REPRODUCAO h ON m.id_musica = h.id_musica
WHERE h.id_musica IS NULL
ORDER BY ar.nome, al.titulo, m.titulo;

-- ====================================
-- 5. ESTATÍSTICAS E ANÁLISES
-- ====================================

-- Média de músicas por playlist
SELECT 
    AVG(total_musicas) AS media_musicas_por_playlist
FROM (
    SELECT 
        p.id_playlist,
        COUNT(pm.id_musica) AS total_musicas
    FROM PLAYLIST p
    LEFT JOIN PLAYLIST_MUSICA pm ON p.id_playlist = pm.id_playlist
    GROUP BY p.id_playlist
);

-- Distribuição de álbuns por gênero
SELECT 
    genero,
    COUNT(*) AS total_albuns,
    COUNT(DISTINCT id_artista) AS total_artistas
FROM ALBUM
GROUP BY genero
ORDER BY total_albuns DESC;

-- Álbuns por década
SELECT 
    (ano_lancamento / 10) * 10 AS decada,
    COUNT(*) AS total_albuns
FROM ALBUM
GROUP BY decada
ORDER BY decada DESC;

-- Taxa de repetição de músicas por usuário
SELECT 
    u.nome AS usuario,
    COUNT(*) AS total_reproducoes,
    COUNT(DISTINCT h.id_musica) AS musicas_unicas,
    ROUND(CAST(COUNT(*) AS REAL) / COUNT(DISTINCT h.id_musica), 2) AS taxa_repeticao
FROM USUARIO u
JOIN HISTORICO_REPRODUCAO h ON u.id_usuario = h.id_usuario
GROUP BY u.id_usuario, u.nome
ORDER BY taxa_repeticao DESC;

-- ====================================
-- 6. RECOMENDAÇÕES E DESCOBERTAS
-- ====================================

-- Sugestões de músicas baseadas no histórico (músicas populares não ouvidas)
SELECT 
    m.titulo AS musica,
    ar.nome AS artista,
    al.titulo AS album,
    COUNT(h.id_usuario) AS total_ouvintes
FROM MUSICA m
JOIN ALBUM al ON m.id_album = al.id_album
JOIN ARTISTA ar ON al.id_artista = ar.id_artista
LEFT JOIN HISTORICO_REPRODUCAO h ON m.id_musica = h.id_musica
WHERE m.id_musica NOT IN (
    SELECT id_musica 
    FROM HISTORICO_REPRODUCAO 
    WHERE id_usuario = 1
)
GROUP BY m.id_musica, m.titulo, ar.nome, al.titulo
HAVING COUNT(h.id_usuario) > 0
ORDER BY total_ouvintes DESC
LIMIT 10;

-- Artistas similares (baseado em usuários que ouviram ambos)
SELECT 
    ar2.nome AS artista_similar,
    COUNT(DISTINCT h2.id_usuario) AS usuarios_em_comum
FROM HISTORICO_REPRODUCAO h1
JOIN MUSICA m1 ON h1.id_musica = m1.id_musica
JOIN ALBUM al1 ON m1.id_album = al1.id_album
JOIN ARTISTA ar1 ON al1.id_artista = ar1.id_artista
JOIN HISTORICO_REPRODUCAO h2 ON h1.id_usuario = h2.id_usuario
JOIN MUSICA m2 ON h2.id_musica = m2.id_musica
JOIN ALBUM al2 ON m2.id_album = al2.id_album
JOIN ARTISTA ar2 ON al2.id_artista = ar2.id_artista
WHERE ar1.nome = 'Coldplay'
  AND ar2.nome != 'Coldplay'
GROUP BY ar2.id_artista, ar2.nome
ORDER BY usuarios_em_comum DESC
LIMIT 5;

-- ====================================
-- 7. OPERAÇÕES DE MANUTENÇÃO
-- ====================================

-- Verificar integridade: Músicas sem álbum válido
SELECT m.*
FROM MUSICA m
LEFT JOIN ALBUM al ON m.id_album = al.id_album
WHERE al.id_album IS NULL;

-- Verificar integridade: Álbuns sem artista válido
SELECT al.*
FROM ALBUM al
LEFT JOIN ARTISTA ar ON al.id_artista = ar.id_artista
WHERE ar.id_artista IS NULL;

-- Encontrar emails duplicados (não deve haver)
SELECT email, COUNT(*) AS total
FROM USUARIO
GROUP BY email
HAVING COUNT(*) > 1;

-- ====================================
-- 8. OPERAÇÕES DE MODIFICAÇÃO (UPDATE/DELETE)
-- ====================================

-- UPDATE: Atualizar nome de um usuário
UPDATE USUARIO
SET nome = 'Yasmin Silva Costa'
WHERE id_usuario = 1;

-- UPDATE: Atualizar gênero de um álbum
UPDATE ALBUM
SET genero = 'Pop/Rock'
WHERE id_album = 2;

-- UPDATE: Atualizar múltiplos registros - Aumentar duração de músicas de um álbum
UPDATE MUSICA
SET duracao = duracao + 5
WHERE id_album = 3;

-- DELETE: Remover uma música específica (cascata via FK)
-- Nota: Primeiro remove dos históricos e playlists
DELETE FROM HISTORICO_REPRODUCAO
WHERE id_musica = 19;

DELETE FROM PLAYLIST_MUSICA
WHERE id_musica = 19;

DELETE FROM MUSICA
WHERE id_musica = 19 AND titulo = 'It''s Time';

-- DELETE: Remover uma playlist vazia
DELETE FROM PLAYLIST_MUSICA
WHERE id_playlist = 5;

DELETE FROM PLAYLIST
WHERE id_playlist = 5 AND id_usuario = 4;

-- DELETE: Remover histórico de reprodução antigo (mais de 1 ano)
DELETE FROM HISTORICO_REPRODUCAO
WHERE data_hora_reproducao < datetime('now', '-1 year');

-- DELETE: Limpar histórico de um usuário específico
DELETE FROM HISTORICO_REPRODUCAO
WHERE id_usuario = 2;

-- ====================================
-- 9. VIEWS ÚTEIS
-- ====================================

-- View: Catálogo completo de músicas
CREATE VIEW IF NOT EXISTS vw_catalogo_musicas AS
SELECT 
    m.id_musica,
    m.titulo AS musica,
    m.duracao,
    al.titulo AS album,
    al.ano_lancamento,
    al.genero,
    ar.nome AS artista
FROM MUSICA m
JOIN ALBUM al ON m.id_album = al.id_album
JOIN ARTISTA ar ON al.id_artista = ar.id_artista;

-- View: Estatísticas de usuários
CREATE VIEW IF NOT EXISTS vw_estatisticas_usuarios AS
SELECT 
    u.id_usuario,
    u.nome,
    u.email,
    COUNT(DISTINCT p.id_playlist) AS total_playlists,
    COUNT(DISTINCT h.id_musica) AS musicas_escutadas,
    COUNT(h.data_hora_reproducao) AS total_reproducoes
FROM USUARIO u
LEFT JOIN PLAYLIST p ON u.id_usuario = p.id_usuario
LEFT JOIN HISTORICO_REPRODUCAO h ON u.id_usuario = h.id_usuario
GROUP BY u.id_usuario, u.nome, u.email;

-- Consultar views criadas
SELECT * FROM vw_catalogo_musicas ORDER BY artista, album;
SELECT * FROM vw_estatisticas_usuarios ORDER BY total_reproducoes DESC;
