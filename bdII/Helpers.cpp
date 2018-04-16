//
// Created by Stefanie Muroya lei on 4/1/18.
//

#include "Helpers.h"



using namespace std;

int Helpers::getNumber(const string  &number){
    if(number.size() == 0) throw invalid_argument("not a number");
    int result =0;

    int i =0;
    bool isNegative = number.at(i) == '-';
    if(isNegative)i++;

    for(; i< number.size(); i++){
        if(number.at(i) >= '0' && number.at(i) <='9'){
            result+= number.at(i)- '0';
            if(i!= number.size()-1) result*=10;
        }else{
            throw invalid_argument("Not a number");
        }
    }

    if(isNegative) result*=-1;
    return result;
}

bool Helpers::isNumber(const string &number){
    try {
        int t = getNumber(number);
        return true;

    }catch(exception e) {
        return false;
    }

}

bool Helpers::isDate(const string &date){

    if(date.size()!=8) return false;

    if(!isNumber(date.substr(0,2)) || !isNumber(date.substr(3,2)) || !isNumber(date.substr(6))) return false;
    return !(date[2] != '/' || date[5] != '/');
}

bool Helpers::isDateLess(const string &date1, const string &date2){
    if(getNumber(date1.substr(0,2)) < getNumber(date2.substr(0,2))) return true;
    else if(getNumber(date1.substr(3,2)) < getNumber(date2.substr(3,2))) return true;
    else if(getNumber(date1.substr(6)) < getNumber(date2.substr(6))) return true;
    return false;
}

bool Helpers::isDateEqual(const string &date1, const string &date2){
    return date1 == date2;
}

bool Helpers::isDateGreater(const string &date1, const string &date2){
    if(isDateEqual(date1, date2)) return false;
    return !isDateLess(date1, date2);
}

string Helpers::stringToNum(const int &num){
    string ans = "";

    while(num>0){
        ans+= (char) ((num%10) - '0');
    }
    reverse(ans.begin(), ans.end());
    return ans;
}
