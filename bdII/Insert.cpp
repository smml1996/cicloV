//
// Created by Stefanie Muroya lei on 3/29/18.
//

#include "Insert.h"
#include "Helpers.h"


void Insert::getAtributes() {

    string temp = "";

    string a = getStringAtributos();


    if(a[0] != '(') throw invalid_argument("not valid sintax");

    for(int i =1; i < a.size(); i++){
        if(a[i] == ',' ){
            int index = getAttributeIndex(temp);
            if(index != -1){
                isAttributedListed[index] = true;
                temp = "";
            }else{
                throw invalid_argument("not valid attributes listed");
            }
            temp = "";
        }else if(a[i] == ')'){
            int index = getAttributeIndex(temp);
            if(index != -1){
                isAttributedListed[index] = true;
                temp = "";
            }else{
                throw invalid_argument("not valid attributes listed");
            }

            return;
        }else
            temp+=a[i];

    }

}

string Insert::getStringAtributos() {

    string result = "";

    for(int i =3; i< splittedComando.size(); i++){
        if(splittedComando[i] == VALUES){
            indexValues = i;
            return result;
        }
        result+= splittedComando[i];
    }
    throw invalid_argument("no values found");
}

string Insert::getStringValues() {
    string result = "";

    indexValues++;

    for(; indexValues < splittedComando.size(); indexValues++){
        result+=splittedComando[indexValues];
    }

    return result;
}

void Insert::getValues() {

    string vals = getStringValues();
    if(vals[0] != '(') throw invalid_argument("invalid sintax");
    string temp;

    int j = 0;

    while(j < isAttributedListed.size() && !isAttributedListed[j])j++;


    for(int i = 1; i<vals.size(); i++){
        if(vals[i] == ','){
            if(values[j] != NULO) throw invalid_argument("not valid values");
            values[j] = temp;
            j++;
            while( j < isAttributedListed.size() && !isAttributedListed[j])j++;
            temp ="";

        }else if(vals[i] == ')'){
            if(values[j] != NULO) throw invalid_argument("not valid values");
            values[j] = temp;
            return;
        }else{
            temp+=vals[i];
        }
    }

}

bool Insert::valuesAreValid() {
    for(int i =0; i < values.size(); i++){
        if(values[i] != NULO){
            if(dataTypes[i].substr(0,4) == CHARS){
                if(values[i].size()-2> dataSizes[i]) return false;
                if(values[i][0] != '"' || values[i][values[i].size()-1] != '"') return false;
                values[i] = values[i].substr(1, values[i].size()-2);
            }else if(dataTypes[i] == DATE ){

                if(!Helpers::isDate(values[i]))
                    return false;
            }else if(!Helpers().isNumber(values[i])){
                return false;
            }
        }
    }

    return true;
}


void Insert::process() {


    isAttributedListed = vector<bool>(atributos.size(), false);
    values = vector<string>(isAttributedListed.size(), NULO);
    getAtributes();

    getValues();

    ofstream outfile;

    string file = "../"+tableName +".txt";

    outfile.open(file, ios_base::app);

    string toSave = "";
    string temp;

    if(valuesAreValid()){
        for(int i =0; i < atributos.size(); i++){
            if(isAttributedListed[i]){
                temp = values[i];
            }else{
                temp = NULO;
            }

            while(temp.size() < dataSizes[i]) temp+=NULO;

            toSave+=temp;
        }
    }else{
          cout<< "values not valid" << endl;
    }



    outfile << toSave;

    outfile.close();

}
