-- ====================================
-- Views de relatório para a aplicação
-- Requisito atendido: JOIN + GROUP BY + SUM
-- ====================================

DROP VIEW IF EXISTS v_relatorio_execucao_usuario_dia;
DROP VIEW IF EXISTS v_desempenho_playlists;
DROP VIEW IF EXISTS v_ranking_artistas_global;

-- View 1: resumo diário de escuta por usuário
CREATE VIEW v_relatorio_execucao_usuario_dia AS
SELECT
    u.id_usuario,
    u.nome AS usuario,
    DATE(h.data_hora_reproducao) AS dia,
    COUNT(*) AS total_reproducoes,
    COUNT(DISTINCT h.id_musica) AS musicas_distintas,
    SUM(m.duracao) AS total_segundos,
    ROUND(SUM(m.duracao) / 60.0, 2) AS total_minutos,
    COUNT(DISTINCT ar.id_artista) AS artistas_distintos
FROM HISTORICO_REPRODUCAO h
JOIN USUARIO u ON u.id_usuario = h.id_usuario
JOIN MUSICA m ON m.id_musica = h.id_musica
JOIN ALBUM al ON al.id_album = m.id_album
JOIN ARTISTA ar ON ar.id_artista = al.id_artista
GROUP BY u.id_usuario, u.nome, DATE(h.data_hora_reproducao);

-- View 2: desempenho e composição das playlists
CREATE VIEW v_desempenho_playlists AS
SELECT
    p.id_playlist,
    p.nome_playlist,
    u.nome AS dono_playlist,
    COUNT(pm.id_musica) AS total_musicas,
    COUNT(DISTINCT ar.id_artista) AS artistas_distintos,
    SUM(m.duracao) AS duracao_total_segundos,
    ROUND(SUM(m.duracao) / 60.0, 2) AS duracao_total_minutos,
    MIN(pm.data_adicao) AS primeira_adicao,
    MAX(pm.data_adicao) AS ultima_adicao
FROM PLAYLIST p
JOIN USUARIO u ON u.id_usuario = p.id_usuario
LEFT JOIN PLAYLIST_MUSICA pm ON pm.id_playlist = p.id_playlist
LEFT JOIN MUSICA m ON m.id_musica = pm.id_musica
LEFT JOIN ALBUM al ON al.id_album = m.id_album
LEFT JOIN ARTISTA ar ON ar.id_artista = al.id_artista
GROUP BY p.id_playlist, p.nome_playlist, u.nome;

-- View 3: ranking geral de artistas com métricas de consumo
CREATE VIEW v_ranking_artistas_global AS
SELECT
    ar.id_artista,
    ar.nome AS artista,
    COUNT(h.data_hora_reproducao) AS total_reproducoes,
    COUNT(DISTINCT h.id_usuario) AS usuarios_unicos,
    COUNT(DISTINCT m.id_musica) AS musicas_catalogo,
    SUM(m.duracao) AS soma_duracao_reproduzida_segundos,
    ROUND(SUM(m.duracao) / 60.0, 2) AS soma_duracao_reproduzida_minutos,
    ROUND(COUNT(h.data_hora_reproducao)::numeric / NULLIF(COUNT(DISTINCT h.id_usuario), 0), 2) AS media_reproducoes_por_usuario
FROM ARTISTA ar
JOIN ALBUM al ON al.id_artista = ar.id_artista
JOIN MUSICA m ON m.id_album = al.id_album
LEFT JOIN HISTORICO_REPRODUCAO h ON h.id_musica = m.id_musica
GROUP BY ar.id_artista, ar.nome;

-- Consultas de teste para visualizar resultado das views
SELECT * FROM v_relatorio_execucao_usuario_dia ORDER BY dia DESC, total_reproducoes DESC LIMIT 20;
SELECT * FROM v_desempenho_playlists ORDER BY duracao_total_segundos DESC NULLS LAST, total_musicas DESC LIMIT 20;
SELECT * FROM v_ranking_artistas_global ORDER BY total_reproducoes DESC, usuarios_unicos DESC LIMIT 20;
