const fs = require('fs');
const xml = fs.readFileSync('d:/Proyectos/Plantas/docx_extracted/word/document.xml', 'utf8');

// Ver P35 y P36
console.log('--- BUSCANDO MAGUEY VERDE EN XML ---');
const idxMaguey = xml.indexOf('MAGUEY VERDE');
console.log(xml.substring(idxMaguey - 200, idxMaguey + 400));

console.log('--- BUSCANDO SABER TRADICIONAL EN XML ---');
const idxSaber = xml.indexOf('SABER TRADICIONAL');
console.log(xml.substring(idxSaber - 100, idxSaber + 1200));
