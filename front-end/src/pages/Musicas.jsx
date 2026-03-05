import { useEffect, useState } from "react";
import api from "../services/api";

export default function Musicas() {
  const [musicas, setMusicas] = useState([]);
  const [titulo, setTitulo] = useState("");
  const [duracao, setDuracao] = useState("");
  const [urlMusica, setUrlMusica] = useState("");
  const [albumId, setAlbumId] = useState("");
  const [idEdicao, setIdEdicao] = useState(null);

  useEffect(() => {
    listar();
  }, []);

  function listar() {
    api.get("/musicas").then(res => setMusicas(res.data));
  }

  function salvar() {
    const payload = {
      titulo,
      duracao: Number(duracao),
      urlMusica,
      album: { idAlbum: Number(albumId) }
    };

    const requisicao = idEdicao
      ? api.put(`/musicas/${idEdicao}`, payload)
      : api.post("/musicas", payload);

    requisicao.then(() => {
      limparFormulario();
      listar();
    });
  }

  function excluir(id) {
    api.delete(`/musicas/${id}`).then(listar);
  }

  function editar(musica) {
    setIdEdicao(musica.idMusica);
    setTitulo(musica.titulo || "");
    setDuracao(musica.duracao ?? "");
    setUrlMusica(musica.urlMusica || "");
    setAlbumId(musica.album?.idAlbum ?? "");
  }

  function limparFormulario() {
    setTitulo("");
    setDuracao("");
    setUrlMusica("");
    setAlbumId("");
    setIdEdicao(null);
  }

  return (
    <div>
      <h1>Músicas</h1>

      <input
        placeholder="Título da música"
        value={titulo}
        onChange={e => setTitulo(e.target.value)}
      />

      <input
        placeholder="Duração (segundos)"
        value={duracao}
        onChange={e => setDuracao(e.target.value)}
      />

      <input
        placeholder="URL da música"
        value={urlMusica}
        onChange={e => setUrlMusica(e.target.value)}
      />

      <input
        placeholder="ID do álbum"
        value={albumId}
        onChange={e => setAlbumId(e.target.value)}
      />

      <button onClick={salvar}>{idEdicao ? "Atualizar" : "Salvar"}</button>
      {idEdicao && <button onClick={limparFormulario}>Cancelar</button>}

      <table border="1" width="100%" style={{ marginTop: 20 }}>
        <thead>
          <tr>
            <th>ID</th>
            <th>Título</th>
            <th>Ações</th>
          </tr>
        </thead>
        <tbody>
          {musicas.map(m => (
            <tr key={m.idMusica}>
              <td>{m.idMusica}</td>
              <td>{m.titulo}</td>
              <td>
                <button onClick={() => editar(m)}>Editar</button>
                <button onClick={() => excluir(m.idMusica)}>Excluir</button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}