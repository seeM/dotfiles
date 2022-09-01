#!/usr/bin/osascript -l JavaScript

const DEBUG = false;

const app = Application.currentApplication();
app.includeStandardAdditions = true;

function getPwd(base) {
    var pwd = app.doShellScript("pwd");
    if (pwd.startsWith(base)) pwd = pwd.slice(base.length);
    return pwd
}

function getJupyter() {
    const res = app.doShellScript("jupyter notebook list --jsonlist", {alteringLineEndings: false});
    return JSON.parse(res)[0];
}

function getTab(url) {
    chrome = Application("com.google.Chrome");
    for (const win of chrome.windows()) {
        if (DEBUG) console.log("Window: " + win.name());
        const tabs = win.tabs();
        for (let i = 0; i < tabs.length; i++) {
            const tab = tabs[i];
            if (DEBUG) console.log("Tab: url: " + tab.url() + " index: " + i);
            if (tab.url() === url) return {window: win, index: i+1}
        }
    }
}

function switchTab(tab) {
    tab.window.activeTabIndex = tab.index;
    tab.window.index = 1;
    app.doShellScript("open -a Google\\ Chrome");
}

function openOrSwitchTab(url) {
    const tab = getTab(url);
    if (tab == null) {
        if (DEBUG) console.log("Tab not found, opening a new tab");
        app.doShellScript(`open ${url}`);
    } else {
        if (DEBUG) console.log("Tab found, switching to it");
        switchTab(tab);
    }
}

function run(argv) {
    const jupyter = getJupyter()
    if (DEBUG) console.log(jupyter.url, jupyter.notebook_dir);
    const pwd = getPwd(jupyter.notebook_dir);

    if (argv.length === 0) {
        if (DEBUG) console.log("No args");
        const url = jupyter.url + "tree" + pwd;
        openOrSwitchTab(url);
    } else {
        const fname = argv[0];
        if (DEBUG) console.log("Args: fname: " + fname);
        const url = jupyter.url + "notebooks" + pwd + "/" + fname;
        if (DEBUG) console.log("Url: " + url);
        openOrSwitchTab(url);
    }
}
