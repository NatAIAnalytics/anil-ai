// ============================================================
// Elementos del chat principal
// ============================================================
const messagesEl = document.getElementById("messages");
const form = document.getElementById("chat-form");
const input = document.getElementById("message-input");
const sendBtn = document.getElementById("send-btn");
const resetBtn = document.getElementById("reset-btn");

const ICONO_AGENTE = `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 3v18h18"/><path d="M7 16l4-6 4 3 5-8"/></svg>`;
const ICONO_USUARIO = `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="8" r="4"/><path d="M4 20c0-4 4-6 8-6s8 2 8 6"/></svg>`;

function agregarMensaje(texto, tipo) {
  const div = document.createElement("div");
  div.className = `message ${tipo}`;

  const avatar = document.createElement("div");
  avatar.className = "avatar";
  avatar.innerHTML = tipo === "user" ? ICONO_USUARIO : ICONO_AGENTE;

  const contentWrap = document.createElement("div");
  contentWrap.className = "message-content";

  const label = document.createElement("div");
  label.className = "message-label";
  label.textContent = tipo === "user" ? "tú" : "anil";

  const body = document.createElement("div");
  body.className = "message-body";
  if (tipo.startsWith("agent") && typeof marked !== "undefined") {
    body.innerHTML = marked.parse(texto);
  } else {
    body.textContent = texto;
  }

  contentWrap.appendChild(label);
  contentWrap.appendChild(body);
  div.appendChild(avatar);
  div.appendChild(contentWrap);
  messagesEl.appendChild(div);
  messagesEl.scrollTop = messagesEl.scrollHeight;
  return div;
}

let contadorGraficasChat = 0;

function agregarGraficaEnChat(grafica) {
  contadorGraficasChat++;
  const canvasId = `chart-chat-${contadorGraficasChat}`;

  const div = document.createElement("div");
  div.className = "message agent";

  const avatar = document.createElement("div");
  avatar.className = "avatar";
  avatar.innerHTML = ICONO_AGENTE;

  const contentWrap = document.createElement("div");
  contentWrap.className = "message-content";

  const box = document.createElement("div");
  box.className = "chart-message-box";
  box.innerHTML = `<p class="chart-title">${grafica.titulo}</p><canvas id="${canvasId}"></canvas>`;

  contentWrap.appendChild(box);
  div.appendChild(avatar);
  div.appendChild(contentWrap);
  messagesEl.appendChild(div);
  messagesEl.scrollTop = messagesEl.scrollHeight;

  const colores = ["#8B5CF6", "#7C3AED", "#C9871E", "#CDB0F2"];
  new Chart(document.getElementById(canvasId), {
    type: grafica.tipo_grafico,
    data: {
      labels: grafica.labels,
      datasets: grafica.series.map((s, i) => ({
        label: s.nombre,
        data: s.valores,
        backgroundColor: grafica.tipo_grafico === "doughnut" ? colores : colores[i % colores.length],
      })),
    },
    options: { responsive: true, plugins: { legend: { position: "bottom" } } },
  });
}

async function enviarMensaje(texto) {
  agregarMensaje(texto, "user");
  input.value = "";
  sendBtn.disabled = true;

  const loadingDiv = agregarMensaje("Pensando...", "agent loading");

  try {
    const res = await fetch("/api/chat", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ message: texto }),
    });
    const data = await res.json();
    loadingDiv.remove();

    if (data.error) {
      agregarMensaje("Ocurrió un error: " + data.error, "agent");
    } else {
      const esAnomalia = /anomal[íi]a|variaci[oó]n (fuerte|importante|significativa)|discrepancia/i.test(data.reply);
      agregarMensaje(data.reply, esAnomalia ? "agent anomaly" : "agent");
      if (data.grafica) agregarGraficaEnChat(data.grafica);
      reproducirTono();
    }
  } catch (err) {
    loadingDiv.remove();
    agregarMensaje("No se pudo conectar con el servidor.", "agent");
  } finally {
    sendBtn.disabled = false;
    input.focus();
  }
}

form.addEventListener("submit", (e) => {
  e.preventDefault();
  const texto = input.value.trim();
  if (texto) enviarMensaje(texto);
});

document.querySelectorAll(".suggestion").forEach((btn) => {
  btn.addEventListener("click", () => enviarMensaje(btn.dataset.q));
});

resetBtn.addEventListener("click", async () => {
  await fetch("/api/reset", { method: "POST" });
  messagesEl.innerHTML = "";
  agregarMensaje("¡Conversación reiniciada! ¿Qué te gustaría revisar hoy? 😊", "agent");
});

// Mensaje de bienvenida al cargar la página
agregarMensaje(
  "¡Hola! Soy Anil, el agente inteligente de Nuvora. Puedo ayudarte a revisar nómina, presupuesto, cuentas por pagar, conciliación bancaria y ventas — solo pregúntame como si le hablaras a un colega. ¿Por dónde empezamos? 😊",
  "agent"
);

// ============================================================
// Sonido de notificación (se activa/desactiva desde Configuración)
// ============================================================
function sonidoActivado() {
  return localStorage.getItem("nuvora_sonido") !== "off";
}

function reproducirTono() {
  if (!sonidoActivado()) return;
  try {
    const ctx = new (window.AudioContext || window.webkitAudioContext)();
    const osc = ctx.createOscillator();
    const gain = ctx.createGain();
    osc.type = "sine";
    osc.frequency.value = 660;
    gain.gain.setValueAtTime(0.08, ctx.currentTime);
    gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.25);
    osc.connect(gain).connect(ctx.destination);
    osc.start();
    osc.stop(ctx.currentTime + 0.25);
  } catch (err) {
    /* silencioso si el navegador bloquea audio automático */
  }
}

// ============================================================
// Panel deslizante (drawer): Resumen / Gráficas / Acerca de / Configuración
// ============================================================
const iconBtns = document.querySelectorAll(".icon-btn");
const drawer = document.getElementById("drawer");
const drawerTitle = document.getElementById("drawer-title");
const drawerClose = document.getElementById("drawer-close");
const drawerPanels = document.querySelectorAll(".drawer-panel");

const TITULOS = {
  resumen: "Resumen",
  graficas: "Gráficas",
  acerca: "Acerca de",
  config: "Configuración",
};

let resumenCargado = false;
let graficasCargadas = false;

function abrirDrawer(vista) {
  drawerTitle.textContent = TITULOS[vista];
  drawerPanels.forEach((p) => p.classList.remove("active"));
  document.getElementById(`drawer-${vista}`).classList.add("active");
  drawer.classList.add("open");

  if (vista === "resumen" && !resumenCargado) cargarResumen();
  if (vista === "graficas" && !graficasCargadas) cargarGraficas();
  if (vista === "config") cargarConfig();
}

function cerrarDrawer() {
  drawer.classList.remove("open");
}

iconBtns.forEach((btn) => {
  btn.addEventListener("click", () => {
    iconBtns.forEach((b) => b.classList.remove("active"));
    btn.classList.add("active");

    const vista = btn.dataset.view;
    if (vista === "inicio") {
      cerrarDrawer();
    } else {
      abrirDrawer(vista);
    }
  });
});

drawerClose.addEventListener("click", () => {
  cerrarDrawer();
  iconBtns.forEach((b) => b.classList.remove("active"));
  document.querySelector('.icon-btn[data-view="inicio"]').classList.add("active");
});

function formatoMoneda(numero) {
  return "$" + Math.round(numero).toLocaleString("es-CO") + " COP";
}

async function cargarResumen() {
  const contenedor = document.getElementById("resumen-kpis");
  try {
    const res = await fetch("/api/resumen");
    const data = await res.json();
    contenedor.innerHTML = `
      <div class="kpi-card"><div class="kpi-label">Costo total de nómina</div><div class="kpi-value">${formatoMoneda(data.total_nomina)}</div></div>
      <div class="kpi-card"><div class="kpi-label">Ventas totales</div><div class="kpi-value">${formatoMoneda(data.total_ventas)}</div></div>
      <div class="kpi-card"><div class="kpi-label">Facturas pendientes</div><div class="kpi-value">${data.num_facturas_pendientes}</div></div>
      <div class="kpi-card"><div class="kpi-label">Monto pendiente por pagar</div><div class="kpi-value">${formatoMoneda(data.monto_facturas_pendientes)}</div></div>
    `;
    resumenCargado = true;
  } catch (err) {
    contenedor.innerHTML = "No se pudo cargar el resumen. Revisa la terminal de Python para ver el error.";
  }
}

async function cargarConfig() {
  const contenedor = document.getElementById("config-info");
  contenedor.innerHTML = "Cargando...";
  try {
    const res = await fetch("/api/estado");
    const data = await res.json();
    contenedor.innerHTML = `
      <div class="kpi-card">
        <div class="kpi-label">Modelo de IA activo</div>
        <div class="kpi-value" style="font-size:16px">${data.modelo}</div>
      </div>
      <div class="kpi-card" style="margin-top:12px">
        <div class="kpi-label">Clave de API</div>
        <div class="kpi-value" style="font-size:16px">${data.api_key_configurada ? "✅ Configurada" : "❌ Falta configurar .env"}</div>
      </div>
      <div class="kpi-card" style="margin-top:12px; display:flex; align-items:center; justify-content:space-between;">
        <div>
          <div class="kpi-label">Sonido de notificación</div>
          <div style="font-size:13px; color:var(--text-dim)">Suena cuando Anil responde</div>
        </div>
        <label class="switch">
          <input type="checkbox" id="toggle-sonido" ${sonidoActivado() ? "checked" : ""}>
          <span class="switch-slider"></span>
        </label>
      </div>
    `;
    document.getElementById("toggle-sonido").addEventListener("change", (e) => {
      localStorage.setItem("nuvora_sonido", e.target.checked ? "on" : "off");
      if (e.target.checked) reproducirTono();
    });
  } catch (err) {
    contenedor.innerHTML = "No se pudo consultar el estado. Revisa la terminal de Python para ver el error.";
  }
}

// ============================================================
// Gráficas del dashboard (panel "Gráficas") + modal para ampliar
// ============================================================
const graficasConfig = {};
let instanciaModal = null;
const chartModal = document.getElementById("chart-modal");
const chartModalTitle = document.getElementById("chart-modal-title");
const chartModalClose = document.getElementById("chart-modal-close");

function crearGrafica(canvasId, config) {
  graficasConfig[canvasId] = config;
  new Chart(document.getElementById(canvasId), config);

  const caja = document.getElementById(canvasId).closest(".chart-box");
  caja.addEventListener("click", () => abrirModalGrafica(canvasId));
}

function abrirModalGrafica(canvasId) {
  const config = graficasConfig[canvasId];
  if (!config) return;

  const caja = document.getElementById(canvasId).closest(".chart-box");
  const titulo = caja.querySelector(".chart-title").textContent;
  chartModalTitle.textContent = titulo;
  chartModal.classList.add("open");

  if (instanciaModal) instanciaModal.destroy();
  const ctxModal = document.getElementById("chart-modal-canvas");
  instanciaModal = new Chart(ctxModal, {
    type: config.type,
    data: config.data,
    options: { ...config.options, maintainAspectRatio: true },
  });
}

chartModalClose.addEventListener("click", () => {
  chartModal.classList.remove("open");
});

chartModal.addEventListener("click", (e) => {
  if (e.target === chartModal) {
    chartModal.classList.remove("open");
  }
});

async function cargarGraficas() {
  try {
    const res = await fetch("/api/graficas");
    const data = await res.json();

    const colorAccent = "#8B5CF6";
    const colorAccentStrong = "#7C3AED";
    const colorWarn = "#C9871E";

    crearGrafica("chart-presupuesto", {
      type: "bar",
      data: {
        labels: data.presupuesto_por_mes.meses,
        datasets: [
          { label: "Presupuestado", data: data.presupuesto_por_mes.presupuestado, backgroundColor: colorAccent },
          { label: "Real", data: data.presupuesto_por_mes.real, backgroundColor: colorAccentStrong },
        ],
      },
      options: { responsive: true, plugins: { legend: { position: "bottom" } } },
    });

    crearGrafica("chart-nomina", {
      type: "bar",
      data: {
        labels: data.nomina_por_area.areas,
        datasets: [{ label: "Costo total", data: data.nomina_por_area.montos, backgroundColor: colorAccent }],
      },
      options: { responsive: true, plugins: { legend: { display: false } } },
    });

    crearGrafica("chart-ventas", {
      type: "bar",
      data: {
        labels: data.ventas_por_categoria.categorias,
        datasets: [{ label: "Ventas", data: data.ventas_por_categoria.montos, backgroundColor: colorAccentStrong }],
      },
      options: { responsive: true, plugins: { legend: { display: false } }, indexAxis: "y" },
    });

    crearGrafica("chart-cxp", {
      type: "doughnut",
      data: {
        labels: data.cuentas_por_estado.estados,
        datasets: [{ data: data.cuentas_por_estado.montos, backgroundColor: [colorWarn, colorAccent] }],
      },
      options: { responsive: true, plugins: { legend: { position: "bottom" } } },
    });

    graficasCargadas = true;
  } catch (err) {
    console.log("Error cargando gráficas:", err);
  }
}

// ============================================================
// Comando de voz (reconocimiento de voz del navegador)
// ============================================================
const micBtn = document.getElementById("mic-btn");
const SpeechRecognitionAPI = window.SpeechRecognition || window.webkitSpeechRecognition;
let reconocimiento = null;
let escuchando = false;

if (micBtn && SpeechRecognitionAPI) {
  reconocimiento = new SpeechRecognitionAPI();
  reconocimiento.lang = "es-ES";
  reconocimiento.continuous = false;
  reconocimiento.interimResults = false;

  reconocimiento.addEventListener("start", () => {
    escuchando = true;
    micBtn.classList.add("listening");
    micBtn.textContent = "⏺️";
  });

  reconocimiento.addEventListener("end", () => {
    escuchando = false;
    micBtn.classList.remove("listening");
    micBtn.textContent = "🎤";
  });

  reconocimiento.addEventListener("result", (e) => {
    const texto = e.results[0][0].transcript.trim();
    if (texto) {
      enviarMensaje(texto);
    } else {
      agregarMensaje("No alcancé a escucharte bien. Intenta de nuevo.", "agent");
    }
  });

  reconocimiento.addEventListener("error", (e) => {
    escuchando = false;
    micBtn.classList.remove("listening");
    micBtn.textContent = "🎤";
    agregarMensaje("Problema con el micrófono: " + e.error, "agent");
  });

  micBtn.addEventListener("click", () => {
    try {
      if (escuchando) {
        reconocimiento.stop();
      } else {
        reconocimiento.start();
      }
    } catch (err) {
      console.log("Excepción de micrófono:", err);
    }
  });
} else if (micBtn) {
  micBtn.disabled = true;
  micBtn.title = "Tu navegador no soporta comandos de voz (usa Chrome o Edge)";
}

