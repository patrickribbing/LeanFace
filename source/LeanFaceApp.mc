import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class LeanFaceApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ new LeanFaceView() ];
    }

}

function getApp() as LeanFaceApp {
    return Application.getApp() as LeanFaceApp;
}