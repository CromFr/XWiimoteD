module xwiimote;

import std.conv : to;
import core.sys.posix.dlfcn;

private static __gshared void* lib = null;
struct dyncall{};//Functions from xwii

void xwii_load(in string librarypath="libxwiimote.so"){
	import std.stdio : writeln;
	import std.traits;

	lib = dlopen(librarypath.ptr, RTLD_NOW);
	if(!lib){
		throw new Exception("Library '"~librarypath~"' failed to load: "~to!string(dlerror()));
	}

	foreach(member ; __traits(allMembers, xwiimote)){
		static if(isCallable!(mixin(member))){
			foreach(attr ; __traits(getAttributes, mixin(member))){
				static if(attr.stringof=="dyncall"){
					//writeln("    ",member," loaded !");
					mixin(member) = cast (typeof(mixin(member))) (dlsym(lib, member.ptr));

					if(char* e = dlerror()){
						throw new Exception("Could not find symbol '"~member~"' in "~librarypath);
					}
					break;
				}
			}
		}
	}

	writeln(librarypath," has been loaded");
}

static ~this(){
	if(lib !is null)
		dlclose(lib);
}






import core.stdc.time;

extern (C):

 
enum XWII__NAME = "Nintendo Wii Remote";
enum XWII_NAME_CORE = XWII__NAME;
enum XWII_NAME_ACCEL = XWII__NAME~" Accelerometer";
enum XWII_NAME_IR = XWII__NAME~" IR";
enum XWII_NAME_MOTION_PLUS = XWII__NAME~" Motion Plus";
enum XWII_NAME_NUNCHUK = XWII__NAME~" Nunchuk";
enum XWII_NAME_CLASSIC_CONTROLLER = XWII__NAME~" Classic Controller";
enum XWII_NAME_BALANCE_BOARD = XWII__NAME~" Balance Board";
enum XWII_NAME_PRO_CONTROLLER = XWII__NAME~" Pro Controller";
int XWII_LED(int num){return (xwii_led.XWII_LED1 + (num) - 1);}

enum xwii_event_types : uint
{
	XWII_EVENT_KEY = 0,
	XWII_EVENT_ACCEL = 1,
	XWII_EVENT_IR = 2,
	XWII_EVENT_BALANCE_BOARD = 3,
	XWII_EVENT_MOTION_PLUS = 4,
	XWII_EVENT_PRO_CONTROLLER_KEY = 5,
	XWII_EVENT_PRO_CONTROLLER_MOVE = 6,
	XWII_EVENT_WATCH = 7,
	XWII_EVENT_NUM = 8
}

enum xwii_event_keys : uint
{
	XWII_KEY_LEFT = 0,
	XWII_KEY_RIGHT = 1,
	XWII_KEY_UP = 2,
	XWII_KEY_DOWN = 3,
	XWII_KEY_A = 4,
	XWII_KEY_B = 5,
	XWII_KEY_PLUS = 6,
	XWII_KEY_MINUS = 7,
	XWII_KEY_HOME = 8,
	XWII_KEY_ONE = 9,
	XWII_KEY_TWO = 10,
	XWII_KEY_X = 11,
	XWII_KEY_Y = 12,
	XWII_KEY_TL = 13,
	XWII_KEY_TR = 14,
	XWII_KEY_ZL = 15,
	XWII_KEY_ZR = 16,
	XWII_KEY_THUMBL = 17,
	XWII_KEY_THUMBR = 18,
	XWII_KEY_NUM = 19
}

enum xwii_iface_type
{
	XWII_IFACE_CORE = 1,
	XWII_IFACE_ACCEL = 2,
	XWII_IFACE_IR = 4,
	XWII_IFACE_MOTION_PLUS = 256,
	XWII_IFACE_NUNCHUK = 512,
	XWII_IFACE_CLASSIC_CONTROLLER = 1024,
	XWII_IFACE_BALANCE_BOARD = 2048,
	XWII_IFACE_PRO_CONTROLLER = 4096,
	XWII_IFACE_ALL = 7943,
	XWII_IFACE_WRITABLE = 65536
}

enum xwii_led
{
	XWII_LED1 = 1,
	XWII_LED2 = 2,
	XWII_LED3 = 3,
	XWII_LED4 = 4
}

struct xwii_event_key
{
	xwii_event_keys code;
	uint state;
}

struct xwii_event_abs
{
	int x;
	int y;
	int z;
}

struct xwii_event
{
	struct timeval
	{
		private import core.sys.posix.sys.time;
		time_t tv_sec;
		suseconds_t tv_usec;
	}
	timeval time;
	xwii_event_types type;
	union xwii_event_union
	{
		struct xwii_event_key
		{
			xwii_event_keys code;
			uint state;
		}
		xwii_event_key key;
		xwii_event_abs[4] abs;
		ubyte[128] reserved;
	}
	xwii_event_union v;
}

struct xwii_iface;


struct xwii_monitor;


union xwii_event_union
{
	struct xwii_event_key
	{
		xwii_event_keys code;
		uint state;
	}
	xwii_event_key key;
	xwii_event_abs[4] abs;
	ubyte[128] reserved;
}

//@dyncall bool function(const(xwii_event_abs)* abs) 							xwii_event_ir_is_valid;
@dyncall int function(xwii_iface** dev, const(char)* syspath) 				xwii_iface_new;
@dyncall void function(xwii_iface* dev) 									xwii_iface_ref;
@dyncall void function(xwii_iface* dev) 									xwii_iface_unref;
@dyncall int function(xwii_iface* dev) 										xwii_iface_get_fd;
@dyncall int function(xwii_iface* dev, bool watch) 							xwii_iface_watch;
@dyncall int function(xwii_iface* dev, uint ifaces) 						xwii_iface_open;
@dyncall void function(xwii_iface* dev, uint ifaces) 						xwii_iface_close;
@dyncall uint function(xwii_iface* dev) 									xwii_iface_opened;
@dyncall uint function(xwii_iface* dev) 									xwii_iface_available;
@dyncall int function(xwii_iface* dev, xwii_event* ev) 						xwii_iface_poll;
@dyncall int function(xwii_iface* dev, xwii_event* ev, size_t size	) 		xwii_iface_dispatch;
@dyncall int function(xwii_iface* dev, bool on) 							xwii_iface_rumble;
@dyncall int function(xwii_iface* dev, uint led, bool* state) 				xwii_iface_get_led;
@dyncall int function(xwii_iface* dev, uint led, bool state) 				xwii_iface_set_led;
@dyncall int function(xwii_iface* dev, ubyte* capacity) 					xwii_iface_get_battery;
@dyncall int function(xwii_iface* dev, char** devtype) 						xwii_iface_get_devtype;
@dyncall int function(xwii_iface* dev, char** extension) 					xwii_iface_get_extension;
@dyncall void function(xwii_iface* dev, int x, int y, int z, int factor) 	xwii_iface_set_mp_normalization;
@dyncall void function(xwii_iface* dev, int* x, int* y, int* z, int* factor)xwii_iface_get_mp_normalization;
@dyncall xwii_monitor* function(bool poll, bool direct) 					xwii_monitor_new;
@dyncall void function(xwii_monitor* mon) 									xwii_monitor_ref;
@dyncall void function(xwii_monitor* mon) 									xwii_monitor_unref;
@dyncall int function(xwii_monitor* monitor, bool blocking) 				xwii_monitor_get_fd;
@dyncall char* function(xwii_monitor* monitor) 								xwii_monitor_poll;