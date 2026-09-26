// eos-launchers.js — fix icontasks launchers on first boot / after defaults
const launchers = [
    "preferred://browser",
"applications:org.kde.spectacle.desktop",
"applications:eos-log-tool.desktop",
"applications:calamares.desktop"
];
const defaultLaunchers = [
    "preferred://browser",
"applications:org.kde.discover.desktop",
"preferred://filemanager"
];

for (const containments of desktopsAndPanels()) {
    for (const widget of containments.widgets()) {
        if (widget.type !== "org.kde.plasma.icontasks") {
            continue;
        }
        const current = widget.readConfig("launchers", []).value();
        // nur anfassen, wenn leer oder Plasma-Default — nie User-Einstellungen zerstören
        const isDefault = current.length === 0 ||
        (current.length === defaultLaunchers.length &&
        current.every((v, i) => v === defaultLaunchers[i]));
        if (isDefault) {
            widget.currentConfigGroup = ["General"];
            widget.writeConfig("launchers", launchers);
            widget.reloadConfig();
        }
    }
}
