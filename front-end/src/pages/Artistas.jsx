import { useEffect, useState } from "react";
import api from "../services/api";

export default function Artistas() {
  const [artistas, setArtistas] = useState([]);
  const [nome, setNome] = useState("");
  const [idEdicao, setIdEdicao] = useState(null);

  useEffect(() => {
    listar();
  }, []);

  function listar() {
    api.get("/artistas").then(res => setArtistas(res.data));
  }

  function salvar() {
    const payload = { nome };
    const requisicao = idEdicao
      ? api.put(`/artistas/${idEdicao}`, payload)
      : api.post("/artistas", payload);

    requisicao.then(() => {
      limparFormulario();
      listar();
    });
  }

  function excluir(id) {
    api.delete(`/artistas/${id}`).then(listar);
  }

  function editar(artista) {
    setIdEdicao(artista.idArtista);
    setNome(artista.nome || "");
  }

  function limparFormulario() {
    setNome("");
    setIdEdicao(null);
  }

  return (
    <div>
      <h1>Artistas</h1>

      <input
        placeholder="Nome do artista"
        value={nome}
        onChange={e => setNome(e.target.value)}
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
          {artistas.map(a => (
            
            <tr key={a.idArtista}>
              <td>{a.idArtista}</td>
              <td>{a.nome}</td>
              <td>
                <button onClick={() => editar(a)}>Editar</button>
                <button onClick={() => excluir(a.idArtista)}>Excluir</button>
              </td>
            </tr>

          ))}
        </tbody>
      </table>
    </div>
  );
}