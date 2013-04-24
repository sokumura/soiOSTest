#include "ofxSOInteractivePage.h"

ofEvent<ofxSOiOSEvents> ofxSOiOSEvents::myCustomEventDispacher;

//--------------------------------------------------------------
void ofxSOInteractivePage::setup(string const& _name, bool slidable, bool _bScrollable, bool _bHorizontalScrollable){
    this->name = _name;
    bScrollable = _bScrollable;
    bHorizontalScrollable = _bHorizontalScrollable;
    bSlidable = slidable;
    
    startTime = 0;
    downCount = moveCount = upCount = 0;
    touchPoint.set(0, 0);
    pagePos.set(0.0f, 0.0f);
    targetPagePos.set(0.0f, 0.0f);
    bDowning = false;
    touchingTarget = 0;
    
    pagePos.set(0.0f, 0.0f);
    pageWidth = ofGetWidth();
    pageHeight = ofGetHeight() * 2.0f;
    bSliding = false;
    
    //button
    buttons.push_back(NULL);//0にNULLを入れておく
    
    //slidePage animation
    sliderSetup(EASE_OUT, EASE_IN);
    dt = 1.0f / SLIDE_TIME;
    
    subSetup();
    
    bSet = true;
    
}
void ofxSOInteractivePage::sliderSetup(AnimCurve const& inCurveMode, AnimCurve const& outCurveMode){
    fAnimSlideIn.setCurve(inCurveMode);
    fAnimSlideOut.setCurve(outCurveMode);
}
//--------------------------------------------------------------
ofxSOInteractivePage::~ofxSOInteractivePage(){
    cout << name << " デストラクタ called" << endl;
}
//--------------------------------------------------------------
void ofxSOInteractivePage::sliderUpdate(){
    if (fAnimSlideIn.isAnimating()) {//fAnimSlideIn が動いていたら
        fAnimSlideIn.update(dt);
        pagePos.x = fAnimSlideIn.getCurrentValue();
    } else if (fAnimSlideOut.isAnimating()) {//fAnimSlideOut が動いていたら
        fAnimSlideOut.update(dt);
        pagePos.x = fAnimSlideOut.getCurrentValue();
    } else if (fAnimSlideIn.hasFinishedAnimating() && bSliding){//fAnimSlideInが終了したら
        bSliding = false;
        //?Eventをここにいれる
        cout << name << " slide in が終了" << endl;
    } else if (fAnimSlideOut.hasFinishedAnimating() && bSliding){//終了して1フレーム目
        bSliding = false;
        //?Eventをここにいれる。
        cout << name << " slide out が終了" << endl;
    }
}
//--------------------------------------------------------------
void ofxSOInteractivePage::scrollUpadte(){
    if (bHorizontalScrollable) {//水平の推移が必要な場合
        pagePos.x -= (targetPagePos.x - pagePos.x) / 3.0f;
    }
    pagePos.y -= (targetPagePos.y - pagePos.y) / 10.0f;
    limitPagePos();
}
//--------------------------------------------------------------
void ofxSOInteractivePage::touchEventGenerate(){
    if (startTime == 0) return;
    unsigned int time = ofGetElapsedTimeMillis() - startTime;
    if (moveCount == 0) {//touchMovedが呼ばれていないとき
        if (time > L_TIME) {//L_TIME以上になったら
            if (downCount == 1 && upCount == 0) {//downされたまま
                holded(touchPoint);
                resetTouchAction();
            } else {//
                cout << name << "touchEvent make NOTHING, because of time over." << endl;
                resetTouchAction();
            }
        } else if (time > S_TIME) {//S_TIME < time < L_TIME に入ったとき
            if (downCount == 1 && upCount == 1) {
                tapped(touchPoint);
                resetTouchAction();
            } if (downCount == 2 && upCount == 2) {
                doubleTapped(touchPoint);
                resetTouchAction();
            }
        }
    } else resetTouchAction();//
}
//--------------------------------------------------------------
void ofxSOInteractivePage::update(){
    //if (counter % 1000 == 0) cout << "page.update() is called" << endl;
    //debug
    if (!bSet) {
        ofLogError(name + " ofxSOInteractivePage::setup() が呼ばれてないよ。");
        return;
    }
    counter++;
    //Sliding
    if (bSlidable) sliderUpdate();
    //scroll移動
    if (pagePos.distance(targetPagePos) > 1.0f) scrollUpadte();
    //touchEvent
    touchEventGenerate();
    //サブクラスのupdate()
    subUpdate();
    for (int i = buttons.size() - 1; i > 0; i--) {
        buttons[i]->update();
    }

}
//--------------------------------------------------------------
void ofxSOInteractivePage::draw(){
    ofPushMatrix();
    ofTranslate(pagePos.x, pagePos.y);
    subDraw();
    for (int i = buttons.size() - 1; i > 0; i--) {
        buttons[i]->draw();
    }
    ofEnableAlphaBlending();
    ofSetColor(255, 0, 0, 100);
    ofCircle(touchPoint.x, touchPoint.y, 10.0f);
    ofPopMatrix();
}
//--------------------------------------------------------------
void ofxSOInteractivePage::resetTouchAction(){/*パラメータの初期化*/
    startTime = 0;
    downCount = moveCount = upCount = 0;
    bDowning = false;
    setTouchTarget(0);
    touchPoint = exTouchPoint = ofPoint(0,0);
}

//--------------------------------------------------------------
//--------------------------------------------------------------
//--------------------------------------------------------------
//--------------------------------------------------------------
//--------------------------------------------------------------
//--------------------------------------------------------------
void ofxSOInteractivePage::touchDown(ofTouchEventArgs & touch){
    //座標をpageの座標に変更する。
    cout << "touchDown" << endl;
    touchPoint = touchStartPoint = convertToPagePos(ofPoint(touch.x, touch.y));
    
    bDowning = true;
    if (downCount == 0) {//それ以前にdonwCountが呼ばれてなかったら
        startTime = ofGetElapsedTimeMillis();//startTimeをリニューアル
    }
    for (int i = buttons.size() - 1; i > 0; i--) {//ボタンを捜査
        bool status = buttons[i]->inside(touchPoint);
        if (status) {
            setTouchTarget(i);
            buttons[touchingTarget]->inTouchDown(touchPoint);
        }
    }
    
    if (touchingTarget == 0 && bSlidable) bScrolling = true;
    else bScrolling = false;
    
    downCount++;
    exTouchPoint = touchPoint;
}

//--------------------------------------------------------------
void ofxSOInteractivePage::touchMoved(ofTouchEventArgs & touch){
    touchPoint = convertToPagePos(ofPoint(touch.x, touch.y));
    //? 途中
    if (bScrolling) {
        //targetPagePos -= (touchPoint - exTouchPoint);
        //cout << "targetPagePos += (touchPoint - exTouchPoint) →" << targetPagePos.y << " += (" << touchPoint.y << " - " << exTouchPoint.y << ")" << endl;
        if (touchStartPoint.y != 0) {
            if (touchStartPoint.y > touchPoint.y) {
                targetPagePos.y -= 2.0f;
            } else if (touchStartPoint.y < touchPoint.y) {
                targetPagePos.y += 2.0f;
            }
        }
    }
    moveCount++;
    
    if (touchingTarget != 0) {
        buttons[touchingTarget]->inTouchMoved(touchPoint);
        if (!buttons[touchingTarget]->isInside(touchPoint.x, touchPoint.y)) {//ターゲットが存在して、そのターゲットを離れたとき
            buttons[touchingTarget]->touchOut();
        }
    }
    exTouchPoint = touchPoint;
}

//--------------------------------------------------------------
void ofxSOInteractivePage::touchUp(ofTouchEventArgs & touch){
    touchPoint = convertToPagePos(ofPoint(touch.x, touch.y));
    bDowning = false;
    bScrolling = false;
    if(downCount != 0)
        upCount++;
    else
        downCount = moveCount = upCount = 0;
    if (touchingTarget != 0) {
        buttons[touchingTarget]->inTouchUp(touchPoint);
    }
    touchPoint = ofPoint(0, 0);
}
//--------------------------------------------------------------
//--------------------------------------------------------------
//--------------------------------------------------------------
void ofxSOInteractivePage::tapped(ofPoint const& pos){
    //cout << name << " ofxSOInteractivePage::tapped()" << endl;
    if (touchingTarget != 0) {
        //cout << "buttons[ " << touchingTarget << " ]にTAPPED, touchPoint : " << touchPoint.x << ", " << touchPoint.y << "を送った" << endl;
        buttons[touchingTarget]->action(TAPPED, touchPoint);
    } else ;//cout << "no object" << endl;
    resetTouchAction();
}
//--------------------------------------------------------------
void ofxSOInteractivePage::holded(ofPoint const& pos){
    //cout << name << " ofxSOInteractivePage::holded()" << endl;
    if (touchingTarget != 0) {
        buttons[touchingTarget]->action(HOLDED, touchPoint);
    } else cout << "no object" << endl;
    resetTouchAction();
    //cout << "pagePos x : " << pagePos.x << ", y : " << pagePos.y << endl;
    cout << buttons[1]->getPrintStatus() << endl;
}
//--------------------------------------------------------------
void ofxSOInteractivePage::doubleTapped(ofPoint const& pos){
    //cout << name << " ofxSOInteractivePage::doubleTapped()" << endl;
    if (touchingTarget != 0) {
        buttons[touchingTarget]->action(DOUBLE_TAPPED, touchPoint);
    } else cout << "no object" << endl;
    resetTouchAction();
}
//--------------------------------------------------------------
//--------------------------------------------------------------
//void ofxSOInteractivePage::toggleOfTouchEvent(bool beActiveEvent){
//    bEnableTouch = beActiveEvent;
//    if (bEnableTouch) {
//        enableTouchEvents();
//    } else {
//        disableTouchEvents();
//    }
//}
////--------------------------------------------------------------
//void ofxSOInteractivePage::enableTouchEvents(){
//    ofAddListener(ofEvents().touchDown, this, &ofxSOInteractivePage::_touchDown);
//    ofAddListener(ofEvents().touchMoved, this, &ofxSOInteractivePage::_touchMoved);
//    ofAddListener(ofEvents().touchUp, this, &ofxSOInteractivePage::_touchUp);
//    bEnableTouch = true;
//}
////--------------------------------------------------------------
//void ofxSOInteractivePage::disableTouchEvents(){
//    ofRemoveListener(ofEvents().touchDown, this, &ofxSOInteractivePage::_touchDown);
//    ofRemoveListener(ofEvents().touchMoved, this, &ofxSOInteractivePage::_touchMoved);
//    ofRemoveListener(ofEvents().touchUp, this, &ofxSOInteractivePage::_touchUp);
//    bEnableTouch = false;
//}
//--------------------------------------------------------------