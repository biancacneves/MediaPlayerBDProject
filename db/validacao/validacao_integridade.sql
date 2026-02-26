-- ====================================
-- Validação de consistência dos dados
-- 1) volume mínimo
-- 2) chaves estrangeiras órfãs
-- 3) campos obrigatórios nulos
-- ====================================

-- 1) Verifica se as tabelas principais atingiram 50+ registros
SELECT 'ARTISTA' AS tabela, COUNT(*) AS total, (COUNT(*) >= 50) AS atende_minimo FROM ARTISTA
UNION ALL
SELECT 'ALBUM', COUNT(*), (COUNT(*) >= 50) FROM ALBUM
UNION ALL
SELECT 'MUSICA', COUNT(*), (COUNT(*) >= 50) FROM MUSICA
UNION ALL
SELECT 'USUARIO', COUNT(*), (COUNT(*) >= 50) FROM USUARIO
UNION ALL
SELECT 'PLAYLIST', COUNT(*), (COUNT(*) >= 50) FROM PLAYLIST
ORDER BY tabela;

-- 2) Procura relacionamentos quebrados (FK órfã)
SELECT 'ALBUM.id_artista sem ARTISTA' AS regra, COUNT(*) AS inconsistencias
FROM ALBUM al LEFT JOIN ARTISTA ar ON ar.id_artista = al.id_artista
WHERE ar.id_artista IS NULL
UNION ALL
SELECT 'MUSICA.id_album sem ALBUM', COUNT(*)
FROM MUSICA m LEFT JOIN ALBUM al ON al.id_album = m.id_album
WHERE al.id_album IS NULL
UNION ALL
SELECT 'PLAYLIST.id_usuario sem USUARIO', COUNT(*)
FROM PLAYLIST p LEFT JOIN USUARIO u ON u.id_usuario = p.id_usuario
WHERE u.id_usuario IS NULL
UNION ALL
SELECT 'PLAYLIST_MUSICA.id_playlist sem PLAYLIST', COUNT(*)
FROM PLAYLIST_MUSICA pm LEFT JOIN PLAYLIST p ON p.id_playlist = pm.id_playlist
WHERE p.id_playlist IS NULL
UNION ALL
SELECT 'PLAYLIST_MUSICA.id_musica sem MUSICA', COUNT(*)
FROM PLAYLIST_MUSICA pm LEFT JOIN MUSICA m ON m.id_musica = pm.id_musica
WHERE m.id_musica IS NULL
UNION ALL
SELECT 'HISTORICO.id_usuario sem USUARIO', COUNT(*)
FROM HISTORICO_REPRODUCAO h LEFT JOIN USUARIO u ON u.id_usuario = h.id_usuario
WHERE u.id_usuario IS NULL
UNION ALL
SELECT 'HISTORICO.id_musica sem MUSICA', COUNT(*)
FROM HISTORICO_REPRODUCAO h LEFT JOIN MUSICA m ON m.id_musica = h.id_musica
WHERE m.id_musica IS NULL;

-- 3) Procura nulos em colunas obrigatórias
SELECT 'ARTISTA.nome nulo' AS regra, COUNT(*) AS inconsistencias FROM ARTISTA WHERE nome IS NULL
UNION ALL
SELECT 'ALBUM.titulo nulo', COUNT(*) FROM ALBUM WHERE titulo IS NULL
UNION ALL
SELECT 'ALBUM.ano_lancamento nulo', COUNT(*) FROM ALBUM WHERE ano_lancamento IS NULL
UNION ALL
SELECT 'ALBUM.genero nulo', COUNT(*) FROM ALBUM WHERE genero IS NULL
UNION ALL
SELECT 'ALBUM.id_artista nulo', COUNT(*) FROM ALBUM WHERE id_artista IS NULL
UNION ALL
SELECT 'MUSICA.titulo nulo', COUNT(*) FROM MUSICA WHERE titulo IS NULL
UNION ALL
SELECT 'MUSICA.duracao nulo', COUNT(*) FROM MUSICA WHERE duracao IS NULL
UNION ALL
SELECT 'MUSICA.url_musica nulo', COUNT(*) FROM MUSICA WHERE url_musica IS NULL
UNION ALL
SELECT 'MUSICA.id_album nulo', COUNT(*) FROM MUSICA WHERE id_album IS NULL
UNION ALL
SELECT 'USUARIO.nome nulo', COUNT(*) FROM USUARIO WHERE nome IS NULL
UNION ALL
SELECT 'USUARIO.email nulo', COUNT(*) FROM USUARIO WHERE email IS NULL
UNION ALL
SELECT 'USUARIO.senha nulo', COUNT(*) FROM USUARIO WHERE senha IS NULL
UNION ALL
SELECT 'PLAYLIST.nome_playlist nulo', COUNT(*) FROM PLAYLIST WHERE nome_playlist IS NULL
UNION ALL
SELECT 'PLAYLIST.id_usuario nulo', COUNT(*) FROM PLAYLIST WHERE id_usuario IS NULL
UNION ALL
SELECT 'PLAYLIST_MUSICA.data_adicao nulo', COUNT(*) FROM PLAYLIST_MUSICA WHERE data_adicao IS NULL
UNION ALL
SELECT 'HISTORICO.data_hora_reproducao nulo', COUNT(*) FROM HISTORICO_REPRODUCAO WHERE data_hora_reproducao IS NULL;
