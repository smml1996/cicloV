//
// Created by Stefanie Muroya lei on 3/29/18.
//

#include "Update.h"
#include "Helpers.h"


void Update::getAtributosAndValues() {

    string atributosYvalores = getStringInput();

    int indexActualAtribute;
    string temp;
    for(int i =0; i<atributosYvalores.size(); i++){

        if(atributosYvalores[i] == ','){
            vals[indexActualAtribute] = temp;
            temp = "";
        }else if(atributosYvalores[i] == '='){
            indexActualAtribute = getAttributeIndex(temp);
            if(indexActualAtribute!= -1){
                isAttributMentioned[indexActualAtribute] = true;
            }else{
                throw invalid_argument("invalid sintax");
            }

            temp = "";
        }else{
            temp +=atributosYvalores[i];
        }


    }

    if(indexActualAtribute!= -1){
        vals[indexActualAtribute] = temp;
    }else{
        throw invalid_argument("invalid sintax");
    }

}

string Update::getStringInput() {

    string ans = "";

    for(int i = 4; i < splittedComando.size(); i++){
        if(splittedComando[i]!=WHERE){
            ans+= splittedComando[i];
        }else
            return ans;
    }

    throw invalid_argument("invalid sintax");
}

void Update::writeNewBlock(const int &index, const string newBlock) {

    char finalNewBlock[newBlock.size()+1];
    finalNewBlock[newBlock.size()] = '/0';

    for(int i =0; i < newBlock.size(); i++){
        finalNewBlock[i] = newBlock[i];
    }
    pbuf->pubseekpos(index * blockSize);
    pbuf->sputn (finalNewBlock,sizeof(finalNewBlock)-1);
}

string Update::getNewBlock(const int &index) {

    string ans = "";
    string temp;

    for(int i =0; i < registros[index].size(); i++){
        temp+=registros[index][i];


        while(temp.size() < dataSizes[i]) temp+=NULO;

        ans+=temp;
        temp = "";
    }

    return ans;
}

bool Update::valuesAreValid() {

    for(int i =0; i < vals.size(); i++){

        if(isAttributMentioned[i]){

            if(dataTypes[i] == CHARS){
                if(vals[i].size()-2 > dataSizes[i])return false;
                if(vals[i][0] != '"' || vals[i][vals[i].size()-1] != '"')return false;
                vals[i] = vals[i].substr(1, vals[i].size()-1);
            }
        }
    }
    return true;
}

void Update::changeValues() {

    for(int i =0; i < registros.size(); i++){
        if(isValidRegistro[i]){

            for(int j =0; j < registros[i].size(); j++){
                if(isAttributMentioned[j]){
                    registros[i][j] = vals[j];
                }
            }
        }
    }
}
void Update::process() {

    vals = vector<string>(atributos.size());
    isAttributMentioned = vector<bool>(atributos.size(), false);
    getAtributosAndValues();


    if(valuesAreValid()) {

        changeValues();
        ostr.open("../" + tableName + ".txt");
        pbuf = ostr.rdbuf();
        for (int i = 0; i < registros.size(); i++) {
            if (isValidRegistro[i]) {
                writeNewBlock(i, getNewBlock(i));
            }
        }
        ostr.close();
    }else{
        throw invalid_argument("not valid values and/or attributes");
    }

}
