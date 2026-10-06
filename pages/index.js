const TY64_URL = "https://ty64.krissz.hu/";
const TY64_READY_DELAY_MS = 3000;
const STORAGE_D64_URL = "https://lewismoten.github.io/storage-d64/";
const STORAGE_D64_READY_TIMEOUT_MS = 10000;
const toast = document.querySelector("#status");
const categoryList = document.querySelector("#category-list");
const programList = document.querySelector("#program-list");
const programHeading = document.querySelector("#program-heading");
const inspectDiskButton = document.querySelector("#inspect-disk");
const programInfo = document.querySelector("#program-info");
const programScreenshot = document.querySelector("#program-screenshot");
const selectedProgramName = document.querySelector("#selected-program-name");
const selectedProgramDescription = document.querySelector("#selected-program-description");
const selectedProgramBytes = document.querySelector("#selected-program-bytes");
const selectedProgramSource = document.querySelector("#selected-program-source");
const selectedProgramActions = document.querySelector("#selected-program-actions");
const programReadme = document.querySelector("#program-readme");
let catalog;
let selectedCategory;
let selectedProgram;

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
            storageTab = window.open(`${STORAGE_D64_URL}#receive=${encodeURIComponent(requestId)}`, "storage-d64");
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
        storageTab.postMessage({ type: "storage-d64:load", sourceName: "sector-256.d64", bytes }, storageOrigin);
        setStatus("Sent sector-256.d64 to the disk inspector. Switch to that tab to inspect it.");
    } catch (error) {
        setStatus(`Could not open the disk inspector: ${error.message}`);
    } finally {
        inspectDiskButton.disabled = false;
    }
}

const isSelectedCategory = category => category.name === selectedCategory;
const isInSelectedCategory = program => program.category === selectedCategory;
const isSelectedProgram = program => selectedProgram && program.name === selectedProgram.name && program.category === selectedProgram.category;

function makeProgramActions(program) {
    const actions = document.createElement("div");
    actions.className = "program-actions";
    const run = document.createElement("button");
    run.type = "button";
    run.textContent = "Run in TY64";
    run.addEventListener("click", () => sendToTy64(program.prg, `${program.name}.PRG`));
    const download = document.createElement("a");
    download.className = "button secondary";
    download.href = program.prg;
    download.download = `${program.name}.PRG`;
    download.textContent = "Download PRG";
    actions.append(run, download);
    return actions;
}

function renderSelectedProgram() {
    if (!selectedProgram) {
        programInfo.hidden = true;
        return;
    }
    programInfo.hidden = false;
    programScreenshot.src = selectedProgram.screenshot;
    programScreenshot.alt = `${selectedProgram.name} screenshot`;
    selectedProgramName.textContent = selectedProgram.name;
    selectedProgramDescription.textContent = selectedProgram.description;
    selectedProgramBytes.textContent = `${selectedProgram.bytes} B in the D64 · ${selectedProgram.prgBytes} B standalone PRG`;
    selectedProgramSource.href = selectedProgram.source;
    selectedProgramActions.replaceChildren(makeProgramActions(selectedProgram));
    programReadme.src = selectedProgram.readme;
}

function renderCategories() {
    categoryList.replaceChildren(...catalog.categories.map(category => {
        const button = document.createElement("button");
        button.className = "category";
        button.type = "button";
        button.setAttribute("aria-pressed", String(isSelectedCategory(category)));
        const icon = document.createElement("img");
        icon.className = "category-icon";
        icon.src = category.icon;
        icon.alt = "";
        const name = document.createElement("span");
        name.textContent = category.name;
        const count = document.createElement("span");
        count.className = "category-count";
        count.textContent = category.count;
        button.append(icon, name, count);
        button.title = category.description;
        button.addEventListener("click", () => selectCategory(category));
        return button;
    }));
}

function selectCategory(category) {
    selectedCategory = category.name;
    selectedProgram = catalog.programs.find(isInSelectedCategory);
    renderCategories();
    renderPrograms();
    renderSelectedProgram();
}

function selectProgram(program) {
    selectedProgram = program;
    renderPrograms();
    renderSelectedProgram();
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
        const button = document.createElement("button");
        button.className = "program";
        button.type = "button";
        button.setAttribute("aria-pressed", String(isSelectedProgram(program)));
        const icon = document.createElement("img");
        icon.className = "program-icon";
        icon.src = program.icon;
        icon.alt = "";
        const name = document.createElement("strong");
        name.textContent = program.name;
        const description = document.createElement("small");
        description.className = "program-description";
        description.textContent = program.description;
        button.append(icon, name, description);
        button.addEventListener("click", () => selectProgram(program));
        return button;
    }));
}

async function loadCatalog() {
    try {
        const response = await fetch("catalog.json");
        if (!response.ok) throw new Error(`HTTP ${response.status}`);
        catalog = await response.json();
        selectCategory(catalog.categories[0]);
        setStatus("Choose a program to view its screenshot, README, and run/download controls.");
    } catch (error) {
        setStatus(`Catalog unavailable: ${error.message}`);
    }
}

loadCatalog();
inspectDiskButton.addEventListener("click", inspectDisk);
