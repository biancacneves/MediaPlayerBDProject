import { BrowserRouter, Routes, Route } from "react-router-dom";
import Layout from "./components/Layout";
import Usuarios from "./pages/Usuarios";
import Artistas from "./pages/Artistas";
import Albuns from "./pages/Albuns";
import Musicas from "./pages/Musicas";
import Playlists from "./pages/Playlists";
import Relatorios from "./pages/Relatorios";

export default function App() {
  return (
    <BrowserRouter>
      <Layout>
        <Routes>
          <Route path="/" element={<Usuarios />} />
          <Route path="/usuarios" element={<Usuarios />} />
          <Route path="/artistas" element={<Artistas />} />
          <Route path="/albuns" element={<Albuns />} />
          <Route path="/musicas" element={<Musicas />} />
          <Route path="/playlists" element={<Playlists />} />
          <Route path="/relatorios" element={<Relatorios />} />
        </Routes>
      </Layout>
    </BrowserRouter>
  );
}