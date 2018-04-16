//
// Created by Stefanie Muroya lei on 3/29/18.
//

#ifndef BDII_SELECT_H
#define BDII_SELECT_H


#include "Comando.h"

class Select : public Comando{
    void displayAttributes();
public:
    void process();
};


#endif //BDII_SELECT_H
