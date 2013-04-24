//
//  test.h
//  emptyExample
//
//  Created by Shuya Okumura on 2013/04/04.
//
//

#pragma once
#include "ofxSOInteractivePage.h"

class testPage : public ofxSOInteractivePage {
public:
    testPage();
    ~testPage(){}
    void subSetup();
    void subUpdate();
    void subDraw();
};

