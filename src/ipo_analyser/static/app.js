// Client-side filtering, search and sorting for the static dashboard.
// Mirrors ipo_analyser.rendering.dashboard_context; keep the two in step.
(() => {
  const table = document.querySelector("[data-ipo-table]");
  if (!table) return;

  const tbody = table.tBodies[0];
  const rows = Array.from(tbody.rows).sort((a, b) => a.dataset.order - b.dataset.order);
  const filterLinks = Array.from(document.querySelectorAll(".filters a[data-status]"));
  // Sort links live in the table header (wide screens) and above the cards (phones).
  const sortLinks = Array.from(document.querySelectorAll("a[data-sort]"));
  const empty = document.querySelector("[data-no-match]");
  const form = document.querySelector(".table-search");
  const search = form.querySelector('input[name="q"]');
  const statuses = new Set(filterLinks.map((link) => link.dataset.status));

  const number = (key) => (row) => (row.dataset[key] === "" ? null : Number(row.dataset[key]));
  const text = (key) => (row) => row.dataset[key] || null;
  const statusRank = { open: 2, upcoming: 1 };
  const sorters = {
    actionable: (row) => [statusRank[row.dataset.status] || 0, Number(row.dataset.score)],
    name: (row) => row.dataset.name.toLowerCase(),
    score: number("score"),
    gmp: number("gmp"),
    gain: number("gain"),
    qib: number("qib"),
    open_date: text("openDate"),
  };

  const compare = (a, b) => {
    if (Array.isArray(a)) {
      for (let i = 0; i < a.length; i += 1) {
        const result = compare(a[i], b[i]);
        if (result) return result;
      }
      return 0;
    }
    return a < b ? -1 : a > b ? 1 : 0;
  };

  const readState = (search = window.location.search) => {
    const params = new URLSearchParams(search);
    const status = params.get("status") || "all";
    const sort = params.get("sort") || "actionable";
    return {
      status: statuses.has(status) ? status : "all",
      sort: sort in sorters ? sort : "actionable",
      direction: params.get("direction") === "asc" ? "asc" : "desc",
      q: params.get("q") || "",
    };
  };

  const query = (state) => {
    const params = new URLSearchParams({
      status: state.status,
      sort: state.sort,
      direction: state.direction,
    });
    if (state.q) params.set("q", state.q);
    return `?${params}`;
  };

  const render = (state) => {
    const needle = state.q.trim().toLowerCase();
    const visible = rows.filter(
      (row) =>
        (state.status === "all" || row.dataset.status === state.status) &&
        (!needle || row.dataset.name.toLowerCase().includes(needle)),
    );
    const key = sorters[state.sort];
    const sign = state.direction === "desc" ? -1 : 1;
    const populated = visible.filter((row) => key(row) !== null);
    const missing = visible.filter((row) => key(row) === null);
    populated.sort((a, b) => sign * compare(key(a), key(b)));

    const shown = new Set(visible);
    rows.forEach((row) => {
      row.hidden = !shown.has(row);
    });
    tbody.append(...populated, ...missing, ...rows.filter((row) => !shown.has(row)));

    table.hidden = !visible.length;
    if (empty) empty.hidden = Boolean(visible.length);

    filterLinks.forEach((link) => {
      link.classList.toggle("active", link.dataset.status === state.status);
      link.href = query({ ...state, status: link.dataset.status, q: "" });
    });
    sortLinks.forEach((link) => {
      const active = link.dataset.sort === state.sort;
      const next = active && state.direction === "desc" ? "asc" : "desc";
      link.href = query({ ...state, sort: link.dataset.sort, direction: next });
      link.textContent = link.dataset.label;
      if (active) {
        const arrow = document.createElement("span");
        arrow.textContent = state.direction === "desc" ? "↓" : "↑";
        link.append(arrow);
      }
    });
    form.querySelector('input[name="status"]').value = state.status;
    form.querySelector('input[name="sort"]').value = state.sort;
    form.querySelector('input[name="direction"]').value = state.direction;
    search.value = state.q;
  };

  const go = (state) => {
    window.history.pushState(null, "", query(state));
    render(state);
  };

  document.addEventListener("click", (event) => {
    const link = event.target.closest(".filters a[data-status], a[data-sort]");
    if (!link || event.metaKey || event.ctrlKey || event.shiftKey) return;
    event.preventDefault();
    go(readState(new URL(link.href).search));
  });

  form.addEventListener("submit", (event) => {
    event.preventDefault();
    go(readState(`?${new URLSearchParams(new FormData(form))}`));
  });

  window.addEventListener("popstate", () => render(readState()));
  render(readState());
})();
