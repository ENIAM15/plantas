const https = require('https');
const fs = require('fs');

const plants = [
  { name: 'belladona', file: 'File:Atropa_bella-donna0.jpg' },
  { name: 'oreganon', file: 'File:Plectranthus_amboinicus_02.JPG' },
  { name: 'vaporub', file: 'File:Plectranthus_neochilus_-_Jardín_Botánico_Canario_Viera_y_Clavijo_01.jpg' },
  { name: 'maguey_morado', file: 'File:Tradescantia_spathacea_kz1.jpg' },
  { name: 'albahaca', file: 'File:Ocimum_basilicum_leaves.jpg' },
  { name: 'malamadre', file: 'File:Kalanchoe_daigremontiana_1.JPG' }
];

async function getImageUrl(fileName) {
  const url = `https://commons.wikimedia.org/w/api.php?action=query&titles=${encodeURIComponent(fileName)}&prop=imageinfo&iiprop=url&format=json`;
  return new Promise((resolve, reject) => {
    https.get(url, { headers: { 'User-Agent': 'SchoolHerbBot/1.0 (contact@escuela.edu)' } }, res => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        try {
          const json = JSON.parse(data);
          const pages = json.query.pages;
          const pageId = Object.keys(pages)[0];
          const imgUrl = pages[pageId].imageinfo[0].url;
          resolve(imgUrl);
        } catch (e) {
          reject(e);
        }
      });
    }).on('error', reject);
  });
}

async function download(url, dest) {
  return new Promise((resolve, reject) => {
    const file = fs.createWriteStream(dest);
    https.get(url, { headers: { 'User-Agent': 'SchoolHerbBot/1.0 (contact@escuela.edu)' } }, res => {
      if (res.statusCode >= 300 && res.statusCode < 400 && res.headers.location) {
        return download(res.headers.location, dest).then(resolve).catch(reject);
      }
      res.pipe(file);
      file.on('finish', () => file.close(resolve));
    }).on('error', reject);
  });
}

async function main() {
  for (const p of plants) {
    try {
      console.log(`Buscando URL para ${p.name}...`);
      const directUrl = await getImageUrl(p.file);
      console.log(`Descargando ${p.name} desde ${directUrl}...`);
      await download(directUrl, `d:/Proyectos/Plantas/foto_${p.name}.jpg`);
      console.log(`Descargado ${p.name}`);
    } catch (e) {
      console.error(`Error con ${p.name}:`, e.message);
    }
  }
}

main();
