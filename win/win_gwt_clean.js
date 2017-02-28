const fs = require('fs');
const TMP_FOLDER = `C:\\Users\\${process.env.USERNAME}\\AppData\\Local\\Temp`;

fs.readdirSync(TMP_FOLDER).forEach(tmpFile => {
    if (tmpFile.indexOf('gwt') === 0) {
        let fileName = TMP_FOLDER + `\\${tmpFile}`;
        console.log(`Removing ${fileName}...`);
        deleteRecursively(fileName);
        console.log(`Removed ${fileName}`);
    }
});

function isDirectory(path) {
    return fs.statSync(path).isDirectory();
}

function deleteRecursively(path) {
    if (fs.existsSync(path)) {
        if (isDirectory(path)) {
            fs.readdirSync(path).forEach(function (file) {
                var currentPath = path + '\\' + file;
                if (isDirectory(currentPath)) {
                    deleteRecursively(currentPath);
                } else {
                    removeFile(currentPath);
                }
            });
            fs.rmdirSync(path);
        } else {
            removeFile(path);
        }

    }
};

function removeFile(path) {
    fs.unlinkSync(path);
}