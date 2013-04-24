#include "testApp.h"

//--------------------------------------------------------------
void testApp::setup(){
	// initialize the accelerometer
	ofxAccelerometer.setup();
	
	//If you want a landscape oreintation 
	//iPhoneSetOrientation(OFXIPHONE_ORIENTATION_LANDSCAPE_RIGHT);
	
	ofBackground(127,127,127);
    //ofAddListener(ofxSOiOSEvents::myCustomEventDispacher, this, &testApp::customEventCatched);
    
    //page0
    activePageNo = 0;
    ofxSOInteractivePage * t = new testPage();
    t->setup("TestPage", false, false, false);
    pPages.push_back(t);
    //BoundingBox
    testString.push_back(string("default"));
    testString.push_back(string("one"));
    testString.push_back(string("two"));
    testString.push_back(string("three"));
    testString.push_back(string("four"));
    testString.push_back(string("five"));
    
    BoundingBox * bBox = new BoundingBox();
    bBox->setup(testString, "testBox", 50.0f, 50.0f, 260.0f, 30.0f, "BoundingBoxTest");
    pPages[activePageNo]->buttons.push_back(bBox);
}
//--------------------------------------------------------------
void testApp::update(){
    pPages[activePageNo]->update();
}
//--------------------------------------------------------------
void testApp::draw() {
    pPages[activePageNo]->draw();
}
//--------------------------------------------------------------
void testApp::exit(){
    cout << "testApp::exit()" << endl;
    for (int i = 0; i < pPages.size(); i++) {
        delete pPages[i];
    }
    pPages.clear();
}
void testApp::customEventCatched(ofxSOiOSEvents & e){
    cout << "customEventCatched called as " << e.type << endl;
}
//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs & touch){
    pPages[activePageNo]->touchDown(touch);
}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs & touch){
    pPages[activePageNo]->touchMoved(touch);
}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs & touch){
    pPages[activePageNo]->touchUp(touch);
}

//--------------------------------------------------------------
void testApp::lostFocus(){
    cout << "testApp::lostFocus()" << endl;
}

//--------------------------------------------------------------
void testApp::gotFocus(){
    cout << "testApp::getFocus()" << endl;

}

//--------------------------------------------------------------
void testApp::gotMemoryWarning(){
    cout << "------------------------------------------------\ntestApp::gotMemoryWarning()\n----------------------------------" << endl;
}

//--------------------------------------------------------------
void testApp::deviceOrientationChanged(int newOrientation){

}

