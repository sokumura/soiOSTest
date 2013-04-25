#pragma once

#include "ofxSOInteractiveObject.h"
#include "MyGlobal.h"

#define S_TIME 300
#define L_TIME 500
#define SLIDE_TIME 30

class ofxSOiOSEvents : public ofEventArgs {
public:
    ActionType type;
    ofPoint pos;
    int targetNum;
    //ofPoint distance;
    //int numTouches;
    static ofEvent <ofxSOiOSEvents> myCustomEventDispacher;
};

class ofxSOInteractivePage {
	
public:
    //methods
    virtual void subSetup()=0;
    virtual void subUpdate()=0;
    virtual void subDraw()=0;
    
    ofxSOInteractivePage(){
        bSet = false;
        counter = 0;
    }
    void setup(string const& _name, bool slidable, bool _bScrollable, bool _bHorizontalScrollable = false);
    virtual ~ofxSOInteractivePage();
    void update();
    void draw();
    
    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch);
    void touchUp(ofTouchEventArgs & touch);
    //void moveOut();
    
    void sliderSetup(AnimCurve const& inCurveMode, AnimCurve const& outCurveMode);
    ofPoint getPagePos() const{
        return pagePos;
    }
    
    const string getName() const {
        return this->name;
    }

//    bool getToggleStatus() const{
//        return bEnableTouch;
//    }
    
    void slidePageIn(){
        bSliding = true;
        pagePos.x = ofGetWidth();
        fAnimSlideIn.animateFromTo((float)ofGetWidth(), 0.0f);
    }
    void slidePageOut(){
        bSliding = true;
        fAnimSlideOut.animateFromTo(0.0f, (float)(-1) * ofGetWidth());
    }
    //members
    vector<ofxSOInteractiveObject *> buttons;//0はNULLにしておく
private:
    /////////members////////////
    string name;//ページ名
    bool bSet;//初期化されているかどうか。
    //touch関連
    unsigned long long startTime;//タッチがスタートした時間
    ofPoint touchStartPoint;//はじめにタッチしたポイント
    ofPoint touchPoint, exTouchPoint;//現在のタッチポイントと、以前のタッチポイント
    unsigned int downCount, moveCount, upCount;//タッチのカウンター
    bool bDowning;//現在がタッチ中であるかどうか
    int touchingTarget;//触れているボタンが有れば0以外、触れてなければ0
    
    //Pageの座標(スクロール,スライド)
    bool bSlidable;//スライドするかどうか。
    //bool bEnableTouch;//これがスイッチ
    bool bScrollable; //updateでのみ使う
    bool bScrolling, bHorizontalScrollable;
    bool bSliding;
    ofPoint pagePos, targetPagePos;//現在のページ座標と、ページ座標のゴール
    float pageWidth, pageHeight;
    ofxAnimatableFloat fAnimSlideIn, fAnimSlideOut;
    float dt;
    
    
    ///////////methods////////////
    
    
    void deviceOrientationChanged(int newOrientation);
    
    void tapped(ofPoint const& pos);
    void holded(ofPoint const& pos);
    void doubleTapped(ofPoint const& pos);
    void resetTouchAction();
    
    void touchEventGenerate();
    
    void sliderUpdate();
    void scrollUpadte();
    
    void setTouchingTarget(int const& index);
    
    inline ofPoint convertToPagePos(ofPoint const& devicePos){
        ofPoint ansPos = ofPoint();
        ansPos = devicePos - pagePos;
        return ansPos;
    }
    inline void limitPagePos() {
        pagePos.y = MAX(pagePos.y, ofGetHeight() - pageHeight);
        pagePos.y = MIN(pagePos.y, 0.0f);
    }
    
    int counter;
    
};



