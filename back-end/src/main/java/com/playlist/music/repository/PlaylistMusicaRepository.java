package com.playlist.music.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.playlist.music.entities.PlaylistMusica;
import com.playlist.music.entities.PlaylistMusicaId;

public interface PlaylistMusicaRepository
        extends JpaRepository<PlaylistMusica, PlaylistMusicaId> {

    List<PlaylistMusica> findByPlaylist_IdPlaylist(Integer idPlaylist);
}
