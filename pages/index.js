const TY64_URL = "https://ty64.krissz.hu/";
const status = document.querySelector("#status");
const categoryList = document.querySelector("#category-list");
const programList = document.querySelector("#program-list");
const programHeading = document.querySelector("#program-heading");
let catalog;
let selectedCategory;

function setStatus(message) {
    status.textContent = message;
}

async function sendToTy64(path, label) {
    const ty64Tab = window.open(TY64_URL, "ty64");
    if (!ty64Tab) {
        setStatus("Popup blocked. Allow popups for this page, then try again.");
        return;
    }
    setStatus(`Fetching ${label}…`);
    try {
        const response = await fetch(path);
        if (!response.ok) throw new Error(`HTTP ${response.status}`);
        const arrayOfBytes = new Uint8Array(await response.arrayBuffer());
        // Give a newly opened cross-origin tab time to register its message listener.
        await new Promise(resolve => setTimeout(resolve, 750));
        ty64Tab.postMessage(arrayOfBytes, new URL(TY64_URL).origin);
        setStatus(`Sent ${label} to TY64.`);
    } catch (error) {
        setStatus(`Could not load ${label}: ${error.message}`);
    }
}

function renderCategories() {
    categoryList.replaceChildren(...catalog.categories.map(category => {
        const button = document.createElement("button");
        button.className = "category";
        button.type = "button";
        button.setAttribute("aria-pressed", String(category.name === selectedCategory));
        const name = document.createElement("span");
        name.textContent = category.name;
        const count = document.createElement("span");
        count.textContent = category.count;
        button.append(name, count);
        button.title = category.description;
        button.addEventListener("click", () => {
            selectedCategory = category.name;
            renderCategories();
            renderPrograms();
        });
        return button;
    }));
}

function renderPrograms() {
    const programs = catalog.programs.filter(program => program.category === selectedCategory);
    programHeading.textContent = selectedCategory ? `${selectedCategory} programs` : "Programs";
    if (!programs.length) {
        const empty = document.createElement("p");
        empty.className = "empty";
        empty.textContent = "Choose a category.";
        programList.replaceChildren(empty);
        return;
    }
    programList.replaceChildren(...programs.map(program => {
        const button = document.createElement("button");
        button.className = "program";
        button.type = "button";
        const name = document.createElement("strong");
        name.textContent = program.name;
        const bytes = document.createElement("span");
        bytes.textContent = `${program.bytes} B`;
        const description = document.createElement("small");
        description.textContent = program.description;
        button.append(name, bytes, description);
        button.addEventListener("click", () => sendToTy64(program.prg, `${program.name}.PRG`));
        return button;
    }));
}

document.querySelector("#launch-disk").addEventListener("click", () => {
    sendToTy64("sector-256.d64", "sector-256.d64");
});

async function loadCatalog() {
    try {
        const response = await fetch("catalog.json");
        if (!response.ok) throw new Error(`HTTP ${response.status}`);
        catalog = await response.json();
        selectedCategory = catalog.categories[0]?.name;
        renderCategories();
        renderPrograms();
        setStatus("Choose a category, then send a standalone PRG to TY64.");
    } catch (error) {
        setStatus(`Catalog unavailable: ${error.message}`);
    }
}

loadCatalog();