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

import com.playlist.music.entities.Usuario;
import com.playlist.music.service.UsuarioService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/usuarios")
@RequiredArgsConstructor
public class UsuarioController {
    
    private final UsuarioService service;
    
    @GetMapping
    public List<Usuario> listar() {
        return service.listar();
    }

    @PostMapping
    public Usuario salvar(@RequestBody Usuario usuario) {
        return service.salvar(usuario);
    }
    @PutMapping("/{id}")
    public Usuario atualizar(@PathVariable Integer id,
                             @RequestBody Usuario usuario) {

        Usuario existente = service.buscarPorId(id);

        existente.setNome(usuario.getNome());
        existente.setEmail(usuario.getEmail());
        existente.setSenha(usuario.getSenha());

        return service.salvar(existente);
    }

    @DeleteMapping("/{id}")
    public void deletar(@PathVariable Integer id) {
        service.deletar(id);
    }
}