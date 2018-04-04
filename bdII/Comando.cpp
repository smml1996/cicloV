//
// Created by Stefanie Muroya lei on 3/29/18.
//


#include "Comando.h"
#include "Helpers.h"
#include "Interface.h"


#include <iostream>


int Comando::blockSize = 0;
string Comando::comando = "";
string Comando::output = "";
string Comando::tableName = "";

vector<vector<string>> Comando::registros = vector< vector<string> >();
vector<string> Comando::dataTypes = vector<string>();
vector<string> Comando::atributos = vector<string>();
vector<bool> Comando::isValidRegistro = vector<bool>();
vector<int> Comando::dataSizes = vector<int>();
queue<string> Comando::tokens = queue<string>();
vector<string> Comando::splittedComando = vector<string>();



using namespace std;
Comando::Comando(const string &c){
    registros.clear();
    dataTypes.clear();
    atributos.clear();
    isValidRegistro.clear();
    dataSizes.clear();
    while(!tokens.empty())tokens.pop();
    splittedComando.clear();
    comando = c;
    blockSize = 0;
    splitComando();
    processComando();
}

Comando::Comando(){

};

void Comando::splitComando(){
    string temp;
    for(int i =0; i < comando.size(); ){
        temp = "";
        while(i < comando.size() && comando.at(i) != ' ' ){

            if(comando.at(i) >= 'A' && comando.at(i) <= 'Z'){
                temp+= comando[i] - 'A' + 'a';
            }else{
                temp += comando[i];
            }
            i++;
        }
        splittedComando.push_back(temp);
        while(i < comando.size() && comando.at(i) == ' ' )i++;

    }
}

void Comando::processComando(){

    if(splittedComando.size() > 2 && splittedComando[0] == CREATE){

        tableName = splittedComando[1];
        if(!isNameValid(tableName)) throw invalid_argument("not valid table name");
        if(!getTabla()){
             Interface interface(0);
        }else{
            throw invalid_argument("table already exists");
        }
    }else if(2 < splittedComando.size() && splittedComando[0] == UPDATE && splittedComando[1] == FROM){

        tableName = splittedComando[2];
        if(!isNameValid(tableName)) throw invalid_argument("not valid table name");

        if(getTabla()){

            getDataSizes();

            getBlockSize();

            getRegistros();

            isValidRegistro = vector<bool> (registros.size(), true);

            int whereIndex = 0;

            for(; whereIndex < splittedComando.size() && splittedComando[whereIndex]!= WHERE; whereIndex++);
            if(whereIndex >= splittedComando.size()) throw invalid_argument("invalid sintax");
            getTokensCondicionLogica(whereIndex+1);

            if(tokens.size() >0)
                getAnswerCondicionLogica(tokens,0);
            Interface anInterface(1);
        }

    }else if(3 < splittedComando.size() && splittedComando[0] == SELECT  && splittedComando[1] == COMODIN && splittedComando[2] == FROM){

        tableName = splittedComando[3];
        if(!isNameValid(tableName)) throw invalid_argument("not valid table name");

        if(getTabla()){

            getDataSizes();
            getBlockSize();
            getRegistros();
            isValidRegistro = vector<bool> (registros.size(), true);
            getTokensCondicionLogica(5);


            if(tokens.size() > 0)
                getAnswerCondicionLogica(tokens, 0);
            Interface anInterface(2);
        }else throw invalid_argument("not valid table name");


    }else if(2 < splittedComando.size() && DELETE == splittedComando[0] && splittedComando[1] == FROM){
        tableName = splittedComando[2];
        if(!isNameValid(tableName)) throw invalid_argument("not valid table name");

        if(getTabla()){
            getDataSizes();
            getBlockSize();
            getRegistros();
            isValidRegistro = vector<bool> (registros.size(), true);
            cout << registros.size() << endl;
            getTokensCondicionLogica(4);
            if(tokens.size() > 0)
                getAnswerCondicionLogica(tokens,0);
            Interface anInterface(3);
            desfragmentar();
        }


    }else if(2 < splittedComando.size() && splittedComando[0] == INSERT && splittedComando[1] == INTO){
        tableName = splittedComando[2];
        if(!isNameValid(tableName)) throw invalid_argument("not valid table name");
        if(getTabla()){
            getDataSizes();
            Interface anInterface(4);
        }
    }else{
        throw invalid_argument("invalid sintax");
    }
}

pair<int, int> Comando::getCharPosition(const int &index, const char &character) {

    for(int i = index+1; i < splittedComando.size(); i++){

        for(int j =0; j< splittedComando[i].size(); i++){
            if(character == splittedComando[i][j]) return make_pair(i, j);
        }
    }

    return make_pair(-1,-1);
}

pair<int, int> Comando::getClosingParenthesis(const int &index) {

    return getCharPosition(index, ')');
}

pair<int, int> Comando::getOpeningParenthesis(const int &index) {

    return getCharPosition(index, '(');
}

bool Comando::isNameValid(const string &name) {
    if(name[0] >= '0' && name[0] <= '9') return false;
    return true;
}

bool Comando::getTabla(){

    string line;

    ifstream infile("../metadata.txt");
    int count;
    while(getline(infile, line)){

        if(line == DEF_TABLES_BEGIN){

            if(getline(infile, line)){
                if(line == tableName){

                    while(getline(infile, line) && line != DEF_TABLES_END){
                        string temp;
                        count = 0;

                        for(int i = 0; i < line.size(); i++){
                            if(line[i] == ' ' && count == 0){
                                atributos.push_back(temp);
                                count++;
                                temp = "";
                            }else{
                                temp+=line[i];
                            }
                        }
                        dataTypes.push_back(temp);
                    }
                    return true;
                }
            }
        }

    }

    return false;


}

bool Comando::isKeyword(const string &k) {

    if(k == C_AND) return true;
    return k == C_OR;
}

bool Comando::isAttribute(const string &a) {

    for(int i =0; i < atributos.size(); i++){
        if(atributos[i] == a) return true;
    }

    return false;
}

void Comando::getTokensCondicionLogica(const int &index) {
    string temp;
    for(int i = index; i<splittedComando.size(); i++){

        for(int j =0; j < splittedComando[i].size(); ){
            if(temp == "(" || temp == ")" || temp =="=" || temp == "<" || temp == ">") {
                tokens.push(temp);
                temp = "";

            }else if(isKeyword(temp) || isAttribute(temp) || Helpers::isNumber(temp)){
                tokens.push(temp);
                temp ="";
            }else if( splittedComando[i][j] != ' '){
                temp += splittedComando[i][j];
                j++;

            }else{
                throw invalid_argument("Not valid condition");

            }

        }

    }

    if(temp.size() > 0 && (isKeyword(temp) || isAttribute(temp) || Helpers::isNumber(temp))){
        tokens.push(temp);
    }else if(temp.size() != 0){
        throw invalid_argument("not valid condition");
    }
}

void Comando::getAnswerCondicionLogica(queue<string> &t, const int &op) {

    queue<string> temp;
    int count = 0;
    string f;
    while(!t.empty()){
        f = t.front();
        temp.push(f);
        t.pop();

        if(t.front() == C_AND){
            getAnswerCondicionLogica(temp, op);
            t.pop();
            getAnswerCondicionLogica(t,1);
        }else if(t.front()  == ")"){
            count++;
        }else if(t.front() =="("){
            count--;
            if(count == 0){
                getAnswerCondicionLogica(temp, op);
                t.pop();
                getAnswerCondicionLogica(t,op);
            }
        }else if(t.front() == C_OR){
            getAnswerCondicionLogica(temp,op);
            t.pop();
            getAnswerCondicionLogica(t,2);
        }else if(t.front() == ">"){
            t.pop();
            int indexLeftAtt = getAttributeIndex(t.front()), indexRightAtt = getAttributeIndex(temp.front());

            int leftNumber = -1, rightNumber =-1;

            if(indexLeftAtt == -1){
                leftNumber = Helpers().getNumber(t.front());
            }

            if(indexRightAtt == -1) rightNumber = Helpers().getNumber(temp.front());

            bool value;
            for(int i =0; i < registros.size(); i++){

                if(indexLeftAtt != -1){
                    leftNumber = Helpers().getNumber(registros[i][indexLeftAtt]);
                }

                if(indexRightAtt !=-1){
                    rightNumber = Helpers().getNumber(registros[i][indexRightAtt]);
                }
                value = leftNumber >  rightNumber;
                if(op == 1){
                    isValidRegistro[i] = isValidRegistro[i] && value;
                }else if(op == 2){
                    isValidRegistro[i] = isValidRegistro[i] || value;
                }else{
                    isValidRegistro[i] = value;
                }
            }

            t.pop();

        }else if(t.front() == "<"){
            t.pop();
            int indexLeftAtt = getAttributeIndex(t.front()), indexRightAtt = getAttributeIndex(temp.front());
            int leftNumber = -1, rightNumber =-1;

            if(indexLeftAtt == -1){
                leftNumber = Helpers().getNumber(t.front());
            }

            if(indexRightAtt == -1) rightNumber = Helpers().getNumber(temp.front());

            bool value;
            for(int i =0; i < registros.size(); i++){

                if(indexLeftAtt != -1){
                    leftNumber = Helpers().getNumber(registros[i][indexLeftAtt]);
                }

                if(indexRightAtt !=-1){
                    rightNumber = Helpers().getNumber(registros[i][indexRightAtt]);
                }
                value = leftNumber < rightNumber;
                if(op == 1){
                    isValidRegistro[i] = isValidRegistro[i] && value;
                }else if(op == 2){
                    isValidRegistro[i] = isValidRegistro[i] || value;
                }else{
                    isValidRegistro[i] = value;
                }
            }
            t.pop();

        }else if(t.front() == "="){
            t.pop();
            int indexLeftAtt = getAttributeIndex(temp.front()), indexRightAtt = getAttributeIndex(t.front());

            int leftNumber = -1, rightNumber =-1;

            if(indexLeftAtt == -1){
                leftNumber = Helpers::getNumber(temp.front());
            }


            if(indexRightAtt == -1) rightNumber = Helpers::getNumber(t.front());

            bool value;
            for(int i =0; i < registros.size(); i++){

                if(indexLeftAtt != -1){
                    cout << registros[i][indexLeftAtt] << ": "<< registros[i][indexLeftAtt].size()<< endl;
                    leftNumber = Helpers::getNumber(registros[i][indexLeftAtt]);
                }

                if(indexRightAtt !=-1){
                    rightNumber = Helpers::getNumber(registros[i][indexRightAtt]);
                }
                value = leftNumber ==  rightNumber;
                if(op == 1){
                    isValidRegistro[i] = isValidRegistro[i] && value;
                }else if(op == 2){
                    isValidRegistro[i] = isValidRegistro[i] || value;
                }else{
                    isValidRegistro[i] = value;
                }
            }
            t.pop();

        }else{
            throw invalid_argument("not valid logical condition");
        }

    }
}

int Comando::getAttributeIndex(string attr) {

    for(int i =0; i < atributos.size(); i++){
        if(atributos[i] == attr) return i;
    }

    return -1;
}

void Comando::getBlockSize() {

    for(int i =0; i < dataSizes.size(); i++){
        blockSize+=dataSizes[i];
    }
}

void Comando::getDataSizes() {

    for(int i =0; i < dataTypes.size(); i++){
        if(dataTypes[i]== INTEGER || dataTypes[i] == DATE){
            dataSizes.push_back(8);
        }else{
            dataSizes.push_back(Helpers().getNumber(dataTypes[i].substr(5,dataTypes[i].size()-1 )));
        }
    }

}

void Comando::getRegistros() {


    string file = "../"+tableName +".txt";

    ifstream istr (file);
    char empty[] = "";
    char* contents;
    if (istr) {
        streambuf *pbuf = istr.rdbuf();
        pbuf->pubseekoff(0, istr.beg);
        int i = 0;
        while(pbuf->snextc() != EOF){
            pbuf->pubseekpos(blockSize * i);

            contents = new char[blockSize];

            pbuf->sgetn(contents, blockSize);
            cout << contents << endl;
            i++;
            char empty[]=" ";
            if(strncmp(contents, empty, 1 ) != 0){
                string temp = contents;

                registros.push_back(vector<string>());
                int acum=0;

                string final;
                for(int j =0; j<atributos.size();j++){
                    final = "";
                    string temp2 = temp.substr(acum, dataSizes[j]);
                    acum+=dataSizes[j];

                        for(int  k = 0; k < temp2.size(); k++){
                            if(temp[k]!='/'){
                                final+=temp2[k];
                            }else{
                                break;
                            }
                        }


                    registros[registros.size()-1].push_back(final);
                }
            }
        }

    }
}

bool Comando::isFragmented(int &index) {

    string file = "../"+tableName +".txt";
    ifstream istr (file);

    char empty[]= " ";
    char* contents;
    contents = new char[blockSize+1];
    contents[blockSize] = '\0';
    if (istr) {
        streambuf *pbuf = istr.rdbuf();
        //pbuf->pubseekoff(0, istr.beg);
        index = 0;
        while(pbuf->sgetc() != EOF ){
            pbuf->pubseekpos(blockSize * index);


            pbuf->sgetn(contents,blockSize);
            cout << contents << endl;

            if(strncmp(contents, empty,1) ==0){
                return true;
            }
            index++;

        }
        delete[] contents;
        istr.close();

    }
    return false;
}

void Comando::eraseLastBlock() {
    string file = "../"+tableName +".txt";
    std::fstream ostr (file);
    std::streambuf * pbuf = ostr.rdbuf();
    long fileSize = pbuf->pubseekoff(0,ostr.end);
    pbuf->pubseekpos(fileSize - blockSize);

    char liquidPaper[blockSize+1];

    for(int i = 0; i < blockSize; i++){
        liquidPaper[i] = ' ';
    }
    liquidPaper[blockSize] = '\0';

    pbuf->sputn (liquidPaper,sizeof(liquidPaper)-1);
    ostr.close();

}

string Comando::getLastBlock() {
    string file = "../"+tableName +".txt";
    std::fstream ostr (file);
    std::streambuf * pbuf = ostr.rdbuf();

    long fileSize = pbuf->pubseekoff(0,ostr.end);

    cout << fileSize << endl;
    pbuf->pubseekpos( fileSize -  blockSize);

    char liquidPaper[blockSize+1];

    liquidPaper[blockSize] = '\0';

    pbuf->sgetn (liquidPaper,blockSize);

    string ans = liquidPaper;
    ostr.close();
    return ans;
}

void Comando::putBlock(const int index, const string block) {
    string file = "../"+tableName +".txt";
    std::fstream ostr (file);
    std::streambuf * pbuf = ostr.rdbuf();
    pbuf->pubseekpos(index*blockSize);

    char finalB[block.size()+1];

    for(int i =0; i < block.size(); i++){
        finalB[i] = block[i];
    }
    finalB[block.size()] = '\0';
    pbuf->sputn (finalB,sizeof(finalB)-1);
    ostr.close();
}


void Comando::desfragmentar() {

    int index = 0;
    string temp;
    while(isFragmented(index)){
        temp = getLastBlock();
        if(temp[0] == ' ')return;
        putBlock(index, temp);
        eraseLastBlock();
    }
}
