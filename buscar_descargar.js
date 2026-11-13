const https = require('https');
const fs = require('fs');

const plantsToSearch = [
  { name: 'oreganon', query: 'Plectranthus amboinicus plant' },
  { name: 'vaporub', query: 'Plectranthus neochilus' },
  { name: 'maguey_morado', query: 'Tradescantia spathacea plant' },
  { name: 'albahaca', query: 'Ocimum basilicum plant' },
  { name: 'malamadre', query: 'Kalanchoe daigremontiana' }
];

function fetchJson(url) {
  return new Promise((resolve, reject) => {
    https.get(url, { headers: { 'User-Agent': 'SchoolHerbBot/1.0 (contact@escuela.edu)' } }, res => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        try { resolve(JSON.parse(data)); } catch (e) { reject(e); }
      });
    }).on('error', reject);
  });
}

function downloadFile(url, dest) {
  return new Promise((resolve, reject) => {
    const file = fs.createWriteStream(dest);
    https.get(url, { headers: { 'User-Agent': 'SchoolHerbBot/1.0 (contact@escuela.edu)' } }, res => {
      if (res.statusCode >= 300 && res.statusCode < 400 && res.headers.location) {
        return downloadFile(res.headers.location, dest).then(resolve).catch(reject);
      }
      res.pipe(file);
      file.on('finish', () => file.close(resolve));
    }).on('error', reject);
  });
}

async function searchAndDownload() {
  for (const item of plantsToSearch) {
    try {
      console.log(`Buscando imagen para ${item.name}...`);
      const searchUrl = `https://commons.wikimedia.org/w/api.php?action=query&list=search&srsearch=${encodeURIComponent(item.query)}&srnamespace=6&format=json`;
      const searchRes = await fetchJson(searchUrl);
      const firstResult = searchRes.query.search[0];
      if (!firstResult) throw new Error('No se encontraron resultados');
      
      const fileTitle = firstResult.title;
      console.log(`Encontrado: ${fileTitle}`);
      
      const infoUrl = `https://commons.wikimedia.org/w/api.php?action=query&titles=${encodeURIComponent(fileTitle)}&prop=imageinfo&iiprop=url&format=json`;
      const infoRes = await fetchJson(infoUrl);
      const pages = infoRes.query.pages;
      const pageId = Object.keys(pages)[0];
      const imgUrl = pages[pageId].imageinfo[0].url;
      
      console.log(`Descargando ${item.name} desde ${imgUrl}...`);
      await downloadFile(imgUrl, `d:/Proyectos/Plantas/foto_${item.name}.jpg`);
      console.log(`Descargado foto_${item.name}.jpg con éxito!`);
    } catch (e) {
      console.error(`Error con ${item.name}:`, e.message);
    }
  }
}

searchAndDownload();
