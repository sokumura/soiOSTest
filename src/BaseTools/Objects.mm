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
                        string const& folderPass){
    
    counter = 0;
    
    objType = BOUNDING_BOX;
    ofRectangle::set(X, Y, W, H);
    this->name = _name;
    texts = _texts;
    num = texts.size();
    opening = exopening = false;
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
    
    targetNo = 0;
    
    status = fonts.loadFont("G-OTF-GShinGoPro-Medium.otf", 18);
    CheckBool(status, "BoundingBox::setup() fonts.loadFont");
    bDraw = true;
    bSet = true;
}
//----------------------------------------------
void BoundingBox::subUpdate(){
    cout << "BoundingBox::subUpdate() opening is " << soToString(opening) << endl;
    if (exopening != opening) {
        exopening = opening;
        cout << "opening が" << opening << " に変更された!!!" << endl;
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
    if (opening) {
        cout << "openning draw is called" << endl;
        ofSetColor(255);
        activeImg.draw(axis.x, axis.y);
        fonts.drawString(texts[0], axis.x + marginX, axis.y + marginY);
        for (int i = 0; i < num; i++) {
            ofPoint drawPos = ofPoint(axis.x, axis.y + normalHeight * (i + 1));
            ofSetColor(255);
            activeBg.draw(drawPos);
            ofSetColor(0, 0, 0, 255);
            fonts.drawString(texts[i], drawPos.x + marginX, drawPos.y + marginY);
            if (targetNo != i + 1) {
                ofSetColor(255, 255, 255, 100);
                targetMask.draw(drawPos.x, targetNo * normalHeight);
            }
        }
        
    } else {
        ofSetColor(255, 255, 255, 255);
        normalImg.draw(axis.x, axis.y);
        ofSetColor(0, 0, 0, 255);
        fonts.drawString(texts[targetNo], axis.x + marginX, axis.y + marginY);
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
    cout << "BoundingBox::tapped()" << endl;
    cout <<"opening : " << soToString(opening) << endl;
    if (opening) {
        setTarget(touchPos);
    } else {
        open();
    }
}
//----------------------------------------------
void BoundingBox::inTouchDown(ofPoint const& touchPos){

}
//----------------------------------------------
void BoundingBox::inTouchMoved(ofPoint const& touchPos){

}
//----------------------------------------------
void BoundingBox::inTouchUp(ofPoint const& touchPos){

}
//----------------------------------------------
void BoundingBox::touchOut(){
    close();
}
//----------------------------------------------
void BoundingBox::setTarget(ofPoint const& touchPoint){
    float localY = touchPoint.y - this->y;
    unsigned int target = floor(localY / normalHeight);
    targetNo = target;
    cout << name << " target が " << targetNo << " に変更された。" << endl;
    close();
}
///////////////////////////////////////
//////BoundingBox////private///////////
///////////////////////////////////////
//----------------------------------------------
void BoundingBox::open(){
    cout << "BoundingBox::open()" << endl;
    opening = true;
    height = num * normalHeight;
    cout << "opening : " << soToString(opening) << endl;
}
//----------------------------------------------
void BoundingBox::close(){
    opening = false;
    height = normalHeight;
}
