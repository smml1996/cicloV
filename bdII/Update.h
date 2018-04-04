//
// Created by Stefanie Muroya lei on 3/29/18.
//

#ifndef BDII_UPDATE_H
#define BDII_UPDATE_H


#include "Comando.h"

class Update : public Comando{
    fstream ostr;
    streambuf * pbuf;

    string NULO = "/";
    vector<string> vals;
    vector<bool> isAttributMentioned;
    void getAtributosAndValues();

    string getStringInput();
    void changeValues();

    string getNewBlock(const int &index);
    void writeNewBlock(const int &index, const string newBlock);

    bool valuesAreValid();

public:
    void process();

};


#endif //BDII_UPDATE_H
