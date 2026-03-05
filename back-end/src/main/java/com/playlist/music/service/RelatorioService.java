package com.playlist.music.service;

import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

@Service
public class RelatorioService {

    private final JdbcTemplate jdbcTemplate;

    public RelatorioService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public List<Map<String, Object>> relatorioUsuariosDia() {
        return jdbcTemplate.queryForList("""
            SELECT
                u.nome AS usuario,
                DATE(h.data_hora_reproducao) AS dia,
                COUNT(*) AS total_reproducoes,
                COUNT(DISTINCT h.id_musica) AS musicas_distintas,
                ROUND(SUM(m.duracao) / 60.0, 2) AS total_minutos
            FROM historico_reproducao h
            JOIN usuario u ON u.id_usuario = h.id_usuario
            JOIN musica m ON m.id_musica = h.id_musica
            GROUP BY u.nome, DATE(h.data_hora_reproducao)
            ORDER BY dia DESC, total_reproducoes DESC
        """);
    }

    public List<Map<String, Object>> relatorioPlaylists() {
        return jdbcTemplate.queryForList("""
            SELECT
                p.nome_playlist,
                u.nome AS dono_playlist,
                COUNT(pm.id_musica) AS total_musicas,
                ROUND(COALESCE(SUM(m.duracao), 0) / 60.0, 2) AS duracao_total_minutos
            FROM playlist p
            JOIN usuario u ON u.id_usuario = p.id_usuario
            LEFT JOIN playlist_musica pm ON pm.id_playlist = p.id_playlist
            LEFT JOIN musica m ON m.id_musica = pm.id_musica
            GROUP BY p.nome_playlist, u.nome
            ORDER BY total_musicas DESC, duracao_total_minutos DESC
        """);
    }

    public List<Map<String, Object>> relatorioRankingArtistas() {
        return jdbcTemplate.queryForList("""
            SELECT
                ar.nome AS artista,
                COUNT(h.data_hora_reproducao) AS total_reproducoes,
                COUNT(DISTINCT h.id_usuario) AS usuarios_unicos
            FROM artista ar
            JOIN album al ON al.id_artista = ar.id_artista
            JOIN musica m ON m.id_album = al.id_album
            LEFT JOIN historico_reproducao h ON h.id_musica = m.id_musica
            GROUP BY ar.nome
            ORDER BY total_reproducoes DESC, usuarios_unicos DESC
        """);
    }
}
