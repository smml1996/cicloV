//
// Created by Stefanie Muroya lei on 3/29/18.
//

#include <iostream>
#include "Select.h"


void Select::displayAttributes() {

    int temp;
    for(int i =0; i < atributos.size(); i++){
        temp = dataSizes[i]-atributos[i].size();
        if(temp %2 != 0) temp++;
        temp+=4;
        temp = (temp) / 2;
        for(int j =0; j < temp;j++){
            cout<<" ";
        }
        cout << atributos[i];
        for(int j =0; j < temp;j++){
            cout<<" ";
        }
    }

    cout << endl;
}

void Select::process() {
    displayAttributes();

    int temp;
    string registro;
    for(int i =0; i < registros.size(); i++){
        if(isValidRegistro[i]){

            for(int j =0; j< registros[i].size(); j++){
                registro ="";

                temp = dataSizes[i]- registros[i][j].size();
                if(temp%2!=0) temp+=1;
                temp+=4;
                temp/=2;

                for(int k =0; k< temp; k++){
                    registro+=" ";
                }
                registro+= registros[i][j];
                for(int k =0; k< temp+1; k++){
                    registro+=" ";
                }
                cout<< registro;

            }
        }
        cout << endl;
    }
}