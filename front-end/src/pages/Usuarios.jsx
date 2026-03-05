import { useEffect, useState } from "react";
import api from "../services/api";

export default function Usuarios() {
  const [usuarios, setUsuarios] = useState([]);
  const [nome, setNome] = useState("");
  const [email, setEmail] = useState("");
  const [senha, setSenha] = useState("");
  const [idEdicao, setIdEdicao] = useState(null);

  useEffect(() => {
    listar();
  }, []);

  function listar() {
    api.get("/usuarios").then(res => setUsuarios(res.data));
  }

  function salvar() {
    const payload = { nome, email, senha };
    const requisicao = idEdicao
      ? api.put(`/usuarios/${idEdicao}`, payload)
      : api.post("/usuarios", payload);

    requisicao.then(() => {
      limparFormulario();
      listar();
    });
  }

  function excluir(id) {
    api.delete(`/usuarios/${id}`).then(listar);
  }

  function editar(usuario) {
    setIdEdicao(usuario.idUsuario);
    setNome(usuario.nome || "");
    setEmail(usuario.email || "");
    setSenha(usuario.senha || "");
  }

  function limparFormulario() {
    setNome("");
    setEmail("");
    setSenha("");
    setIdEdicao(null);
  }

  return (
    <div>
      <h1>Usuários</h1>

      <input
        placeholder="Nome"
        value={nome}
        onChange={e => setNome(e.target.value)}
      />

      <input
        placeholder="Email"
        value={email}
        onChange={e => setEmail(e.target.value)}
      />

      <input
        placeholder="Senha"
        value={senha}
        onChange={e => setSenha(e.target.value)}
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
          {usuarios.map(u => (
            <tr key={u.idUsuario}>
              <td>{u.idUsuario}</td>
              <td>{u.nome}</td>
              <td>
                <button onClick={() => editar(u)}>Editar</button>
                <button onClick={() => excluir(u.idUsuario)}>Excluir</button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}