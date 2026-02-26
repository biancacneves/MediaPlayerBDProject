package com.playlist.music.controller;

import java.util.List;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.playlist.music.entities.Album;
import com.playlist.music.service.AlbumService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/albuns")
@RequiredArgsConstructor
public class AlbumController {

    private final AlbumService service;

    @GetMapping
    public List<Album> listar() {
        return service.listar();
    }

    @PostMapping
    public Album salvar(@RequestBody Album album) {
        return service.salvar(album);
    }
    @PutMapping("/{id}")
    public Album atualizar(@PathVariable Integer id,
		            @RequestBody Album album) {
		
		Album existente = service.buscarPorId(id);
		
		existente.setTitulo(album.getTitulo());
		existente.setAnoLancamento(album.getAnoLancamento());
		existente.setGenero(album.getGenero());
		existente.setArtista(album.getArtista());
        
		return service.salvar(existente);
		}
    @DeleteMapping("/{id}")
    public void deletar(@PathVariable Integer id) {
        service.deletar(id);
    }
}