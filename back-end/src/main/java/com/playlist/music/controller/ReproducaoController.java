package com.playlist.music.controller;
import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.playlist.music.entities.HistoricoReproducao;
import com.playlist.music.service.HistoricoReproducaoService;

@RestController
@RequestMapping("/historico")
public class ReproducaoController {

    private final HistoricoReproducaoService service;

    public ReproducaoController(HistoricoReproducaoService service) {
        this.service = service;
    }

    @GetMapping("/{usuarioId}")
    public List<HistoricoReproducao> listarHistorico(@PathVariable Integer usuarioId) {
        return service.listarPorUsuario(usuarioId);
    }

    @PostMapping("/{usuarioId}/reproduzir/{musicaId}")
    public HistoricoReproducao reproduzir(
            @PathVariable Integer usuarioId,
            @PathVariable Integer musicaId) {

        return service.registrar(usuarioId, musicaId);
    }
}