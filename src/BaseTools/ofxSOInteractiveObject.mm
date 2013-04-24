//
//  ofxSOInteractiveObject.mm
//  emptyExample
//
//  Created by Shuya Okumura on 2013/04/18.
//
//

#include "ofxSOInteractiveObject.h"

string getObjTypeString(unsigned int const& typeNo){
    string ans = "";
    switch (typeNo) {
        case 0:
            ans = " BUTTON ";
            break;
        case 1:
            ans = " TOGGLE ";
            break;
        case 2:
            ans = " BOUNDING_BOX ";
            break;
        case 3:
            ans = " TEXT_FIELD ";
            break;
        default:
            ans = " UnknownObjType!!!! ";
            break;
    }
    return ans;
}

string getActionTypeString(unsigned int const& typeNo){
    string ans = "";
    switch (typeNo) {
        case 0:
            ans = " NOTHING ";
            break;
        case 1:
            ans = " TAPPED ";
            break;
        case 2:
            ans = " DOUBLE_TAPPED ";
            break;
        case 3:
            ans = " HOLDED ";
            break;
        default:
            ans = " UnknownActionType!!!! ";
            break;
    }
    return ans;
}

//-------------------------------------------------------
ofxSOInteractiveObject::ofxSOInteractiveObject() : ofRectangle(){
    name = "";
    bSet = false;
}
//-------------------------------------------------------
bool ofxSOInteractiveObject::isInside(float const& x, float const& y){
    if (!bSet) {
        cout << name << "ofxSOInteractiveObject::bSet is false." << endl;
        return false;
    }
    return ofRectangle::inside(x, y);
}
//-------------------------------------------------------
bool ofxSOInteractiveObject::isNameCorrect(string const& examinName){
    if (!bSet) {
        cout << name << "ofxSOInteractiveObject::bSet is false." << endl;
        return NULL;
    }
    return name == examinName;
}
//-------------------------------------------------------
void ofxSOInteractiveObject::update(){
    if (!bSet) {
        cout << name << "のsetup()が呼ばれていません." << endl;
        return;
    }
    subUpdate();
}
//-------------------------------------------------------
void ofxSOInteractiveObject::draw(){
    if (!bSet) {
        cout << name << "のsetup()が呼ばれていません." << endl;
        return;
    }
    subDraw();
}
//----------------------------------------------------


