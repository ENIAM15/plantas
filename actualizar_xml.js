const fs = require('fs');

const xmlPath = 'd:/Proyectos/Plantas/docx_extracted/word/document.xml';
let xml = fs.readFileSync(xmlPath, 'utf8');

// 1. Reemplazar nombre de planta: MAGUEY VERDE -> EPAZOTE
xml = xml.replace('<w:t>MAGUEY VERDE</w:t>', '<w:t>EPAZOTE</w:t>');

// 2. Reemplazar nombre científico: Agave spp. -> Dysphania ambrosioides
xml = xml.replace('Agave spp.', 'Dysphania ambrosioides');

// 3. Reemplazar nombre del remedio: Cataplasma desinflamante -> Infusión digestiva y antiparasitaria
xml = xml.replace('<w:t>Cataplasma desinflamante</w:t>', '<w:t>Infusión digestiva y antiflatulenta</w:t>');

// 4. Reemplazar subtítulo: Uso tópico tradicional -> Uso oral tradicional
xml = xml.replace('<w:t>Uso tópico tradicional</w:t>', '<w:t>Uso oral tradicional</w:t>');

// 5. Reemplazar párrafo descriptivo
const descVieja = 'En la medicina tradicional se menciona el uso de la penca del maguey, preparada y aplicada externamente, para aliviar golpes, torceduras o molestias articulares leves.';
const descNueva = 'En la medicina tradicional se menciona el uso de las hojas de epazote, preparadas en infusión suave, para aliviar cólicos estomacales, indigestión, gases y ayudar a combatir parásitos intestinales.';
xml = xml.replace(descVieja, descNueva);

// 6. Reemplazar pasos de preparación
xml = xml.replace('<w:t>1. Ablandar:</w:t>', '<w:t>1. Cosechar:</w:t>');
xml = xml.replace('Calentar un trozo de penca en un comal hasta que se suavice y oscurezca.', 'Cortar de 3 a 5 hojas frescas del huerto y lavarlas bien con agua limpia.');

xml = xml.replace('<w:t>2. Abrir:</w:t>', '<w:t>2. Hervir:</w:t>');
xml = xml.replace('Con guantes, partirla para exponer la pulpa interior.', 'Poner a calentar una taza de agua potable y retirar al primer hervor.');

xml = xml.replace('<w:t>3. Aplicar:</w:t>', '<w:t>3. Reposar:</w:t>');
xml = xml.replace('Colocar la parte carnosa tibia sobre la zona afectada y sujetar con una venda limpia.', 'Agregar las hojas, tapar de 3 a 5 minutos, colar y beber tibio con moderación.');

// 7. Reemplazar advertencia de precaución
const precVieja1 = 'La savia cruda puede irritar piel y ojos. Usa guantes y protección al manipularla. ';
const precVieja2 = 'No aplicar sobre heridas';
const precNueva = 'Contiene ascaridol. No consumir en exceso ni de forma prolongada. Contraindicado en mujeres embarazadas, en lactancia y en niños pequeños.';

if (xml.includes(precVieja1)) {
  xml = xml.replace(precVieja1, precNueva);
  xml = xml.replace(precVieja2, '');
} else {
  console.log('Advertencia: precVieja1 no encontrada exactamente, buscando alternativas...');
}

fs.writeFileSync(xmlPath, xml, 'utf8');
console.log('document.xml actualizado exitosamente con los datos de Epazote');
