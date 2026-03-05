package com.playlist.music.controller;

import lombok.RequiredArgsConstructor;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import com.playlist.music.entities.Playlist;
import com.playlist.music.service.PlaylistService;

@RestController
@RequestMapping("/playlists")
@RequiredArgsConstructor
public class PlaylistController {

    @Autowired
    private PlaylistService service;

    @GetMapping
    public List<Playlist> listar() {
        return service.listar();
    }

    @GetMapping("/{id}")
    public Playlist buscar(@PathVariable Integer id) {
        return service.buscarPorId(id);
    }

    @PostMapping
    public Playlist salvar(@RequestBody Playlist playlist) {
        return service.salvar(playlist);
    }
    @PutMapping("/{id}")
    public Playlist atualizar(@PathVariable Integer id,
                             @RequestBody Playlist playlist) {

    	Playlist existente = service.buscarPorId(id);

        if (playlist.getNomePlaylist() != null) {
            existente.setNomePlaylist(playlist.getNomePlaylist());
        }
        if (playlist.getDataCriacao() != null) {
            existente.setDataCriacao(playlist.getDataCriacao());
        }
        if (playlist.getUsuario() != null) {
            existente.setUsuario(playlist.getUsuario());
        }

        return service.salvar(existente);
    }
    

    @DeleteMapping("/{id}")
    public void deletar(@PathVariable Integer id) {
        service.deletar(id);
    }
}