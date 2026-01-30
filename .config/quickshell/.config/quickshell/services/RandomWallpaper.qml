pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

import qs.common
import qs.services
import qs.config

Singleton {
    id: root

    property string downloadDir: `${Paths.strip(Paths.downloads)}`
    property int currentSlot: 1
    readonly property string mon: "WALL-SERVICE"

    readonly property bool isLoading: whSearch.running || kcSearch.running || downloader.running

    function logStep(service, message) {
        Logger.i(mon, `[${service.toUpperCase()}] | ${message}`);
    }

    function fetchWallhaven() {
        if (isLoading)
            return;
        const conf = Config.background.wallhaven;

        let params = [];
        params.push(`categories=${conf.categories || "010"}`);
        params.push(`purity=${conf.purity || "110"}`);
        params.push(`sorting=${conf.sorting || "random"}`);
        if (conf.ratios)
            params.push(`ratios=${conf.ratios}`);
        if (conf.query)
            params.push(`q=${encodeURIComponent(conf.query)}`);
        if (conf.apiKey)
            params.push(`apikey=${conf.apiKey}`);
        params.push("atleast=2560x1440");

        const url = `https://wallhaven.cc/api/v1/search?${params.join('&')}`;

        logStep("Wallhaven", `Starting search... (Sort: ${conf.sorting}, Query: ${conf.query || 'none'})`);
        // Logger.i(mon, `URL: ${url}`);

        whSearch.command = ["curl", "-s", "-A", "Mozilla/5.0", url];
        whSearch.running = true;
    }

    function fetchKonachan() {
        if (isLoading)
            return;
        const conf = Config.background.konachan;

        let tagList = [];
        if (conf.tags)
            tagList.push(conf.tags);
        if (conf.rating)
            tagList.push(`rating:${conf.rating}`);

        const tagsArg = tagList.join(' ');
        const url = `https://konachan.net/post.json?tags=${encodeURIComponent(tagsArg)}&limit=${conf.limit || 100}`;

        logStep("Konachan", `Requesting posts with tags: [${tagsArg || 'no tags'}] (Limit: ${conf.limit})`);

        kcSearch.command = ["curl", "-s", "-L", "-A", "Mozilla/5.0", url];
        kcSearch.running = true;
    }

    Process {
        id: whSearch
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const res = JSON.parse(text);
                    if (res.data && res.data.length > 0) {
                        const idx = Math.floor(Math.random() * res.data.length);
                        const picked = res.data[idx];

                        Logger.s(root.mon, `[WALLHAVEN] | Found ${res.data.length} items. Picked ID: ${picked.id} (Index: ${idx})`);
                        _startDownload(picked.path, "wallhaven");
                    } else {
                        Logger.w(root.mon, "[WALLHAVEN] | No results found for this criteria.");
                    }
                } catch (e) {
                    Logger.e(root.mon, "[WALLHAVEN] | JSON Parse Error. Check API status.");
                }
            }
        }
    }

    Process {
        id: kcSearch
        stdout: StdioCollector {
            onStreamFinished: {
                const trimmed = text.trim();
                if (trimmed.length === 0) {
                    Logger.e(root.mon, "[KONACHAN] | Received empty response from server.");
                    return;
                }
                try {
                    const res = JSON.parse(trimmed);
                    if (Array.isArray(res) && res.length > 0) {
                        const idx = Math.floor(Math.random() * res.length);
                        const picked = res[idx];

                        Logger.s(root.mon, `[KONACHAN] | Found ${res.length} posts. Picked ID: ${picked.id}`);

                        let fileUrl = picked.file_url;
                        if (fileUrl) {
                            if (fileUrl.startsWith("//"))
                                fileUrl = "https:" + fileUrl;
                            _startDownload(fileUrl, "konachan");
                        }
                    } else {
                        Logger.w(root.mon, "[KONACHAN] | Search returned 0 results. Try simpler tags.");
                    }
                } catch (e) {
                    Logger.e(root.mon, "[KONACHAN] | JSON Error. Server might be down or blocked.");
                }
            }
        }
        onExited: code => {
            if (code !== 0)
                Logger.e(root.mon, `[KONACHAN] | Search process failed with exit code ${code}`);
        }
    }

    function _startDownload(url, prefix) {
        let ext = "jpg";
        const parts = url.split('.');
        if (parts.length > 1) {
            ext = parts.pop().split('?')[0];
        }

        const fileName = `${prefix}-${root.currentSlot}.${ext}`;
        const path = `${root.downloadDir}/${fileName}`;

        Logger.i(mon, `[DOWNLOADER] | Target: ${fileName} | Slot: ${root.currentSlot}`);
        // Logger.i(mon, `[DOWNLOADER] | Source URL: ${url}`);

        downloader.targetPath = path;
        downloader.command = ["curl", "-L", "-A", "Mozilla/5.0", url, "-o", path];
        downloader.running = true;
    }

    Process {
        id: downloader
        property string targetPath: ""
        onExited: code => {
            if (code === 0) {
                const fileName = targetPath.split('/').pop();
                Logger.s(root.mon, `[DOWNLOADER] | Finished: ${fileName}. Applying to background...`);
                Wallpapers.setWallpaper(targetPath);

                root.currentSlot = (root.currentSlot % 4) + 1;
            } else {
                Logger.e(root.mon, `[DOWNLOADER] | Curl failed with code ${code}. Check internet connection.`);
            }
        }
    }
}
