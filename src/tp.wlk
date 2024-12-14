class mago{

    var objetosMagicos = []
    const poderInnato
    const nombre 
    var property resistencia
    var property reservaPersonal 
    var categoria 

    method poderTotal(){
        return objetosMagicos.sum({objeto => objeto.suPoder(self)}) * poderInnato
    }

    method tieneEstaCantLetrasPar(){  
        return (nombre.length()  % 2 ) == 0 
    }

    method cantLetrasDelNombre(){
        return nombre.length()
    }

    // method desafiar(enemigo){
    //     if(categoria.puedoGanarle(enemigo, self)){ 
    //         //const aux = categoria.efectos(magoEnemigo)
    //         const aux = self.generarEfectosSerDerrotado(enemigo)
    //         self.ganaPuntos(aux)
    //     }
    // }

    method desafiar(magoEnemigo){
        if(self.puedoGanarle(magoEnemigo)){ 
            const aux = self.generarEfectosSerDerrotado(magoEnemigo)
            self.ganaPuntos(aux)
        }
    }

    method puedoGanarle(magoEnemigo){
        return magoEnemigo.puedePerder(self)
    }

    method puedePerder(atacante){
        return categoria.perder(atacante, self) //me quedo mal el nombre seria puede
    }

//-----------------------------------------
    method generarEfectosSerDerrotado(enemigo){
        return categoria.efectos(enemigo)
    }

    method pierdePuntosEnSuReserva(cantidad){
        reservaPersonal -= cantidad 
    }

    method ganaPuntos(cantidad){
        reservaPersonal += cantidad 
    }

}


//----------------------------------------OBJETOS---------------------------------------------------
class Objeto{

    const basePoder

    method suPoder(mago){
        return basePoder
    }

}

class Varita inherits Objeto{

    override method suPoder(mago){
        if(mago.tieneEstaCantLetrasPar()){
            return super(mago) + ((basePoder * 50) / 100)
        }
            return super(mago)
    }
}

class Tunica inherits Objeto{

    var tipo

    override method suPoder(mago){
        return super(mago) + 2 * mago.resistencia() * tipo.extra(mago)  
    }

}


object comun{

    method extra(mago){
        //return mago.resistencia()
    }
}

object epica{

    method extra(mago){
        return 10 
    }

}

class Amuleto inherits Objeto{

    override method suPoder(mago){
        return 200 
    }

}

class Ojota inherits Objeto{

    override method suPoder(mago){
        return mago.cantLetrasDelNombre() * 10 
    }
}

//--------------------------------------------------------------------------------------------------------------------------------------

//---------------------------------------------------MAGOS CATEGORIA-------------------------------------------------

object aprendiz{

    method perder(atacante, mago){
        return mago.resistencia() < atacante.poderTotal()
    }

    method efectos(magoEnemigo){
        magoEnemigo.pierdePuntosEnSuReserva(magoEnemigo.reservaPersonal() / 2)
        return magoEnemigo.reservaPersonal() / 2
        //magoAtacante.ganaPuntos(magoEnemigo.reservaPersonal() / 2)
    }
}

object veteranos{

    method perder(atacante, mago){
        return atacante.poderTotal() >=  1.5 * mago.resistencia()
    }

    method efectos(magoEnemigo){
        magoEnemigo.pierdePuntosEnSuReserva(magoEnemigo.reservaPersonal() / 4)
        return magoEnemigo.reservaPersonal() / 4
        //magoAtacante.ganaPuntos(magoEnemigo.reservaPersonal() / 4)
    }
}

object inmortal{

    method perder(atacante, mago){
        return false
    }

    method efectos(magoEnemigo){}
}

//-------------------------------------------------------------GREMIOS DE MAGOS-------------------------------------------------------

//------------------------------------UNA CLASE APARTE QUE GENERA EL GREMIO------------------------------------

//lo fundamental es que a partir de ahora a la hora de crear un gremio llame a fundador para crearlo, nunca por fuera de èl
class Fundador{

    method crearGremio(miembros){
        if(miembros.size() >= 2){
            const nuevoGremio = new Gremio(magos = [miembros], lider = null)
        }else{
            throw new NoSeCreoElGremio(message = "NO SE PUDO CREAR EL GREMIO")
        }
    }
}

class NoSeCreoElGremio inherits DomainException{}


class Gremio{

    var magos = []
    var lider 

    method poderTotal(){
        return magos.sum({mago => mago.poderTotal()})
    }

    method reservaDeEnergiaMagicaDelGremio(){
        return magos.sum({mago => mago.reservaPersonal()})
    }

    method masPoderoso(){
        lider = magos.max({mago => mago.poderTotal()})
    }

    method desafiar(enemigos){
        if(self.puedoGanarle(enemigos)){
            //enemigos.forEach({enemigo => enemigo.generarEfectosSerDerrotado(self)})
            const cantidad = enemigos.map({enemigo => enemigo.generarEfectosSerDerrotado(self)}).sum() // calculo la cantidad de puntos que fueron perdiendo los enemigos
            self.agregarReservaAlLider(cantidad)
        }
    }

    method puedoGanarle(enemigos){
        return self.poderTotal() > enemigos.reservaDeEnergiaMagicaDelGremio() + lider.poderTotal()
    }

    method agregarReservaAlLider(cantidad){
        lider.ganaPuntos(cantidad)
    }


    //PUNTO 3: 

    /* Considero que no hay que hacer ningun cambio porque al fin y al cabo el method 

    method masPoderoso(){
        lider = magos.max({mago => mago.poderTotal()})
    }

    va a recorrer toda la lista de magos entonces ahi va a estar tambien gremio entonces esa lista seria:
    [mago, mago, gremio, mago]
    [100, 200, 300,50]
    entonces aca va a elegir como el lider al gremio entonces el lider del gremio anterior va a ser el lider nuevamente,entonces cumple con el requisito,termina
    siendo como recursivo

    [mago, mago, gremio, mago]
    [100, 300, 50 ,50]
    y tambien cubre el caso en el cual si el mago que esta solo tiene mayor poderTotal que el gremio total(que era la sumatoria), entonces el lider seria ahora ese mago solitaria

    */

}

/* 

// method puedoGanarle(enemigos){
    //     return enemigos.puedePerder(self)
    // }

    // method puedePerder(atacante){
    //     return atacante.poderTotal() > self.reservaDeEnergiaMagicaDelGremio() + lider.poderTotal()
    // }

    // method desafiar(enemigos){
    //     if(self.puedoGanarle(enemigos)){
    //         //enemigos.forEach({enemigo => enemigo.generarEfectosSerDerrotado(self)})
    //         const cantidad = enemigos.sum({enemigo => enemigo.generarEfectosSerDerrotado(self)}) // calculo la cantidad de puntos que fueron perdiendo los enemigos
    //         self.agregarReservaAlLider(cantidad)
    //     }
    // }

*/ 

