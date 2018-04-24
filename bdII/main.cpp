#include <iostream>
#include <vector>
#include "Comando.h"
#include "Helpers.h"

using namespace std;


/*
 * COMANDOS:
 * * CREATE nombre_tabla (atributo1, atributo2, atributo3,.., atributoN) WITH TYPES (CHAR[K], INTEGER, FECHA);
 * * UPDATE FROM nombre_tabla SET atributo_1 = ? WHERE condicion_logica
 * * DELETE FROM nombre_tabla WHERE condicion_logica
 * * INSERT INTO nombre_tabla (atributos) VALUES (valores)
 * * SELECT * FROM  nombre_tabla WHERE condicion_logica
 */



bool first = false;
int main() {


    string tt;


    char temp;
    while(tt!="exit"){

        tt= "";

        cout << ">> ";

        do{
            temp = getchar();
            tt+=temp;
        }while(temp!=';');

        tt = tt.substr(0, tt.size()-1);
        if(first) tt = tt.substr(1);
        Comando c(tt);
        first = true;

    }


    /*for(int i =0; i < 1000000; i++) {
        tt = "insert into personas2 (id, nombre, apellido, edad, fecha) values (";
        tt += Helpers::stringToNum(i);
        tt += R"(, "nombre", "apellido", 21, 06-12-1996))";
        Comando c(tt);
    }*/

    return 0;
}