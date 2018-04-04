//
// Created by Stefanie Muroya lei on 3/29/18.
//

#include <iostream>
#include "Delete.h"


void Delete::process(){

    char eraser[blockSize+1];

    for(int i =0; i < blockSize; i++){
        eraser[i] = ' ';
    }

    eraser[blockSize] = '\0';


    std::fstream ostr ("../" + tableName + ".txt");
    std::streambuf * pbuf = ostr.rdbuf();
    for(int i =0; i < registros.size(); i++){

        if(isValidRegistro[i]) {
            pbuf->pubseekpos(i * blockSize);
            pbuf->sputn(eraser, sizeof(eraser) - 1);
        }
    }

    ostr.close();


}
