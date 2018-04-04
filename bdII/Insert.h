//
// Created by Stefanie Muroya lei on 3/29/18.
//

#ifndef BDII_INSERT_H
#define BDII_INSERT_H


#include "Comando.h"

class Insert: public Comando{

    int indexValues = -1;
    const string NULO = "/";
    vector<bool> isAttributedListed;
    void getAtributes();
    void getValues();
    vector<string>values;
    vector<string> atributesFound;
    bool valuesAreValid();
    string getStringAtributos();
    string getStringValues();

public:
    void process();

};


#endif //BDII_INSERT_H
