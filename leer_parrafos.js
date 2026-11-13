const fs = require('fs');
const xml = fs.readFileSync('d:/Proyectos/Plantas/docx_extracted/word/document.xml', 'utf8');

// Extraer todos los w:p (párrafos) con su texto y estilo
const pRegex = /<w:p\b[^>]*>(.*?)<\/w:p>/gs;
let match;
let pIndex = 0;
while ((match = pRegex.exec(xml)) !== null) {
  pIndex++;
  const pContent = match[1];
  const texts = [...pContent.matchAll(/<w:t\b[^>]*>([^<]*)<\/w:t>/g)].map(m => m[1]);
  if (texts.length > 0) {
    console.log(`P${pIndex}:`, texts.join(''));
  }
}
