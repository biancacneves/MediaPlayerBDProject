package com.playlist.music.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.List;
import com.playlist.music.entities.Usuario;
import com.playlist.music.repository.MusicaRepository;
import com.playlist.music.repository.UsuarioRepository;

@Service
@RequiredArgsConstructor
public class UsuarioService {

    private final UsuarioRepository repository;

    public List<Usuario> listar() {
        return repository.findAll();
    }

    public Usuario salvar(Usuario usuario) {
        return repository.save(usuario);
    }
    public Usuario buscarPorId(Integer id) {
        return repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado"));
    }

    public void deletar(Integer id) {
        repository.deleteById(id);
    }
}