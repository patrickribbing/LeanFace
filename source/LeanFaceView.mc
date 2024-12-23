import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.Time.Gregorian as Calendar;

class LeanFaceView extends WatchUi.WatchFace {
    var isAwake = false;
    var spacing = 4;

    function initialize() {
        WatchFace.initialize();

        isAwake = true;
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.LeanFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // System.println("update");

        var batteryView = View.findDrawableById("BatteryLabel") as Text;
        batteryView.setVisible(isAwake);
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        var clockTime = System.getClockTime();
        var timeHourMinStr = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);
        var sizeTimeHourMinStr = dc.getTextWidthInPixels(timeHourMinStr, Graphics.FONT_SYSTEM_NUMBER_THAI_HOT);

        var timeSecStr = "";
        var sizeTimeSecStr = 0;

        if (isAwake) {
            timeSecStr = Lang.format("$1$", [clockTime.sec.format("%02d")]);
            sizeTimeSecStr = dc.getTextWidthInPixels(timeSecStr, Graphics.FONT_GLANCE);
        }

        var xPart1 = dc.getWidth() / 2 - (sizeTimeHourMinStr + spacing + sizeTimeSecStr) / 2;

        // Show time, hour and minute
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(xPart1 , dc.getHeight() / 2, Graphics.FONT_SYSTEM_NUMBER_THAI_HOT, timeHourMinStr, Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);

        if (isAwake) {
            // Show seconds
            var xPart2 = xPart1 + sizeTimeHourMinStr + spacing;
            dc.drawText(xPart2, dc.getHeight() / 2, Graphics.FONT_GLANCE, timeSecStr, Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);

            // Battery status
            var stats = System.getSystemStats();
            var batteryStr = Lang.format("$1$% [$2$d]", [stats.battery.format("%02d"), stats.batteryInDays.format("%1d")]);
            if (stats.charging || (stats.solarIntensity != null && stats.solarIntensity > 10)) {
                batteryStr += " *";
            }
            batteryView.setText(batteryStr);
        }

        // Subscreen with date (day and month)
        var subscreen = WatchUi.getSubscreen();
        var dateInfo = Calendar.info(Time.now(), Time.FORMAT_LONG);
        var subscreenString = Lang.format("$1$\n$2$", [dateInfo.day, dateInfo.month]);
        var sizeSubscreenText = dc.getTextDimensions(subscreenString, Graphics.FONT_GLANCE);
        dc.drawText(subscreen.x + subscreen.width / 2 - sizeSubscreenText[0] / 2, subscreen.y + subscreen.height / 2, Graphics.FONT_GLANCE, subscreenString, Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
        isAwake = true;
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
        isAwake = false;
    }

}
