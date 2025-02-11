const path = require('node:path');
const fs = require('fs');
const tgFilePath = path.join(__dirname, '../build/prod/netlify/tg/index.html');
const vkFilePath = path.join(__dirname, '../build/prod/netlify/vk/index.html');

function updateFile(filePath) {
    fs.readFile(filePath, { encoding: 'utf8' }, function (err, data) {
        let lineToReplace = undefined;
        let currentVersion = undefined;
        let nextVersion = undefined;

        const lines = data.split('\n');

        lines.forEach((line, index) => {
            if (line.includes('https://storage.yandexcloud.net/seidh-static-and-assets/scripts/bundle.min.js?version=')) {
                currentVersion = Number(line.split('version=')[1].split('"')[0]);
                nextVersion = currentVersion + 1;
                lineToReplace = line;
            }
        });

        if (lineToReplace && currentVersion && nextVersion) {
            const formatted = data.replace(lineToReplace, lineToReplace.replace(currentVersion, nextVersion));

            fs.writeFile(filePath, formatted, 'utf8', function (err) {
                if (err) return console.error(err);
            });
        }
    });
}

updateFile(tgFilePath);
updateFile(vkFilePath);