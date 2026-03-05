import { useEffect, useState } from "react";
import api from "../services/api";

export default function Playlists() {
  const [playlists, setPlaylists] = useState([]);
  const [nomePlaylist, setNomePlaylist] = useState("");
  const [usuarioId, setUsuarioId] = useState("");
  const [idEdicao, setIdEdicao] = useState(null);

  useEffect(() => {
    listar();
  }, []);

  function listar() {
    api.get("/playlists").then(res => setPlaylists(res.data));
  }

  function salvar() {
    const payload = {
      nomePlaylist,
      usuario: { idUsuario: Number(usuarioId) }
    };

    const requisicao = idEdicao
      ? api.put(`/playlists/${idEdicao}`, payload)
      : api.post("/playlists", payload);

    requisicao.then(() => {
      limparFormulario();
      listar();
    });
  }

  function excluir(id) {
    api.delete(`/playlists/${id}`).then(listar);
  }

  function editar(playlist) {
    setIdEdicao(playlist.idPlaylist);
    setNomePlaylist(playlist.nomePlaylist || "");
    setUsuarioId(playlist.usuario?.idUsuario ?? "");
  }

  function limparFormulario() {
    setNomePlaylist("");
    setUsuarioId("");
    setIdEdicao(null);
  }

  return (
    <div>
      <h1>Playlists</h1>

      <input
        placeholder="Nome da playlist"
        value={nomePlaylist}
        onChange={e => setNomePlaylist(e.target.value)}
      />

      <input
        placeholder="ID do usuário"
        value={usuarioId}
        onChange={e => setUsuarioId(e.target.value)}
      />

      <button onClick={salvar}>{idEdicao ? "Atualizar" : "Salvar"}</button>
      {idEdicao && <button onClick={limparFormulario}>Cancelar</button>}

      <table border="1" width="100%" style={{ marginTop: 20 }}>
        <thead>
          <tr>
            <th>ID</th>
            <th>Nome</th>
            <th>Ações</th>
          </tr>
        </thead>
        <tbody>
          {playlists.map(p => (
            <tr key={p.idPlaylist}>
              <td>{p.idPlaylist}</td>
              <td>{p.nomePlaylist}</td>
              <td>
                <button onClick={() => editar(p)}>Editar</button>
                <button onClick={() => excluir(p.idPlaylist)}>Excluir</button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}