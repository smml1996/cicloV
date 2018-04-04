//
// Created by Stefanie Muroya lei on 3/29/18.
//

#ifndef BDII_COMANDO_H
#define BDII_COMANDO_H
#include <vector>
#include <string>
#include <sstream>
#include <fstream>
#include <queue>


using namespace std;



class Comando {
    void splitComando();
    void processComando();
    pair<int, int> getCharPosition(const int &index, const char & character);

    void getTokensCondicionLogica(const int &index);

    void getBlockSize();

    bool isKeyword(const string &k);

    void getDataSizes();

    bool isFragmented(int &index);

    string getLastBlock();

    void eraseLastBlock();

    void putBlock(const int index, const string block);

    void desfragmentar();

    void getRegistros();

public:
    explicit Comando(const string &comando);
    Comando();

    static int blockSize;
    static string comando;


protected:
    static vector<string> splittedComando;
    static queue<string> tokens;
    static vector< vector<string> > registros;
    static vector<int> dataSizes;
    static vector<bool> isValidRegistro;
    static string output;
    static string tableName;
    static vector<string> atributos;
    static vector<string> dataTypes;
    int getAttributeIndex(string attr);
    bool isNameValid(const string &name);
    bool isAttribute(const string &a);
    bool getTabla();
    pair<int, int> getOpeningParenthesis(const int &index);
    pair<int, int> getClosingParenthesis(const int &index);
    void getAnswerCondicionLogica(queue<string> &t, const int &op);


};

#endif //BDII_COMANDO_H
