 ***************************************************
*********** EXAMEN PARCIAL GRUPO 4 ****************
***************************************************
/*Integrantes:
Anderson Jhosafat Aguila Ancco
Bryan Alexander Chura Condori
Angelly Gutierrez Sanchez
Zarit Dafra de la Cruz Lavado */

*----------------------------------------------------------------------------*
*NOTA: COLOCAR LA BASE DE DATOS ORIGINAL DEL CENSO EN LA CARPETA Bases de datos* 
*----------------------------------------------------------------------------*

* Globals
clear all
cd "C:\Users\UNISCJSA\Documents\Graficos final"
global Final "C:\Users\UNISCJSA\Documents\Graficos final"
global Databases "$Final\Base de datos"
global Mapas "$Final\Mapas"
global Graficas "$Final\Graficas"

* Modificaciones a la base de datos original
use "$Databases\CPV2017_POB.dta", replace
gen Cobertura = c5_p8_6 == 0
label define cobLabs 0 "No Asegurado" 1 "Asegurado"
label values Cobertura cobLabs

save "$Databases\NUEVA_BASE.dta", replace

****************************************************************************

*--------------------------------*
*********     Mapas      ********* 
*--------------------------------*

** MAPA DE COBERTURA POR DEPARTAMENTO **************************************
clear all
use Cobertura factor_pond c5_p8_6  ubigeo2019 ccdd using "$Databases\NUEVA_BASE.dta", replace /// Abrir parcialmente la base

*1. Modificaciones a la base de datos
preserve
collapse (mean)Cobertura [iweight = factor_pond], by (ccdd)
replace Cobertura=Cobertura*100
save "$Databases\DATABASE_DEP.dta", replace
restore

*2. Mapa por departamento

shp2dta using "$Mapas\INEI_LIMITE_DEPARTAMENTAL_GEOGPSPERU_JUANSUYO_931381206", database($Mapas\perudep) coordinates($Mapas\corrdep) genid(ID) replace

use "$Mapas\perudep.dta" , clear
rename CCDD ccdd
merge 1:1 ccdd using "$Databases\DATABASE_DEP.dta", keep(match) nogen

spmap Cobertura using "$Mapas\corrdep.dta", id(ID)  fcolor(Purples) title("Cobertura por Departamento" "2017" ) note("Fuente: Módulo de Población del Censo del 2017" "Elaboración: Grupo 4") clmethod(custom) clbreaks(60.6 72.7 77.7 84.3 92.3) legend(size(vsmall) pos(7) title("{bf:Porcentaje de asegurados}",size(*0.5)))
	
graph export "$Graficas\Mapa 1.png", replace

** MAPA DE COBERTURA POR PROVINCIA *****************************************

clear all
use Cobertura factor_pond c5_p8_6  ubigeo2019 ccpp ccdd using "$Databases\NUEVA_BASE.dta", replace 

*1. Modificaciones a la base de datos
gen  ccdd_ccpp = ccdd + ccpp 
preserve
collapse (mean)Cobertura [iweight = factor_pond], by (ccdd_ccpp)
replace Cobertura=Cobertura*100
save "$Databases\DATABASE_PROV.dta", replace
restore

*2. Mapa por provincia
shp2dta using "$Mapas\INEI_LIMITE_PROVINCIAL_196_GEOGPSPERU_JUANSUYO_931381206.shp", database($Mapas\peruprov) coordinates($Mapas\corrprov) genid(ID) replace

use "$Mapas\peruprov.dta", clear
rename CCPP ccpp
rename CCDD ccdd
gen  ccdd_ccpp = ccdd + ccpp 
merge 1:1 ccdd_ccpp using "$Databases\DATABASE_PROV.dta", keep(match) nogen

spmap Cobertura using "$Mapas\corrprov.dta", id(ID)  fcolor(Purples) title("Cobertura por Provincia" "2017") note("Fuente: Módulo de Población del Censo del 2017" "Elaboración: Grupo 4") clmethod(custom) clbreaks(48.7 74.6 81.8 89.2 95.8) legend(size(small) pos(7) title("{bf:Porcentaje de asegurados}",size(*0.5)))

graph export "$Graficas\Mapa 2.png", replace


*-----------------------------------*
*********     Graficas      ********* 
*-----------------------------------*


** GRAFICO DE COBERTURA POR AREA *******************************************

clear all
use Cobertura factor_pond c5_p8_6 area using "$Databases\NUEVA_BASE.dta", replace

*1 Modificaciones a la base de datos
lab def areaLab 1 "Urbano", add
lab def areaLab 2 "Rural", add
lab values area areaLab

*2. Grafico de pie
set scheme swift_red
graph pie [weight=factor_pond], over(c5_p8_6)			///
	by(area, note("Fuente: Módulo de Población del Censo del 2017" "Elaboración: Grupo 4") ///
	title("Población asegurada por área de residencia" "2017" ))			///
	pie(1, explode) plabel(_all percent, color(white))  ///
	legend(label(1 "Afiliados a algún tipo de seguro")  ///
	label(2 "No asegurados")) subtitle(,ring(1)pos(-1) nobox)
	
graph export "$Graficas\Gráfico 1 .png", replace



** COBERTURA POR SEXO Y ESTADO CIVIL ********************************

clear all
use Cobertura factor_pond c5_p8_6 c5_p4_1 c5_p2 c5_p24 using "$Databases\NUEVA_BASE.dta", replace

*1. Modificaciones a la base de datos 

* Generamos una variable sobre estado civil
gen estCivMod = .
replace estCivMod = 1 if inlist(c5_p24, 6)
replace estCivMod = 2 if inlist(c5_p24, 1, 3)
replace estCivMod = 3 if inlist(c5_p24, 2, 4, 5)
label define labs 1 "Soltero(a)" 2 "Conviviente / Casado(a)" 3 "Separad(a) / Viudo(a) / Divorciado(a)"
label values estCivMod labs

* Etiquetas por sexo
lab def sexLab 1 "Hombres"
lab def sexLab 2 "Mujeres", add
lab values c5_p2 sexLab

* Cobertura por sexo
gen cob_V = .
replace cob_V=100*Cobertura if c5_p2==1

gen cob_M = .
replace cob_M =100*Cobertura if c5_p2==2
bysort estCivMod: egen meanHombres = mean(cob_V)
bysort estCivMod: egen meanMujeres = mean(cob_M)

*2. Grafico de barras
graph bar cob_V cob_M [weight=factor_pond], over(estCivMod, relabel(1 "Soltero" 2 "Conviviente / Casado" 3			 ///
	"Separado / Viudo / Divorciado") label(labsize(vsmall))) ///
	title("Cobertura por Sexo y Estado Civil" "2017")				 ///
	ytitle("% Porcentaje") ///
	blabel(bar, position(inside) format(%9.1f) color(white)) ///	
	legend(label(1 "Hombres") label(2 "Mujeres"))			 ///
	note("Fuente: Módulo de Población del Censo del 2017" "Elaboración: Grupo 4")
	
	
graph export "$Graficas\Gráfico 2 .png", replace

****** COMPARACION TIPO DE COBERTURA ENTRE HUANCAVELICA Y TACNA ******
clear all
use Cobertura factor_pond c5_p8_*  ccdd using "$Databases\NUEVA_BASE.dta", replace

*1. Moficaciones a la base de datos
encode ccdd, gen(ccddCat)

*Añadimos etiquetas
lab def depLab 09 "Huancavelica", add
lab def depLab 23 "Tacna", add
lab values ccddCat depLab

*Collapse
collapse (mean) c5_p8_* [iweight = factor_pond], by(ccddCat)
gen id=1
keep if ccdd == 09 | ccdd == 23
reshape long c5_p8_, i(ccddCat) j(Seguro)
replace c5_p8_ = 100*c5_p8_

*2. Grafico de barras
graph bar c5_p8_, over(Seguro, lab(angle(30) labsize(vsmall)) relabel(1 "SIS" 2 "ESSALUD" 3 "FFAA / PNP" 4 "Privado" 5 "Otro" 6 "Ninguno")) by(ccddCat, cols(3) title("Cobertura por tipo de seguro por provincia" "2017") note("Fuente: Módulo de Población del Censo del 2017" "Elaboración: Grupo 4")) subtitle(,ring(1)pos(-1) nobox) ytitle("% Porcentaje") blabel(bar, position(outside) format(%9.1f) color(black))
	
	
graph export "$Graficas\Gráfico 3.png", replace

*** GRAFICO DE COBERTURA POR TIPO DE SEGURO POR AREA BARRAS *******************

clear all
use area Cobertura factor_pond c5_p8_* using "$Databases\NUEVA_BASE.dta", replace

*1. Moficaciones a la base de datos

lab def areaLab 1 "Urbano", add
lab def areaLab 2 "Rural", add
lab values area areaLab

*Collapse
preserve
collapse (mean) c5_p8_* [iweight = factor_pond], by(area)

reshape long c5_p8_, i(area) j(Seguro)
replace c5_p8_ = 100*c5_p8_

*2. Grafico de barras

graph bar c5_p8_, over(Seguro, lab(angle(30) labsize(vsmall)) relabel(1 "SIS" 2 "ESSALUD" 3 "FFAA / PNP" 4 "Privado" 5 "Otro" 6 "Ninguno")) by(area, cols(3)  title("Cobertura de tipo de seguro por área de residencia" "2017") note("Fuente: Módulo de Población del Censo del 2017")) ytitle("% Porcentaje ") blabel(bar, position(outside) format(%9.1f) color(black)) subtitle(,ring(1)pos(-1) nobox)
	
graph export "$Graficas\Gráfico 4.png", replace
restore



*------------------------------*
*******      Tablas     ******** 
*------------------------------*

**** TABLA DE ASEGURADOS POR GRUPO ETARIO ****

clear all
use Cobertura factor_pond  c5_p4_1 c5_p8_6 ccdd using "$Databases\NUEVA_BASE.dta", replace

*1.Modificaciones a la base de datos

gen Edad = .
replace Edad = 1 if c5_p4_1>=0
replace Edad = 2 if c5_p4_1>11
replace Edad = 3 if c5_p4_1>17
replace Edad = 4 if c5_p4_1>29
replace Edad = 5 if c5_p4_1>59
label define labsEdad 1 "Nino (0-11)" 2 "Adolescente (11-17)" 3 "Joven (18-29)" 4 "Adulto (29-59)" 5 "Adulto mayor (>60)"
label values Edad labsEdad

*2. Tabla
tabulate Edad Cobertura [iweight = factor_pond], row nofreq

*3. Exportar
asdoc tabulate Edad Cobertura [iweight = factor_pond], row nofreq replace

