package com.playlist.music.controller;

import lombok.RequiredArgsConstructor;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import com.playlist.music.entities.Playlist;
import com.playlist.music.entities.Usuario;
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

    @PostMapping
    public Playlist salvar(@RequestBody Playlist playlist) {
        return service.salvar(playlist);
    }
    @PutMapping("/{id}")
    public Playlist atualizar(@PathVariable Integer id,
                             @RequestBody Playlist playlist) {

    	Playlist existente = service.buscarPorId(id);

        existente.setNomePlaylist(playlist.getNomePlaylist());
        existente.setDataCriacao(playlist.getDataCriacao());

        return service.salvar(existente);
    }
    

    @DeleteMapping("/{id}")
    public void deletar(@PathVariable Integer id) {
        service.deletar(id);
    }
}