
# 🧾 Examen Final - Manejo de Bases de datos con Stata

**Facultad de Ciencias Sociales – Economía PUCP**

Este repositorio contiene el desarrollo completo del **examen final del curso Manejo de Base de Datos**. El trabajo analiza la situación de la cobertura de seguro de salud en el Perú durante el Censo Nacional de 2017, usando herramientas estadísticas, geoespaciales y visuales mediante **Stata**.

## 👥 Integrantes del grupo

* **Zarit Dafra de la Cruz Lavado**
* **Angelly Gutiérrez Sánchez**
* **Bryan Alexander Chura Condori**
* **Anderson Jhosafat Águila Ancco**

---

## 🎯 Objetivo del proyecto

Responder la pregunta:

> **¿Cuál es la situación de la población peruana respecto a la cobertura de seguro de salud para el 2017?**

Para ello, se analiza la base censal del INEI, identificando diferencias territoriales (departamentales y provinciales), demográficas (sexo, edad, estado civil) y socioeconómicas (área rural/urbana) asociadas a la tenencia de seguro de salud (SIS, ESSALUD, privado, otros o ninguno).

---

## 📁 Estructura del Repositorio

```
├── Base de datos/             # Base censal y bases procesadas (formato .dta)
├── Mapas/                     # Archivos .shp, .dbf, .prj, .shx para mapas
├── Graficas/                  # Exportaciones en PNG de mapas y gráficos
├── PDF Y DO/
│   ├── FINAL GRUPO 4.do       # Código Stata completo
│   └── INFORME_GRUPO_4.pdf    # Informe final (análisis detallado)
└── README.md                  # Este archivo descriptivo
```

> ⚠️ **IMPORTANTE:**
> Para que el código funcione correctamente, es **indispensable colocar la base original del censo (`CPV2017_POB.dta`) en la carpeta `Base de datos/`**.

---

## 🧪 Metodología

El trabajo se divide en tres etapas principales:

### 1. **Procesamiento de Datos**

* Se parte de la base `CPV2017_POB.dta`.
* Se crea la variable `Cobertura` (1 si está asegurado, 0 si no).
* Se generan bases agregadas por departamento (`DATABASE_DEP.dta`) y provincia (`DATABASE_PROV.dta`).

### 2. **Visualización Geoespacial**

* Se emplean `shp2dta` y `spmap` para mapear cobertura por:

  * Departamento (mapa 1)
  * Provincia (mapa 2)

### 3. **Análisis Descriptivo**

* Gráficos de cobertura por área (urbano/rural), sexo, estado civil y tipo de seguro.
* Comparaciones regionales clave: **Huancavelica** (mayor cobertura) vs. **Tacna** (menor cobertura).
* Tablas de cobertura por grupo etario.

---

## 🧩 Hallazgos destacados

* **Desigualdad territorial**: La cobertura más alta se observa en departamentos de la sierra y selva (Huancavelica 92.3%), mientras que Tacna presenta la menor (60.7%).
* **Área de residencia**: La cobertura en zonas rurales (82.7%) supera a la urbana (73.8%), pero la calidad del servicio podría ser inferior.
* **Tipo de seguro**: El **SIS predomina** en áreas rurales (77.1%), mientras que ESSALUD y seguros privados concentran su cobertura en áreas urbanas.
* **Sexo y estado civil**: Las mujeres presentan mayor cobertura en todos los estados civiles, con especial énfasis en convivientes y casadas.
* **Edad**: Niños y adultos mayores tienen mayores niveles de aseguramiento; adolescentes y jóvenes son los grupos más vulnerables.

---

## 📊 Visualizaciones generadas

* Mapa 1: Cobertura por departamento
* Mapa 2: Cobertura por provincia
* Gráfico 1: Asegurados por área (pie chart)
* Gráfico 2: Sexo y estado civil
* Gráfico 3: Tipo de seguro (Huancavelica vs. Tacna)
* Gráfico 4: Tipo de seguro por área
* Tabla 1: Cobertura por grupo etario

---

## 🛠️ Requisitos técnicos

* Stata 14 o superior
* Librerías: `spmap`, `shp2dta`, `asdoc`
* Archivos `.shp`, `.dbf`, `.prj`, `.shx` en la carpeta `Mapas/`

> 💡 **Nota:** Asegúrate de ajustar la ruta del directorio (`cd`) al entorno local en tu computadora antes de ejecutar el script.

