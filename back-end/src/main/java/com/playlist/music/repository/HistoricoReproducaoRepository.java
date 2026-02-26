package com.playlist.music.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.playlist.music.entities.HistoricoReproducao;
import com.playlist.music.entities.HistoricoReproducaoId;

public interface HistoricoReproducaoRepository
        extends JpaRepository<HistoricoReproducao, HistoricoReproducaoId> {

        List<HistoricoReproducao> findByUsuario_IdUsuario(Integer idUsuario);
}