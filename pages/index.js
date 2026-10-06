const TY64_URL = "https://ty64.krissz.hu/";
const TY64_READY_DELAY_MS = 3000;
const STORAGE_D64_URL = "https://lewismoten.github.io/storage-d64/";
const STORAGE_D64_READY_TIMEOUT_MS = 10000;
const toast = document.querySelector("#status");
const categoryList = document.querySelector("#category-list");
const programList = document.querySelector("#program-list");
const programHeading = document.querySelector("#program-heading");
const inspectDiskButton = document.querySelector("#inspect-disk");
let catalog;
let selectedCategory;

function setStatus(message) {
    toast.textContent = message;
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
        // TY64 registers its cross-origin PRG listener during startup.
        await new Promise(resolve => setTimeout(resolve, TY64_READY_DELAY_MS));
        ty64Tab.postMessage(arrayOfBytes, new URL(TY64_URL).origin);
        setStatus(`Sent ${label} to TY64. Switch to the emulator tab to play.`);
    } catch (error) {
        setStatus(`Could not load ${label}: ${error.message}`);
    }
}

async function inspectDisk() {
    const requestId = crypto.randomUUID();
    const storageOrigin = new URL(STORAGE_D64_URL).origin;
    let storageTab;
    inspectDiskButton.disabled = true;
    setStatus("Opening disk inspector…");
    try {
        await new Promise((resolve, reject) => {
            const timeout = window.setTimeout(() => {
                window.removeEventListener("message", onMessage);
                reject(new Error("The disk inspector did not become ready."));
            }, STORAGE_D64_READY_TIMEOUT_MS);
            const onMessage = event => {
                if (event.source !== storageTab || event.origin !== storageOrigin) return;
                if (event.data?.type !== "storage-d64:ready") return;
                if (event.data.receiveRequestId !== requestId) return;
                window.clearTimeout(timeout);
                window.removeEventListener("message", onMessage);
                resolve();
            };
            window.addEventListener("message", onMessage);
            storageTab = window.open(
                `${STORAGE_D64_URL}#receive=${encodeURIComponent(requestId)}`,
                "storage-d64",
            );
            if (!storageTab) {
                window.clearTimeout(timeout);
                window.removeEventListener("message", onMessage);
                reject(new Error("Popup blocked. Allow popups for this page, then try again."));
            }
        });
        setStatus("Sending sector-256.d64 to the disk inspector…");
        const response = await fetch("sector-256.d64");
        if (!response.ok) throw new Error(`HTTP ${response.status}`);
        const bytes = new Uint8Array(await response.arrayBuffer());
        storageTab.postMessage(
            { type: "storage-d64:load", sourceName: "sector-256.d64", bytes },
            storageOrigin,
        );
        setStatus("Sent sector-256.d64 to the disk inspector. Switch to that tab to inspect it.");
    } catch (error) {
        setStatus(`Could not open the disk inspector: ${error.message}`);
    } finally {
        inspectDiskButton.disabled = false;
    }
}

const isSelectedCategory = (category) => category.name === selectedCategory;
const isInSelectedCategory = (program) => program.category === selectedCategory;

function renderCategories() {
    categoryList.replaceChildren(...catalog.categories.map(category => {
        const button = document.createElement("button");
        button.className = "category";
        button.type = "button";
        button.setAttribute("aria-pressed", String(isSelectedCategory(category)));
        const name = document.createElement("span");
        name.textContent = category.name;
        const count = document.createElement("span");
        count.textContent = category.count;
        button.append(name, count);
        button.title = category.description;
        button.addEventListener("click", () => selectCategory(category));
        return button;
    }));
}

const selectCategory = category => {
    selectedCategory = category.name;
    renderCategories();
    renderPrograms();
}

function renderPrograms() {
    const programs = catalog.programs.filter(isInSelectedCategory);
    programHeading.textContent = selectedCategory ? `${selectedCategory} programs` : "Programs";
    if (!programs.length) {
        const empty = document.createElement("p");
        empty.className = "empty";
        empty.textContent = "Choose a category.";
        programList.replaceChildren(empty);
        return;
    }
    programList.replaceChildren(...programs.map(program => {
        const card = document.createElement("article");
        card.className = "program";
        const name = document.createElement("strong");
        name.textContent = program.name;
        const bytes = document.createElement("span");
        bytes.textContent = `${program.bytes} B`;
        const description = document.createElement("small");
        description.textContent = program.description;
        const actions = document.createElement("div");
        actions.className = "program-actions";
        const run = document.createElement("button");
        run.type = "button";
        run.textContent = "Run in TY64";
        run.addEventListener("click", () => sendProgram(program));
        const download = document.createElement("a");
        download.className = "button secondary";
        download.href = program.prg;
        download.download = `${program.name}.PRG`;
        download.textContent = "Download PRG";
        actions.append(run, download);
        card.append(name, bytes, description, actions);
        return card;
    }));
}
const sendProgram = (program) => {
    sendToTy64(program.prg, `${program.name}.PRG`)
}
async function loadCatalog() {
    try {
        const response = await fetch("catalog.json");
        if (!response.ok) throw new Error(`HTTP ${response.status}`);
        catalog = await response.json();
        selectedCategory = catalog.categories[0]?.name;
        renderCategories();
        renderPrograms();
        setStatus("Choose a category, then run or download a standalone PRG.");
    } catch (error) {
        setStatus(`Catalog unavailable: ${error.message}`);
    }
}

loadCatalog();
inspectDiskButton.addEventListener("click", inspectDisk);