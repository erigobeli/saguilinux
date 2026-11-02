// ============================================================================
//  CONFIGURAÇÃO DO SITE — este é o único arquivo que você precisa editar.
//  Depois de subir as ISOs (ex.: GitHub Releases) e publicar o vídeo,
//  cole os links abaixo. Deixe "" (vazio) enquanto não tiver o link:
//  o botão aparece como "em breve".
// ============================================================================
window.SAGUI_CONFIG = {
  autor: "Eli Rigobeli",
  canalYoutube: "https://www.youtube.com/@EliRigobeliAI",

  // Vídeo do processo de criação (link normal do YouTube, ex.: https://www.youtube.com/watch?v=XXXX)
  videoProcesso: "",

  // Repositório do projeto (scripts, documentação), ex.: https://github.com/usuario/sagui-linux
  repositorio: "https://github.com/erigobeli/saguilinux",

  // Página com todas as versões, notas e o código-fonte de cada ISO
  releases: "https://github.com/erigobeli/saguilinux/releases",

  downloads: {
    // Sagui Linux 2.0 — desktop XFCE
    desktop: {
      url: "https://github.com/erigobeli/saguilinux/releases/download/v2.0/sagui-linux-2.0-x86_64.iso",
      sha256Url: "https://github.com/erigobeli/saguilinux/releases/download/v2.0/sagui-linux-2.0-x86_64.iso.sha256"
    },
    // Edição de terminal 1.0 (nome provisório "Semente Linux")
    terminal: {
      url: "https://github.com/erigobeli/saguilinux/releases/download/v1.0/semente-linux-1.0-x86_64.iso",
      sha256Url: "https://github.com/erigobeli/saguilinux/releases/download/v1.0/semente-linux-1.0-x86_64.iso.sha256"
    }
  }
};
