#pragma once

#include "ofMain.h"
#include "MyGlobal.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"
#include "ofxSOInteractivePage.h"
#include "Objects.h"
#include "testPage.h"

class testApp : public ofxiPhoneApp{
	
    public:
        void setup();
    void update();
    void draw();
        void exit();
	
        void touchDown(ofTouchEventArgs & touch);
        void touchMoved(ofTouchEventArgs & touch);
        void touchUp(ofTouchEventArgs & touch);
    void touchDoubleTap(ofTouchEventArgs & touch){}
    void touchCancelled(ofTouchEventArgs & touch){}

        void lostFocus();
        void gotFocus();
        void gotMemoryWarning();
        void deviceOrientationChanged(int newOrientation);
private:    
    void customEventCatched(ofxSOiOSEvents & e);
    
    vector<ofxSOInteractivePage *> pPages;
    vector <string> testString;

    unsigned int activePageNo;
};


