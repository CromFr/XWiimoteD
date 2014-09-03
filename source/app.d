import std.stdio;
import core.thread;
import xwiimote;

void main()
{
	xwii_load();


	xwii_monitor* mon = xwii_monitor_new(false, true);
	if(mon !is null){
		assert("xwii_monitor_new failed");
	}

	xwii_iface* devices;

	char* wmpath;
	while((wmpath=xwii_monitor_poll(mon)) !is null){
		writeln("Connecting to ",wmpath);

		auto status = xwii_iface_new(&devices, wmpath);
		assert(status==0, "xwii_iface_new failed");

		auto events = xwii_event_types.XWII_EVENT_KEY|xwii_event_types.XWII_EVENT_ACCEL;
		status = xwii_iface_open(devices, events);
		assert(status==0, "xwii_iface_open failed");

		assert((xwii_iface_opened(devices)&events)!=events, "Some events are not activated on the wiimote");

		xwii_iface_rumble(devices, true);
		Thread.sleep(dur!"seconds"(1));
		xwii_iface_rumble(devices, false);
	}



	while(true){
		xwii_event* ev = null;
		xwii_iface_poll(devices, ev);
		if(ev !is null){
			switch(ev.type){
				case xwii_event_types.XWII_EVENT_KEY:
					auto kev = cast(xwii_event_key*)(ev);
					writeln("Key ",kev.code," = ",kev.state);
					break;
				case xwii_event_types.XWII_EVENT_ACCEL:
					writeln("Accel received");
					break;
				default:
					break;
			}
		}

	}
	
	
}
