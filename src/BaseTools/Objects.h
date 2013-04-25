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

#define DERAY 100

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
                string const& folderPass,
                bool defaultExistance);
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
    void print();
private:
    unsigned long long stopWatch;
    unsigned int choiceNum, choiceTargetNo;
    vector <string> texts;
    bool opening;
    bool bDefaultExist;
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
    
    void setChoiceTarget(ofPoint const& touchPoint);
    
    StopWatch derayTimer;
    
int counter;
};