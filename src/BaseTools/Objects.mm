//
//  File.mm
//  emptyExample
//
//  Created by Shuya Okumura on 2013/04/17.
//
//

#include "Objects.h"


///////////////////////////////////////
//////BoundingBox////public////////////
///////////////////////////////////////
void BoundingBox::setup(vector<string> const& _texts,
                        string const& _name,
                        float const& X, float const& Y,
                        float const& W, float const& H,
                        string const& folderPass,
                        bool defaultExistance){
    
    counter = 0;
    
    derayTimer = StopWatch("derayTimer");
    
    objType = BOUNDING_BOX;
    ofRectangle::set(X, Y, W, H);
    this->name = _name;
    texts = _texts;
    choiceNum = texts.size();
    opening = false;
    normalHeight = H;
    
    normalImg.allocate(W, H, OF_IMAGE_COLOR_ALPHA);
    activeImg.allocate(W, H, OF_IMAGE_COLOR_ALPHA);
    activeBg.allocate(W, H, OF_IMAGE_COLOR_ALPHA);
    targetMask.allocate(W, H, OF_IMAGE_COLOR_ALPHA);
    bool status = normalImg.loadImage(folderPass + "/normal.png");
    CheckBool(status, "BoundingBox::setup() normalImg.loadIage");
    status = activeImg.loadImage(folderPass + "/active.png");
    CheckBool(status, "BoundingBox::setup() activeImg.loadIage");
    status = activeBg.loadImage(folderPass + "/activeBg.png");
    CheckBool(status, "BoundingBox::setup() activeBg.loadIage");
    status = targetMask.loadImage(folderPass + "/targetMask.png");
    CheckBool(status, "BoundingBox::setup() targetMask.loadIage");
    
    choiceTargetNo = 0;
    
    status = fonts.loadFont("G-OTF-GShinGoPro-Medium.otf", 14);
    CheckBool(status, "BoundingBox::setup() fonts.loadFont");
    bDefaultExist = defaultExistance;
    bDraw = true;
    bSet = true;
}
//----------------------------------------------
void BoundingBox::subUpdate(){
    if (derayTimer.isMoving()) {
        if (derayTimer.getTime(false) > DERAY) {
            close();
            derayTimer.off();
        }
    }
}
//----------------------------------------------
void BoundingBox::subDraw(){
    counter ++;
    ofPushStyle();
    ofEnableAlphaBlending();
    ofSetColor(255);
    float marginX = 10.0f;
    float marginY = 22.0f;
    ofPoint axis = ofPoint(this->x, this->y);
    //opening = true;
    if (opening) {
        ofSetColor(255);
        activeImg.draw(axis.x, axis.y);
        fonts.drawString(texts[0], axis.x + marginX, axis.y + marginY);
        for (int i = 0; i < choiceNum; i++) {
            ofPoint drawPos = ofPoint(axis.x, axis.y + normalHeight * (i + 1));
            ofSetColor(255, 255, 255, 100);
            ofLine(drawPos.x, drawPos.y, drawPos.x + width - 30.0f, drawPos.y);
            
            ofSetColor(255);
            activeBg.draw(drawPos);
            ofSetColor(0, 0, 0, 255);
            fonts.drawString(texts[i], drawPos.x + marginX, drawPos.y + marginY);
        }
        //if (choiceTargetNo != 0) {
            ofSetColor(255, 255, 255, 255);
            targetMask.draw(axis.x, axis.y + choiceTargetNo * normalHeight);
        //}
    
    } else {
        ofSetColor(255, 255, 255, 255);
        normalImg.draw(axis.x, axis.y);
        ofSetColor(0, 0, 0, 255);
        fonts.drawString(texts[choiceTargetNo], axis.x + marginX, axis.y + marginY);
    }
    ofPopStyle();
}
//----------------------------------------------
void BoundingBox::action(ActionType const& action, ofPoint const& touchPos){
    //cout << "BoundingBox::action( " << getActionTypeString(action) << ", ofPoint( " << touchPos.x << ", " << touchPos.y << " ) を受け取った。" << endl;
    if (action == TAPPED) {
        tapped(touchPos);
    }
}
//----------------------------------------------
void BoundingBox::tapped(ofPoint const& touchPos){
//    cout << "BoundingBox::tapped()" << endl;
//    cout <<"opening : " << soToString(opening) << endl;
    if (opening) {
        setChoiceTarget(touchPos);
        derayTimer.on();
    }
}
//----------------------------------------------
void BoundingBox::inTouchDown(ofPoint const& touchPos){
    if (!opening) open();
}
//----------------------------------------------
void BoundingBox::inTouchMoved(ofPoint const& touchPos){
    cout << "inTouchMoved called" << endl;
    if (opening) {
        setChoiceTarget(touchPos);
    }
}
//----------------------------------------------
void BoundingBox::inTouchUp(ofPoint const& touchPos){
    if (opening && choiceTargetNo != 0) {
        setChoiceTarget(touchPos);
        derayTimer.on();
    }
}
//----------------------------------------------
void BoundingBox::touchOut(){
    
}
//----------------------------------------------
void BoundingBox::setChoiceTarget(ofPoint const& touchPoint){
    float localY = touchPoint.y - this->y;
    unsigned int target = floor(localY / normalHeight) + 1;
    choiceTargetNo = target;
    cout << name << " target が " << choiceTargetNo << " に変更された。" << endl;
    //close();
}
//----------------------------------------------
void BoundingBox::print(){
    cout << "BoundingBox::print()\nchoiceNum : " << choiceNum <<
    "\nname : " << name <<
    "\nobjType : " << getObjTypeString(objType) <<
    "\nchoiceTargetNo : " << choiceTargetNo << endl;
    for (int i = 0; i < texts.size(); i++) {
        cout << texts[i] << endl;
    }
    cout << "openning : " << soToString(opening) <<
    "\n//BoundingBox::print()" <<endl;
}
///////////////////////////////////////
//////BoundingBox////private///////////
///////////////////////////////////////
//----------------------------------------------
void BoundingBox::open(){
    cout << "BoundingBox::open()" << endl;
    opening = true;
    height = choiceNum * normalHeight;
    cout << "opening : " << soToString(opening) << endl;
}
//----------------------------------------------
void BoundingBox::close(){
    cout << "close() が呼ばれた" << endl;
    opening = false;
    height = normalHeight;
}
