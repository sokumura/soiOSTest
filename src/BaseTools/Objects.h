//
//  File.h
//  emptyExample
//
//  Created by Shuya Okumura on 2013/04/17.
//
//

#pragma once

#include "ofxSOInteractiveObject.h"
#include "ofxTrueTypeFontUC.h"
#include "MyGlobal.h"
/*
 folderPass の中身は
 normal.png
 active.png
 activeBg.png
 targetMask.png
 
 になっていること
 */

class BoundingBox : public ofxSOInteractiveObject {
public:
    BoundingBox() : ofxSOInteractiveObject(){}
    void setup(vector<string> const& _texts,
                string const& _name,
                float const& X, float const& Y,
                float const& W, float const& H,
                string const& folderPass);
    //仮想関数の実体
    void subUpdate();
    void subDraw();
    void action(ActionType const& action, ofPoint const& touchPos);
    void inTouchDown(ofPoint const& touchPos);
    void inTouchMoved(ofPoint const& touchPos);
    void inTouchUp(ofPoint const& touchPos);
    void touchOut();
    string getPrintStatus(){
        string ans;
        ans = "opening : " + soToString(opening) + "\n";
        return ans;
    }
    //
    void setTarget(ofPoint const& touchPoint);
    bool getOpening()const{
        return opening;
    }
    void print(){
        cout << "BoundingBox::print()\nnum : " << num <<
        "\nname : " << name <<
        "\nobjType : " << getObjTypeString(objType) <<
        "\ntargetNo : " << targetNo << endl;
        for (int i = 0; i < texts.size(); i++) {
            cout << texts[i] << endl;
        }
        cout << "openning : " << soToString(opening) <<
        "\n//BoundingBox::print()" <<endl;
    }
private:
    unsigned int num, targetNo;
    vector <string> texts;
    bool exopening;
    bool opening;
    float normalHeight;
    ofImage normalImg;
    ofImage activeImg;
    ofImage targetMask;
    ofImage activeBg;
    ofxTrueTypeFontUC fonts;
    
    //methods
    void tapped(ofPoint const& touchPos);
    void open();
    void close();
    
int counter;
};