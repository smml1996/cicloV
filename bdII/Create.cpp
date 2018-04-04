//
// Created by Stefanie Muroya lei on 3/29/18.
//

#include "Create.h"
#include "Helpers.h"

#define CREATE "create"
#define WITH "with"
#define TYPES "types"
#define CHARS "char"
#define INTEGER "integer"
#define DATE "date"
#define UPDATE "update"
#define FROM "from"
#define WHERE "where"
#define DELETE "delete"
#define SELECT "select"
#define COMODIN "*"
#define VALUES "values"
#define INSERT "insert"
#define INTO "into"
#define C_AND "and"
#define C_OR "or"
#define DEF_TABLES_END "END_TABLES"
#define DEF_TABLES_BEGIN "BEGIN_TABLE"

using namespace std;



void Create::getAttributos() {

    cout << splittedComando.size() << endl;
    string temp;
    for(int i = 2; i < splittedComando.size(); i++){

        temp ="";
        int j =0; if(splittedComando[i][j] == '(' || splittedComando[i][j] == ',' || splittedComando[i][j] == ' ') j++;
        while(splittedComando[i][j] == ' ')j++;


        for(; j < splittedComando[i].size() && splittedComando[i][j] != ')' && splittedComando[i][j]!=' ' && splittedComando[i][j] !=',' ; j++){
            temp+= splittedComando[i][j];
        }

        if(temp.size() ==0) throw invalid_argument("check sintax lalla");

        atributos.push_back(temp);

        if(splittedComando[i][j] == ')') return;

    }
}

void Create::getDataTypes() {

    string temp;

    bool found = false;
    int i =4;
    for(; i < splittedComando.size(); i++){
        if(splittedComando[i] == WITH){
            found = true;
            break;
        }
    }

    if(!found) throw invalid_argument("check sintax");

    found = i+1 < splittedComando.size() && splittedComando[i+1] == TYPES;
    if(!found) throw invalid_argument("check sintax");

    i+=2;
    for(; i < splittedComando.size(); i++){
        temp = "";
        int j =0;
        for(; j < splittedComando[i].size(); j++){
            if(splittedComando[i][j]== ',' ) {
                if (temp == CHARS || temp == INTEGER || temp == DATE){

                    if(temp == CHARS){
                        string temp2 = "";

                        j++;
                        if(splittedComando[i][j]!=' [') throw invalid_argument("invalid sintax");
                        j++;
                        while(splittedComando[i][j]!= ']'){
                            temp2+=splittedComando[i][j];
                            j++;
                        }

                        int num = Helpers().getNumber(temp2);
                        while(num%8!=0) num++;
                        temp+='[';
                        temp+=Helpers().stringToNum(num);
                        temp+=']';
                    }
                    dataTypes.push_back(temp);
                }else
                    throw invalid_argument("not valid data-type");
                temp = "";
                }else if(splittedComando[i][j]!='(' && splittedComando[i][j] !=')'){
                temp+=splittedComando[i][j];
            }

            if(splittedComando[i][j] == ')'){
                dataTypes.push_back(temp);
                return;
            }
        }
    }

}

void Create::createTabla() {

    ofstream outfile;

    outfile.open("../metadata.txt", ios_base::app);

    outfile << DEF_TABLES_BEGIN << endl;
    outfile << tableName << endl;

    for(int i =0; i< atributos.size(); i++){
        outfile << atributos[i] << " " << dataTypes[i] << endl;
    }
    outfile << DEF_TABLES_END << endl;
    outfile.close();
}

void Create::process() {
    getAttributos();
    getDataTypes();
    if(dataTypes.size() != atributos.size()) throw invalid_argument("mismatch atributes and datatypes length");
    createTabla();
    output = "** TABLE CREATED **";
    cout << output << endl;
}
