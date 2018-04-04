//
// Created by Stefanie Muroya lei on 3/29/18.
//

#ifndef BDII_CREATE_H
#define BDII_CREATE_H


#include "Comando.h"

class Create: public Comando{


    void getAttributos();
    void getDataTypes();
    void createTabla();
public:
    void process();


};


#endif //BDII_CREATE_H
