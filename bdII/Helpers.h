//
// Created by Stefanie Muroya lei on 4/1/18.
//

#ifndef BDII_HELPERS_H
#define BDII_HELPERS_H

#include <iostream>
#include <string>
#include <vector>


using namespace std;

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

class Helpers {

public:
    static int getNumber(const string &s);
    static bool isNumber(const string &s);
    static bool isDate(const string &s);
    static bool isDateLess(const string &date1, const string &date2);
    static bool isDateEqual(const string &date1, const string &date2);
    static bool isDateGreater(const string &date1, const string &date2);
    static string stringToNum(const int &num);
};


#endif //BDII_HELPERS_H
