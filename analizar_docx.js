const fs = require('fs');
const xml = fs.readFileSync('d:/Proyectos/Plantas/docx_extracted/word/document.xml', 'utf8');

// Tamaño de página
const pgSz = xml.match(/<w:pgSz[^>]*\/>/);
console.log('Page Size:', pgSz ? pgSz[0] : 'not found');

const pgMar = xml.match(/<w:pgMar[^>]*\/>/);
console.log('Page Margins:', pgMar ? pgMar[0] : 'not found');

// Fuentes usadas
const fontMatches = xml.match(/w:ascii="([^"]+)"/g) || [];
const fonts = fontMatches.map(m => m.split('"')[1]);
console.log('Fuentes únicas:', [...new Set(fonts)]);

// Colores de sombreado (fondos de celdas)
const fillMatches = xml.match(/w:fill="([^"]+)"/g) || [];
const fills = fillMatches.map(m => m.split('"')[1]);
console.log('Fondos (fills):', [...new Set(fills)]);

// Colores de texto
const colorMatches = xml.match(/w:color\s+w:val="([^"]+)"/g) || [];
const colors = colorMatches.map(m => m.split('"')[1]);
console.log('Colores de texto:', [...new Set(colors)]);

// Tamaños de fuente (w:sz val="...")
const szMatches = xml.match(/w:sz\s+w:val="([^"]+)"/g) || [];
const sizes = szMatches.map(m => m.split('"')[1]);
console.log('Tamaños de fuente (en medios puntos):', [...new Set(sizes)]);
