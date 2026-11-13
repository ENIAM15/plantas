# Propuesta de Diseño: Fichas en Tabloide para Huerto Escolar Medicinal
**Proyecto:** *Del huerto a la red: medicina que se cultiva*  
**Evento:** Muestra Demostrativa Escolar  
**Formato de Impresión:** Tabloide / Doble Carta (11 × 17 pulgadas / 279.4 mm × 431.8 mm)

---

## 1. Justificación del Cambio de Diseño y Estructura

El documento original presentaba toda la información en un formato compacto tipo documento de texto (carta), con tablas y textos densos que dificultan la lectura a distancia para los visitantes de una feria o stand escolar. 

Para esta nueva propuesta orientada a impresionar a los visitantes y a las autoridades escolares, se implementó una **estrategia en 2 hojas complementarias**:

```
+-------------------------------------------------------------+
| HOJA 1: PÓSTER DE EXHIBICIÓN EN STAND (Impacto al Visitante) |
| • Título de proyecto con identidad gráfica botánica         |
| • Nombre común y científico de la planta (gran visibilidad) |
| • Fotografía botánica de alta resolución                    |
| • 4 Indicadores visuales clave (Riego, Sol, Suelo, Uso)     |
| • SECCIÓN DESTACADA: Remedio Tradicional de impacto         |
| • CÓDIGO QR ENORME Y LLAMATIVO: "Escanea con tu celular"   |
+-------------------------------------------------------------+
                               │
            (Al escanear el QR o girar la hoja)
                               ▼
+-------------------------------------------------------------+
| HOJA 2: FICHA TÉCNICA Y GUÍA COMPLETA (Digital o Físico)    |
| • 1. Descripción botánica y morfología detallada            |
| • 2. Dónde y cómo plantarlo (Guía de cultivo paso a paso)   |
| • 3. Principios activos y usos terapéuticos sustentados     |
| • 4. Ventajas ecológicas y comunitarias (Tabla interactiva) |
| • 5. Protocolo de seguridad y manejo responsable escolar    |
| • 6. Propósito pedagógico del huerto demostrativo           |
+-------------------------------------------------------------+
```

---

## 2. Archivos Creados en este Proyecto

| Archivo | Descripción |
| :--- | :--- |
| **`ficha_huerto_maguey_verde.html`** | **Propuesta terminada y lista para mostrar** de la primera planta (*Maguey Verde*). Contiene ambas hojas diseñadas con tipografía profesional, colores de alta gama e ilustraciones. |
| **`plantilla_ficha_huerto.html`** | **Plantilla maestra reutilizable** con comentarios y marcadores claros `[CAMPO]` para duplicar y crear fácilmente las fichas de las siguientes plantas (Romero, Lavanda, Ruda, Sábila, etc.). |
| **`GUIA_PRESENTACION_PROPUESTA.md`** | Este documento explicativo con argumentos para la reunión con tu jefe. |

---

## 3. Puntos Fuertes para Presentar a tu Jefe

1. **Jerarquía Visual Inmediata (Regla de los 3 segundos):**
   - El visitante del stand sabe al instante qué planta está viendo, para qué sirve y qué remedio tradicional ofrece.
2. **Interactividad Tecnológica (Del Huerto a la Red):**
   - El código QR no es un simple detalle en una esquina; es el protagonista que conecta el espacio físico de la escuela con la era digital, cumpliendo fielmente el lema del proyecto.
3. **Pensado Especialmente para Formato Tabloide:**
   - La tipografía, los pesos visuales y los contrastes están dimensionados para verse espectaculares impresos en 11 × 17 pulgadas.
4. **Seguridad y Responsabilidad Educativa:**
   - Se incluye un apartado riguroso de bioseguridad escolar (guantes, manejo de savia, advertencia contra la automedicación) que da seriedad institucional ante padres de familia e inspectores escolares.
5. **Estandarización y Escalabilidad:**
   - Se entrega la plantilla base lista para que los alumnos o el equipo docente generen 10, 20 o más plantas manteniendo la misma identidad visual uniforme.

---

## 4. Instrucciones para Imprimir o Exportar a PDF

1. Abre el archivo **`ficha_huerto_maguey_verde.html`** en Google Chrome o Microsoft Edge (puedes hacer doble clic sobre él).
2. Pulsa el botón verde superior **"Imprimir / Guardar en PDF (Tabloide)"** o presiona `Ctrl + P`.
3. En la ventana de impresión configura:
   - **Destino:** *Guardar como PDF* o tu impresora de tabloide.
   - **Tamaño de papel:** *Tabloide* (o *11 x 17 in* / *Doble Carta*).
   - **Márgenes:** *Ninguno* o *Personalizado (0)*.
   - **Opciones avanzadas:** Marcar la casilla **"Gráficos de segundo plano"** (indispensable para que se impriman los colores y fondos).
4. El archivo está calibrado con saltos de página CSS exactos (`break-after: page`), por lo que generará **exactamente 2 páginas perfectas**.
