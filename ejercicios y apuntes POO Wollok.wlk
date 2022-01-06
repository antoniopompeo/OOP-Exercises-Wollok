object criterioAprobado{
    method apply(a){
        return a.aprobado()
    }
}
alumnos.filter(criterioAprobado) 

/*
pero podes hacer esto que es mas practico: alumnos.filter({a => a.aprobado})

el metodo filter tiene que recibir un objeto. por eso se le pasa el 'criterioAprobado', que es un objeto creado especialmente para hacer ese criterio.
pero para que no tengas que crear un objeto de forma metodica cada vez que quieras crear un criterio, esta esta forma
de hacerlo: consiste en crear un objeto (que nace y muere en ese instante) que haga lo mismo que criterioAprobado.
*/

alumnos.filter({''a ''=>a.aprobado}) // es el parametro que le vamos a pasar al metodo, es decir seria como esta parte: method apply(''a''){
y alumnos.filter({a=>''a.aprobado''}) //es lo que le vamos a aplicar, es decir seria esta parte: return ''a.aprobado()''


class Bici{
    var property rodado = 12
    var property color

    method velocicdadMaxima() = self.rodado()*12

    method cantPasajeros() = 1

    method costo(km) = km/100

    method pintarte(unColor){
        self.color(unColor)
    }
}

class Auto{
    var property velocidadMaxima = 200
    var property cantPasajeros  = 4
    var property color

    method costo(km) = km*0,2 + self.cantPasajeros()*10

    method pintarte(unColor){
        self.color(unColor)
    }
}

const vehiculos.[biciPlayera, autoViejo, autoModerno]

/*
1) quiero vehiculos utiles, son aquellos que pueden llevar mas de 2 personas
2) cuantos vehiculos perfectos hay, son aquellos que la vel max es multiplo de 10 y pueden llevar una cantidad par de pasajeros
3) pintar de rojo vehiculos que pueden llevar mas de 2 pasajeros
4) quiero saber si todos los vehiculos perfectos son del mismo color
4') chequear que todos los vehiculos son del mismo color
5) quiero saber que cantidad de pasajeros pueden llevar las bicis
*/

//1) 
    vehiculos.filter{ v => v.cantPasajeros()>2} /*es lo mismo poner que no poner lo parentesis cuando usas las llaves 
    en este caso hizo la implementacion del methodo ahi mismo dentro de las llaves, pero en el pto 2 directamente le puso el esPerfecto, pero porque esPerfecto
    lo ibamos a tener que usar varias veces para otros puntos, entonces en ese caso para no repetir codigo creamos el metodo y listo.*/

//2) 
    vehiculos.filter{v => v.esPerfecto()}.size()
    //otra forma de hacerlo: (y es la mas feliz ya que es la mas declarativa y simple) es usar el metodo que cuenta (esta en la guia de lenguajes): 
    vehiculos.count{v => v.esPerfecto()}

//3)este pto, adiferencia de los primeros dos, es que causa un efecto en los objetos:
    vehiculos.filter{v => v.esUtil()}.foreach{v => v.pintarte(rojo)}

    /*el foreach se usa para generar un efecto especifico que le pasemos por parametro a toda la lista, no hay que confunfirlo con un map que lo que hace es
    conformar la lista con la respuesta de lo que genera aplicarlo lo que pasamos por parametro a la lista.
    es decir no esta bien visto usar el map cuando se busca generar un efecto en los objetos de la lista.

    otra aclaracion es que cuando se crean las listas, lo que son la listas en si es un conjunto de punteros apuntando a ciertos objetos. no es que hace una copia
    de esos objetos. y por eso mismo, podemos borrar un objeto de una lista y no borra el objeto en si, sino que borra el punto a ese objeto.*/

//4) 
    vehiculos.filter{v => v.esPerfecto()}.all{v => v.color() == verde}

//4') 
    vehiculos.all{v => v.color() == vehiculos.first().color } //que todos tengan el mismo color que el primero, es una forma de solucionar el problema
    //es raro el planteo pero lo hizo aproposito, igualmente, este forma no funciona si la lista es vacia, por eso le agrego esto:
    vehiculos.isEmpty() || vehiculos.all{v => v.color() == vehiculos.first().color }

/*5) este ejercicio esta hecho aproposito para tentarnos en hacer un switch statement en la resolucion del ejercicio. que
 consiste en alguna parte del codigo consultar que tipo de objeto es, esto esta re mal, porque si nos cambian el tipo de
  objetos vamos a tener que cambiar todo, no es polimorfico. lo que hay que hacer es ya tener una lista que este 
  conformada por solo bicis, es por eso que en la resolucion pone "bicis". pasa que ellos aproposito nos pusieron una 
  lista con todos los tipos de objetos entonces la primera intencion es agarrar esa lista y empezar a filtrarla, pero no. */
    bicis.sum{v => v.cantPasajeros()}



class Tanque {
    var property coraza = 200
    var property tripulantes = 5
    var property misiles = {}

    method atacar(tanque){
        const disparado = misiles.anyOne()
        disparado.disparateContra(tanque)
        misiles.remove(disparado)
    }
    
    method recibiDaño(daño){
        coraza -= daño
    }

    method esta() = coraza > 0

    method atacarUnidad(unidad){
        self.atacar( unidad.tanquesVivos().anyOne() )
    }

}

class bazooka() {
    const property cabezas

    method disparateContra(tanque){
        otro.recibiDaño(cabezas *2)
        // lo que no esta bueno es hacer: otro.coraza(coraza - cabezas * 2) 
    }
}

object coheteGroso(){
    method disparateContra(tanque){
        tanque.recibiDaño(tanque.coraza)
    }
}

object Termico(){
    method disparateContra(tanque){
        if (tanque.emiteCalor) {
            tanque.sufriDaño(20)
        }
    }

}

/* 
if (tanque.tripulantes) no es la mejor manera porque puede pasar que de pronto haya un tanque "anti termico" que por mas
que tenga tripulantes, munca va a tener calor, entonces con esta subfuncion no encargado de solucinar eso de ante mano,
porque luego lo que tenemos que hacer es agregar en esa subfuncion que contemple si el tanque es antitermico y listo.
*/

class Unidad(){
    const property tanques

    method misilesRestantes() = tanques.flatMap{t => t.misiles()}

    method tanquesVivos() = tanques.filter{t => t.estaVivo()}

    method tanquesArmados() = self.tanquesVivos().filter{t => t.misiles().size() > 1}

    method atacarUnidad(unidad){
        self.tanquesArmados().foreach{ t => t.atacarUnidad(unidad) }
    }
}

//para el punto 6, cuando se nos agrega el tanque blindado, el haber hecho el recibiDaño nos salvo de dolores de cabeza.
/*
para saber si es correcto hacer una clase: hay que preguntarse si vamos a necesitar varios objetos con distintos estados.
por ejemplo la coraza en los tanques y las cabezas en las bazookas. pero por ejemplo el cohete groso no necesita distintos estados y es por eso que es un object.
*/

new D().m() que retorna? : retorna 5, no 3

A
q() --> return 4
n() --> self.o()
o() --> return 3
p() --> self.q()

B                           C   (hermano de B)
p() --> super()             n() --> return 1
q() --> retuen 5            o() --> return 8

D (hijo de B)
m() --> self.n()
o() --> self.p

super: busca uno arriba desde donde esta el metodo en el que esta parado
self: busca desde el objeto, si no lo encuentra empieza el lookup, es decir empeiza a fijarse para arriba hasta encontrarlo

//----------------//

//sigue con el ejercicio anterior: 

//-unidad conservadora: solo considera armados a los tanques con mas de 3 unidades.

class UnidadConservadora inherits Unidad {
    override method tanquesArmados() = super().filter{t => t.misiles().size() > 3}
}

//-camiones: son como tanques pero no pueden atacar

class Vehiculo {
    method estaArmado()
}

/*
esta mal visto hacer que camiones herede de tanques ya que el camion no es un tanque, 
por eso arma una clase mas general e incluye a los camiones ahi, no esta mal crear esta clase vacia, 
estuviese mal si no hubiera sido necesaria, pero en este caso es necesario de esto no estoy seguro, no se si no lo completo por algo en especial o que.
*/


//-Misiles termicosSensibles: son MT que si el tanque no emite calor hacen la mitad de daño

class sensible inherits MTermico{
	override method pifialeA(v){ v.recibirDaño(daño/2) }
}

class MTermico{
	const daño = 60
	method disparateContra(v){
		if (v.emiteCalor()) v.recibirDaño(daño)
		else self.pifialeA(v)
	}
	method pifialeA(v){}
}

//-----------------------------------------------------------------------//

/*que es una clase abstracta? cuando dejas metodos sin definir:
cuando hay un metodo abstracto hay que ponerle un "a" al costado si hacemos el diagrama de clases, para que se sepa que eso es abstracto 
*/

class SensFuerza {
    var property midiclorians
    var property vida
    var property locura
    method atacar(persona)  "a"
    method descansar()  "a"
}

/*es para que al agregar una clase me salte un cartel diciendo que faltan implementar esas clases cuando agregue esa nueva clase, ,es con
fines documentatiovos, y tampoco son necesarias para cuando quiero crear un metodo comun pero que varie su comportamiento segun los objetos que lo hereden.

hay que tener claro que no es necesario tener una super clase para hacer polimorfismo, podemos hacer otras cosas, como haciamos antes de que conozcamos super y herencia.
*/

class jedi inherits sensFuerza {
method atacar(persona){ 
    persona.vida(1.max(persona.vida()-midiclorians))  (no deja que sea menor que uno) 
    }
method descansar() {
    vida += 10
    locura -=1
    }
}

class sith inherits sensFuerza {
    method atacar(persona) {
        persona.vida(persona.vida()-midiclorians)
        locura +=1
    }
    method descansar(){
        vida += midiclorians
    }
}

//----

como en el method atacar, esta repitiendo logica (logica, no codigo, repetir codigo es subjetivo ya que si le cambio el nombre de las variables ya no es lo mismo)

class SensFuerza {
    var property midiclorians
    var property vida
    var property locura
    method atacar(persona)
    method descansar()
    method perderVida(){
        self.vida(self.vida()-daño)
    }
}


class jedi inherits sensFuerza {
method atacar(persona){ 
    persona.vida(miniclorians.min(persona.vida()-1))
    }
method descansar() {
    vida += 10
    locura -=1
    }
}

class sith inherits sensFuerza {
    method atacar(persona) {
        persona.vida(daño)
        locura +=1
    }
    method descansar(){
        vida += midiclorians
    }
}

//---

//despues tambien hizo esto: 


class SensFuerza {
    var property midiclorians
    var property vida
    var property locura
    method dañoA()  "a" /importante como agrego este method abstrcto, es para que cuando instanciemos un objeto, sepamos que le tenemos que definir el daño que hace ###
    method atacar(persona){
        const daño = self.dañoA(persona)
        persona.perderVida(daño)
    }
    method descansar()
    method perderVida(){
        self.vida(self.vida()-daño)
    }
}

/* esto es especialmente bueno porque ahora con esto, jedi ya no tiene que preocupase con el method atacar
ademas ya no me tengo que preocupar cuando se cree un nuevo objeto por el method atacar, solo por el daño que inflinge, a menos que el 
nuevo objeto cambie la forma en la que atacar
*/

class jedi inherits sensFuerza {
method descansar() {
    vida += 10
    locura -=1
    }
method dañoA(persona) = midiclorians.min(persona-vida()-1)
}


class sith inherits sensFuerza {
    method atacar(persona) {
        super(persona)
        locura +=1
    }
    method descansar(){
        vida += midiclorians
    }
    method dañoA(persona) = midiclorians
}

/*
esta ultima modificacion es mucho mas interesante porque llegamos a otro nivel, es un nivel de ultilidad masomenos similar al orden superior, debido a que los objetos
completan un method ya definido con un method suyo particular de cada uno.

el profe recomendo: leer el libro: gamma, disign patterns, especialmente la seccion de template methodo
*/


/*
Peroahora surge el problema de herencia vs composicion:
en los paradigmas orientados a objetos una vez instanciada un obejeto desde una clase, no puede cambiar de clase.
que pasa si ani es jedi pero durante el programa quiere pasar a sith?
hacemos lo que se llama composicion, obviamente sin hacer el swicth statement que no se tiene que hacer (es cuando haces un if preguntando si es jedi o sith y en base a eso
haces tal o cual cosa, esto se haria directamente en la clase SensFuerza), hacemos la forma que se abajo de forma tal que ahora 
jedi y sith sean una forma de comportarse
*/

class SensFuerza {
    var property midiclorians
    var property vida
    var property locura
    var property alineamiento
    ...
    method descansar(){
        alineamiento.descansar(self)
    }
    method perdervida(daño){
        vida -= daño
    }

    method atacar(per){
        per.perderVida(alineamiento.dañoA(Self, per))
    }
}

//despues cuando instacion a ani:
 const ani = new SensFuerza(
     midiclorians = 10
     vida = 10
     locura =20
     alineamiento = jedi
 )

class alineamiento{
    descansar()
    dañoA(yo, per)
    method atacar(per){
        alineamiento.ataco(self)
        per.perderVida(alineamiento.dañoA(self, per))
    }
}

 object jedi {
     method descansar(per) {
        per.vida(per.vida +10)
        per.locura(per.locura +1)
     }
     method dañoA(yo, persona)= yo.midiclorians.min(persona.vida()-1)
     method ataco(yo){}
}


object sith {
    method ataco(yo) {
        yo.locura(yo.locura()+1)
    }
    method descansar(per){
        per.vida(per.vida + per.midiclorians)
    }
    method dañoA(yo, persona) = yo.midiclorians() 
}

/*
que pasa aca? cuando ani usa el method descansar llama al method descansar del que sea su alineamiento, en este caso jedi,
 despues en jedi se le pasa como parametro
a self que es ani entonces el objeto jedi no se va modificar su propi estado sino que va a modificar el estado de ani

si ahora nos agregan los robots, que se comportan igual que las personas (es decir la clase SensFuerza) podriamos hacerlas
 clase robot que herede de SensFuerza 
PERO a partir de ahora nunca nos vamos a tener que olvidar de preguntarnos si un robot puede  convertirse en persona y/o 
viceversa. si la respuesta del cliente es no,
lo hariamos asi:
*/
class robot inherits SensFuerza{
    overrride method perderVida(x){
        super(x/2)
    }
}

//y si se crea un sith gordo? primero nos preguntamos si el sith gordo puede en algun momento adelgazar y convertirse en un siht comun.


class Sg inherits SensFuerza{
    override method descansar(per){
        per.vida(per.vida()+ per.midiclorians() / 2)
    }
}

//hacer el ejercicio wor of warcrft para practicar esto, porque va a estar en el parcial.


//tp integrador minions:

class Empleado{
    var property estamina

    method come(fruta){
        //estamina += fruta.estaminaQueAporta()
        self.estamina( fruta.estamina() + self.estamina() )
    }
}

class Biclope inhertis Empleado{
    override method estamina(nueva){
        super( nueva.min(10) )
    }
}

class Fruta{
    const property estaminaQueAporta
}

const banana = new Fruta(estaminaQueAporta = 10)

//---------------------------------------

limpiarSector(){
    if (!puedoLimpiarSector<raza, trabajo, self.sector>)
        error!
    ...
}

defenderSector(){
    if (!puedoDefenderSector<raza, trabajo, self.sector>)
        error!
    ...
}


/*para no hacer este mismo procedimiento para cada tarea, hago esto: (igualmente dijo que depsues va a ir un paso mas 
adelante y ni va a hacer falta ese method hace(tarea))*/

class Empleado{
    var property estamina

    method come(fruta){
        //estamina += fruta.estaminaQueAporta()
        self.estamina( fruta.estamina() + self.estamina() )
    }

    method hace(tarea){
        if(!tarea.puedeHacerlo(self))
            throw new NoPuedeHacerLaTarea(empleado = self, tarea = tarea)
        tarea.laHace(self)
    }
}


Class NoPuedeHacerLaTarea inherits exeption{
    const empleado
    const  tarea
}

//--------------------------------------------------

class defender{
    const sector

    method puedeHacerte(empleado) = empleado.podesDefender(sector.amenaza())
    method laHace(empleado){
        empleado.defende()
    }
}

/*
pero la verdad que me parece re al pedo crear todo este quilombo para despues tener que volver a usar el empleado.defende
 (usa el empleado.defende para delegar la accion en cada empleado y no tener que hacer un if
preguntando si es soldado hace tal cosa si no lo sos hace esta otra y demas, porque si sale un nuevo tipo de empleado vas 
a tner que cambair esa parte del codigo)
*/

//entonces directamente lo deja asi:

class Empleado{
    var property estamina

    method come(fruta){
        self.estamina( fruta.estamina() + self.estamina() )
    }

    method defender(sector){
        if (!trabajo.puedeDefender(self,sector.amenaza))
            throw new NoPuedeHacerLaTarea (empleado= self)
        trabajo.defiendo(self)
    }
}

Class NoPuedeHacerLaTarea inherits exeption{
    const empleado
    const tarea
}

class defender{
    const sector

    method puedeHacerte(empleado) = empleado.podesDefender(sector.amenaza())
    method laHace(empleado){
        empleado.defende(self.sector())
    }
    method fuerza() = trabajo.fuerzaDe(self)
}

class mucama inherits Trabajo{
    override method puedeDefedner(empleado) = false
}

class trabajo{
    method puedeDefender(empleado, am) = empleado.fuerza() >= am
    method fuerzaDe(emp) = emp.estamina()/2 +2
}

class soldado inherits Trabajo{
    var property experiendcia
    override method fuerzaDe(emp) = super(emp) + experiendcia *2
}


//-----------------------------------------------






























