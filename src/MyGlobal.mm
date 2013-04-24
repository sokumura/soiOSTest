//
//  MyGlobal.mm
//  emptyExample
//
//  Created by Shuya Okumura on 2013/04/19.
//
//

#include "MyGlobal.h"

string soToString(bool b){
    if (b) {
        return "TRUE";
    } else {
        return "FALSE";
    }
}

void CheckBool(bool Status, string const& testName){
    string m = testName;
    m += " : ";
    if (Status) {
        m += "SUCCESSED!!";
    } else {
        m += "FAILURE!!";
    }
    cout << m << endl;
}