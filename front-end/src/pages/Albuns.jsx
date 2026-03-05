import { useEffect, useState } from "react";
import api from "../services/api";

export default function Albuns() {
  const [albuns, setAlbuns] = useState([]);
  const [titulo, setTitulo] = useState("");
  const [anoLancamento, setAnoLancamento] = useState("");
  const [genero, setGenero] = useState("");
  const [artistaId, setArtistaId] = useState("");
  const [idEdicao, setIdEdicao] = useState(null);

  useEffect(() => {
    listar();
  }, []);

  function listar() {
    api.get("/albuns").then(res => setAlbuns(res.data));
  }

  function salvar() {
    const payload = {
      titulo,
      anoLancamento: Number(anoLancamento),
      genero,
      artista: { idArtista: Number(artistaId) }
    };

    const requisicao = idEdicao
      ? api.put(`/albuns/${idEdicao}`, payload)
      : api.post("/albuns", payload);

    requisicao.then(() => {
      limparFormulario();
      listar();
    });
  }

  function excluir(id) {
    api.delete(`/albuns/${id}`).then(listar);
  }

  function editar(album) {
    setIdEdicao(album.idAlbum);
    setTitulo(album.titulo || "");
    setAnoLancamento(album.anoLancamento ?? "");
    setGenero(album.genero || "");
    setArtistaId(album.artista?.idArtista ?? "");
  }

  function limparFormulario() {
    setTitulo("");
    setAnoLancamento("");
    setGenero("");
    setArtistaId("");
    setIdEdicao(null);
  }

  return (
    <div>
      <h1>Álbuns</h1>

      <input
        placeholder="Título do álbum"
        value={titulo}
        onChange={e => setTitulo(e.target.value)}
      />

      <input
        placeholder="Ano de lançamento"
        value={anoLancamento}
        onChange={e => setAnoLancamento(e.target.value)}
      />

      <input
        placeholder="Gênero"
        value={genero}
        onChange={e => setGenero(e.target.value)}
      />

      <input
        placeholder="ID do artista"
        value={artistaId}
        onChange={e => setArtistaId(e.target.value)}
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
          {albuns.map(a => (
            <tr key={a.idAlbum}>
              <td>{a.idAlbum}</td>
              <td>{a.titulo}</td>
              <td>
                <button onClick={() => editar(a)}>Editar</button>
                <button onClick={() => excluir(a.idAlbum)}>Excluir</button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}