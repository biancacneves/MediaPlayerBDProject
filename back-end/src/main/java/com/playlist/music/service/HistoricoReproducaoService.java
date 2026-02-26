package com.playlist.music.service;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.stereotype.Service;

import com.playlist.music.entities.HistoricoReproducao;
import com.playlist.music.entities.HistoricoReproducaoId;
import com.playlist.music.entities.Musica;
import com.playlist.music.entities.Usuario;
import com.playlist.music.repository.HistoricoReproducaoRepository;
import com.playlist.music.repository.MusicaRepository;
import com.playlist.music.repository.UsuarioRepository;

@Service
public class HistoricoReproducaoService {

    private final UsuarioRepository usuarioRepository;
    private final MusicaRepository musicaRepository;
    private final HistoricoReproducaoRepository repository;

    public HistoricoReproducaoService(UsuarioRepository usuarioRepository,
                                      MusicaRepository musicaRepository,
                                      HistoricoReproducaoRepository repository) {
        this.usuarioRepository = usuarioRepository;
        this.musicaRepository = musicaRepository;
        this.repository = repository;
    }

    public List<HistoricoReproducao> listarPorUsuario(Integer usuarioId) {
        return repository.findByUsuario_IdUsuario(usuarioId);
    }

    public HistoricoReproducao registrar(Integer usuarioId, Integer musicaId) {

        Usuario usuario = usuarioRepository.findById(usuarioId)
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado"));

        Musica musica = musicaRepository.findById(musicaId)
                .orElseThrow(() -> new RuntimeException("Música não encontrada"));

        LocalDateTime agora = LocalDateTime.now();

        HistoricoReproducaoId id =
                new HistoricoReproducaoId(usuarioId, musicaId, agora);

        HistoricoReproducao historico = new HistoricoReproducao();
        historico.setId(id);
        historico.setUsuario(usuario);
        historico.setMusica(musica);

        return repository.save(historico);
    }
}