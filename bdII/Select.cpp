//
// Created by Stefanie Muroya lei on 3/29/18.
//

#include <iostream>
#include "Select.h"


void Select::process() {

    for(int i =0; i < registros.size(); i++){
        if(isValidRegistro[i]){
            cout << "*****" << endl;
            for(int j =0; j< registros[i].size(); j++){
                cout << atributos[j] << ": " << int(registros[i][j][0]) << endl;
            }
            cout << "*****" << endl << endl;
        }
    }
}