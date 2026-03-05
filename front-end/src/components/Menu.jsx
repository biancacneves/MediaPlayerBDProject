import { Link } from "react-router-dom";

export default function Menu() {
  return (
    <div style={{
      width: 220,
      background: "#1f2937",
      color: "#fff",
      minHeight: "100vh",
      padding: 20
    }}>
      <h2>🎵 MediaPlayer</h2>

      <nav style={{ display: "flex", flexDirection: "column", gap: 10 }}>
        <Link to="/usuarios" style={link}>Usuários</Link>
        <Link to="/artistas" style={link}>Artistas</Link>
        <Link to="/albuns" style={link}>Álbuns</Link>
        <Link to="/musicas" style={link}>Músicas</Link>
        <Link to="/playlists" style={link}>Playlists</Link>
        <Link to="/relatorios" style={link}>📊 Relatórios</Link>
      </nav>
    </div>
  );
}

const link = {
  color: "#fff",
  textDecoration: "none",
  fontSize: 16
};