// Sagui Linux — comportamento do site (sem dependências)
(function () {
  "use strict";
  var C = window.SAGUI_CONFIG || {};

  // Menu: marca a página atual
  var pagina = (location.pathname.split("/").pop() || "index.html");
  document.querySelectorAll("nav.menu a").forEach(function (a) {
    if (a.getAttribute("href") === pagina) a.setAttribute("aria-current", "page");
  });

  // Links vindos do config.js: <a data-config="canalYoutube"> / data-config="downloads.desktop.url"
  function pega(caminho) {
    return caminho.split(".").reduce(function (o, k) { return o && o[k]; }, C);
  }
  document.querySelectorAll("[data-config]").forEach(function (el) {
    var v = pega(el.getAttribute("data-config"));
    if (v) {
      el.setAttribute("href", v);
      if (/^https?:/.test(v) && !el.hasAttribute("data-mesma-aba")) { el.setAttribute("target", "_blank"); el.setAttribute("rel", "noopener"); }
    } else {
      el.setAttribute("aria-disabled", "true");
      el.removeAttribute("href");
      var txt = el.getAttribute("data-vazio");
      if (txt) el.textContent = txt;
    }
  });
  document.querySelectorAll("[data-texto]").forEach(function (el) {
    var v = pega(el.getAttribute("data-texto"));
    if (v) el.textContent = v;
  });

  // Vídeo do processo
  var caixa = document.getElementById("video-processo");
  if (caixa) {
    var id = null, u = C.videoProcesso || "";
    var m = u.match(/(?:v=|youtu\.be\/|embed\/|shorts\/|live\/)([A-Za-z0-9_-]{6,})/);
    if (m) id = m[1];
    if (id) {
      caixa.className = "video";
      caixa.innerHTML = '<iframe src="https://www.youtube-nocookie.com/embed/' + id +
        '" title="Vídeo: como o Sagui Linux foi criado" loading="lazy" allow="accelerometer; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>';
    }
  }

  // Abas simples
  document.querySelectorAll("[data-abas]").forEach(function (grupo) {
    var botoes = grupo.querySelectorAll(".abas button");
    function mostra(alvo) {
      botoes.forEach(function (b) {
        var sel = b.getAttribute("data-alvo") === alvo;
        b.setAttribute("aria-selected", sel ? "true" : "false");
        var p = document.getElementById(b.getAttribute("data-alvo"));
        if (p) p.hidden = !sel;
      });
    }
    botoes.forEach(function (b) { b.addEventListener("click", function () { mostra(b.getAttribute("data-alvo")); }); });
    if (botoes.length) mostra(botoes[0].getAttribute("data-alvo"));
  });

  // Copiar comandos
  document.querySelectorAll("pre[data-copiar]").forEach(function (pre) {
    var b = document.createElement("button");
    b.type = "button"; b.className = "btn secundario pequeno"; b.textContent = "Copiar";
    b.style.cssText = "float:right;margin:-6px -6px 0 8px;padding:4px 10px";
    b.addEventListener("click", function () {
      var t = pre.innerText.replace(/^Copiar(do!)?\s*/, "");
      if (navigator.clipboard) navigator.clipboard.writeText(t).then(function () { b.textContent = "Copiado!"; setTimeout(function () { b.textContent = "Copiar"; }, 1500); });
    });
    pre.prepend(b);
  });

  // ---------------- Página de história (dados reais em js/dados.js) ----------------
  var D = window.SAGUI_DADOS;
  if (!D) return;
  function esc(s) { return String(s == null ? "" : s).replace(/[&<>"]/g, function (c) { return { "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;" }[c]; }); }
  function hm(min) { min = Math.round(min); var h = Math.floor(min / 60), m = min % 60; return h ? h + " h " + (m < 10 ? "0" : "") + m + " min" : m + " min"; }
  function duracao(a, b) {
    var p = function (s) { return new Date(s.replace(" ", "T") + ":00"); };
    return (p(b) - p(a)) / 60000;
  }

  ["fase1", "fase2"].forEach(function (k, idx) {
    var f = D[k];
    var alvo = document.getElementById("marcos-" + k);
    if (alvo) {
      var max = Math.max.apply(null, f.marcos.map(function (m) { return m.min_build; })) || 1;
      var linhas = f.marcos.map(function (m) {
        var w = Math.round(m.min_build / max * 100);
        return "<tr><td><strong>" + esc(m.id) + "</strong></td><td>" + esc(m.nome) + "</td><td>" + m.peso +
          "</td><td>" + (m.passos || "—") + "</td><td>" + (m.min_build ? hm(m.min_build) : "—") +
          '</td><td style="min-width:110px"><div class="barra' + (idx ? " azul" : "") + '"><i style="width:' + w + '%"></i></div></td></tr>';
      }).join("");
      alvo.innerHTML = '<div class="tabela"><table><thead><tr><th>História</th><th>Marco</th><th>Peso</th><th>Passos de build</th><th>Tempo de compilação</th><th></th></tr></thead><tbody>' + linhas + "</tbody></table></div>";
    }
    var num = document.getElementById("numeros-" + k);
    if (num) {
      var total = f.marcos.reduce(function (s, m) { return s + m.min_build; }, 0);
      num.innerHTML =
        '<div class="card"><div class="numero">' + f.pacotes + '</div><div class="mut">passos de build (pacotes e etapas)</div></div>' +
        '<div class="card"><div class="numero">' + hm(total) + '</div><div class="mut">compilando (soma dos logs)</div></div>' +
        '<div class="card"><div class="numero">' + f.erros.length + '</div><div class="mut">erros encontrados e corrigidos</div></div>' +
        '<div class="card"><div class="numero">' + f.acoes + '</div><div class="mut">registros no diário</div></div>';
    }
    var longos = document.getElementById("longos-" + k);
    if (longos) {
      longos.innerHTML = f.mais_longos.slice(0, 6).map(function (p) {
        return "<li><code>" + esc(p.id.replace(/^(ch\d+|b)-/, "")) + "</code> — " + hm(p.min) + "</li>";
      }).join("");
    }
    var er = document.getElementById("erros-" + k);
    if (er) {
      er.innerHTML = f.erros.map(function (e, i) {
        return '<details class="erro"><summary>' + (i + 1) + ". " + esc(e.pacote) + " <span>(" + esc(e.marco) + ")</span></summary><dl>" +
          "<dt>Sintoma</dt><dd><code>" + esc(e.sintoma) + "</code></dd>" +
          "<dt>Causa</dt><dd>" + esc(e.causa) + "</dd>" +
          "<dt>Correção</dt><dd>" + esc(e.correcao) + "</dd></dl></details>";
      }).join("");
    }
    var per = document.getElementById("periodo-" + k);
    if (per) per.textContent = f.inicio + " → " + f.fim + " (" + hm(duracao(f.inicio, f.fim)) + " corridos, incluindo o teste em hardware)";
    document.querySelectorAll('[data-sha="' + k + '"]').forEach(function (el) { el.textContent = f.sha256; });
  });
})();
