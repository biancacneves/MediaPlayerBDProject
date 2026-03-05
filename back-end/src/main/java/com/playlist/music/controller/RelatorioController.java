package com.playlist.music.controller;

import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.playlist.music.service.RelatorioService;

@RestController
@RequestMapping("/relatorios")
public class RelatorioController {

    private final RelatorioService service;

    public RelatorioController(RelatorioService service) {
        this.service = service;
    }

    @GetMapping("/usuarios-dia")
    public List<Map<String, Object>> usuariosDia() {
        return service.relatorioUsuariosDia();
    }

    @GetMapping("/playlists")
    public List<Map<String, Object>> playlists() {
        return service.relatorioPlaylists();
    }

    @GetMapping("/ranking-artistas")
    public List<Map<String, Object>> rankingArtistas() {
        return service.relatorioRankingArtistas();
    }
}
