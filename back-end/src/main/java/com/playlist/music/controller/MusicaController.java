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

import com.playlist.music.entities.Musica;
import com.playlist.music.service.MusicaService;

@RestController
@RequestMapping("/musicas")
public class MusicaController {

    private final MusicaService service;

    public MusicaController(MusicaService service) {
        this.service = service;
    }

    @GetMapping
    public List<Musica> listar() {
        return service.listar();
    }

    @PostMapping
    public Musica salvar(@RequestBody Musica musica) {
        return service.salvar(musica);
    }
    
    @PutMapping("/{id}")
    public Musica atualizar(@PathVariable Integer id,
		            @RequestBody Musica musica) {
		
		Musica existente = service.buscarPorId(id);
		
		existente.setTitulo(musica.getTitulo());
		existente.setDuracao(musica.getDuracao());
		existente.setUrlMusica(musica.getUrlMusica());
		existente.setAlbum(musica.getAlbum());
        
		return service.salvar(existente);
		}

    @DeleteMapping("/{id}")
    public void deletar(@PathVariable Integer id) {
        service.deletar(id);
    }
}