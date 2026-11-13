const fs = require('fs');
const xml = fs.readFileSync('d:/Proyectos/Plantas/docx_extracted/word/document.xml', 'utf8');

const extents = xml.match(/<wp:extent[^>]*\/>/g) || [];
console.log('Dimensiones de imágenes (wp:extent en EMUs):', extents);
// 1 pulgada = 914400 EMUs
extents.forEach(ext => {
  const cx = parseInt(ext.match(/cx="(\d+)"/)[1]);
  const cy = parseInt(ext.match(/cy="(\d+)"/)[1]);
  console.log(`- ${cx / 914400} in x ${cy / 914400} in (${(cx / 914400 * 25.4).toFixed(1)} mm x ${(cy / 914400 * 25.4).toFixed(1)} mm)`);
});
