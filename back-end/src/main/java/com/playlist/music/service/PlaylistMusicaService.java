package com.playlist.music.service;

import java.time.LocalDate;
import java.util.List;

import org.springframework.stereotype.Service;

import com.playlist.music.entities.Musica;
import com.playlist.music.entities.Playlist;
import com.playlist.music.entities.PlaylistMusica;
import com.playlist.music.entities.PlaylistMusicaId;
import com.playlist.music.repository.MusicaRepository;
import com.playlist.music.repository.PlaylistMusicaRepository;
import com.playlist.music.repository.PlaylistRepository;

@Service
public class PlaylistMusicaService {

    private final PlaylistRepository playlistRepository;
    private final MusicaRepository musicaRepository;
    private final PlaylistMusicaRepository repository;

    public PlaylistMusicaService(PlaylistRepository playlistRepository,
                                 MusicaRepository musicaRepository,
                                 PlaylistMusicaRepository repository) {
        this.playlistRepository = playlistRepository;
        this.musicaRepository = musicaRepository;
        this.repository = repository;
    }

    public List<PlaylistMusica> buscarMusicasPorPlaylist(Integer playlistId) {
        return repository.findByPlaylist_IdPlaylist(playlistId);
    }

    public PlaylistMusica adicionarMusica(Integer playlistId, Integer musicaId) {

        Playlist playlist = playlistRepository.findById(playlistId)
                .orElseThrow(() -> new RuntimeException("Playlist não encontrada"));

        Musica musica = musicaRepository.findById(musicaId)
                .orElseThrow(() -> new RuntimeException("Música não encontrada"));

        PlaylistMusicaId id = new PlaylistMusicaId(playlistId, musicaId);

        PlaylistMusica playlistMusica = new PlaylistMusica();
        playlistMusica.setId(id);
        playlistMusica.setPlaylist(playlist);
        playlistMusica.setMusica(musica);
        playlistMusica.setDataAdicao(LocalDate.now());

        return repository.save(playlistMusica);
    }
}