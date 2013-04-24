//
//  ofxSOInteractiveObject.h
//  emptyExample
//
//  Created by Shuya Okumura on 2013/04/18.
//
//

#pragma once

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"
#include "ofxAnimatableFloat.h"

enum ActionType {
    NOTHING = 0,
    TAPPED = 1, //
    DOUBLE_TAPPED = 2,
    HOLDED = 3
    //        DRAGING,
    //        DRAGED,
    //        SWIPED_LEFT,
    //        SWIPED_RIGHT,
    //        SWIPED_UP,
    //        SWIPED_DOWN,
    //        SCROLL_UP,
    //        SCROLL_DOWN
};

enum ObjectType {
    BUTTON = 0,//押したら戻るボタン normalとactionのみ
    TOGGLE = 1,//押したらONとOFFが切り替わり、そのまま保存されるボタン、true,falseを保持
    BOUNDING_BOX = 2,//バウンディングボックス
    TEXT_FIELD = 3
};

string getObjTypeString(unsigned int const& typeNo);
string getActionTypeString(unsigned int const& typeNo);

class ofxSOInteractiveObject : public ofRectangle {
    /*
     ボタンとか、インタラクティブに反応しうるオブジェクト.
     */
public:
    //仮想関数 touchPos は ページの座標 画面の座標ではない。
    virtual void subUpdate()=0;
    virtual void subDraw()=0;
    virtual void action(ActionType const& action, ofPoint const& touchPos)=0;
    virtual void inTouchDown(ofPoint const& touchPos) = 0;
    virtual void inTouchMoved(ofPoint const& touchPos)=0;
    virtual void inTouchUp(ofPoint const& touchPos)=0;
    virtual void touchOut()=0;
    virtual string getPrintStatus()=0;
    
    ofxSOInteractiveObject();
    bool isInside(float const& x, float const& y);
    bool isNameCorrect(string const& examinName);
    string getName() const {
        return name;
    }
    void update();
    void draw();
    
    //void setActive(bool const& active);
    
    ObjectType objType;
protected:
    //methods
    
    //members
    bool bDraw;
    bool bSet;//サブクラスでのセットアップが完了したらtrueを入れる。
    string name;
    
};