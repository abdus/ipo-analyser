// Theme switcher: follow the system, or pin light or dark. The choice is saved per browser,
// and an inline script in <head> applies it before first paint.
(() => {
  const group = document.querySelector("[data-theme-switch]");
  if (!group) return;
  const root = document.documentElement;
  const buttons = Array.from(group.querySelectorAll("[data-theme-choice]"));

  const read = () => {
    try {
      const saved = localStorage.getItem("theme");
      return saved === "light" || saved === "dark" ? saved : "system";
    } catch {
      return "system";
    }
  };

  const apply = (choice) => {
    if (choice === "system") delete root.dataset.theme;
    else root.dataset.theme = choice;
    buttons.forEach((button) => {
      button.setAttribute("aria-pressed", String(button.dataset.themeChoice === choice));
    });
  };

  group.addEventListener("click", (event) => {
    const button = event.target.closest("[data-theme-choice]");
    if (!button) return;
    const choice = button.dataset.themeChoice;
    try {
      if (choice === "system") localStorage.removeItem("theme");
      else localStorage.setItem("theme", choice);
    } catch {
      // Storage can be unavailable (private mode); the choice still applies to this page.
    }
    apply(choice);
  });

  // Keep tabs in step when the theme is changed in another one.
  window.addEventListener("storage", (event) => {
    if (event.key === "theme") apply(read());
  });

  apply(read());
  group.hidden = false;
})();
