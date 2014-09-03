module xwiimote;

import std.conv : to;
import core.sys.posix.dlfcn;

private static __gshared void* lib = null;

void xwii_load(in string librarypath="libxwiimote.so"){
	import std.stdio : writeln;

	lib = dlopen(librarypath.ptr, RTLD_LAZY);
	if(!lib){
		throw new Exception("Library '"~librarypath~"' failed to load: "~to!string(dlerror()));
	}
	else
		writeln(librarypath," has been loaded");
}


T xwii_call(T, VT...)(in string fun, VT args){
	debug{
		assert(lib !is null, "You must load library with xwii_load before executing xwii functions");
	}
	import std.stdio : writeln;
	string arglist;
	foreach(arg ; args)arglist~=to!string(arg)~",";
	writeln(T.stringof," ",fun,"(",arglist,");");
	T function(VT) fn = cast(T function(VT)) dlsym(lib, fun.ptr);

	debug{
		if(char* e = dlerror())
			throw new Exception("Function call error in XWiimoteD': "~to!string(e));
	}

	return fn(args);
}

static ~this(){
	if(lib !is null)
		dlclose(lib);
}

 
enum XWII__NAME = "Nintendo Wii Remote";
enum XWII_NAME_CORE = XWII__NAME;
enum XWII_NAME_ACCEL = XWII__NAME~" Accelerometer";
enum XWII_NAME_IR = XWII__NAME~" IR";
enum XWII_NAME_MOTION_PLUS = XWII__NAME~" Motion Plus";
enum XWII_NAME_NUNCHUK = XWII__NAME~" Nunchuk";
enum XWII_NAME_CLASSIC_CONTROLLER = XWII__NAME~" Classic Controller";
enum XWII_NAME_BALANCE_BOARD = XWII__NAME~" Balance Board";
enum XWII_NAME_PRO_CONTROLLER = XWII__NAME~" Pro Controller";
//alias XWII_LED(num) = (XWII_LED1 + (num) - 1); TODO





// AUTO GENERATED from xwiimote.h with dstep
//- added xwii_call to functions
//- Added private import in xwii_event.timeval, renamed __* to *
//- Added types to xwii_event_types and xwii_event_keys enums & changed structs to use the enums


import core.stdc.time;

extern (C):

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

bool xwii_event_ir_is_valid (const(xwii_event_abs)* abs)									{return xwii_call!bool("xwii_event_ir_is_valid",abs);}
int xwii_iface_new (xwii_iface** dev, const(char)* syspath)									{return xwii_call!int("xwii_iface_new",dev,syspath);}
void xwii_iface_ref (xwii_iface* dev)														{return xwii_call!void("xwii_iface_ref",dev);}
void xwii_iface_unref (xwii_iface* dev)														{return xwii_call!void("xwii_iface_unref",dev);}
int xwii_iface_get_fd (xwii_iface* dev)														{return xwii_call!int("xwii_iface_get_fd",dev);}
int xwii_iface_watch (xwii_iface* dev, bool watch)											{return xwii_call!int("xwii_iface_watch",dev,watch);}
int xwii_iface_open (xwii_iface* dev, uint ifaces)											{return xwii_call!int("xwii_iface_open",dev,ifaces);}
void xwii_iface_close (xwii_iface* dev, uint ifaces)										{return xwii_call!void("xwii_iface_close",dev,ifaces);}
uint xwii_iface_opened (xwii_iface* dev)													{return xwii_call!uint("xwii_iface_opened",dev);}
uint xwii_iface_available (xwii_iface* dev)													{return xwii_call!uint("xwii_iface_available",dev);}
int xwii_iface_poll (xwii_iface* dev, xwii_event* ev)										{return xwii_call!int("xwii_iface_poll",dev,ev);}
int xwii_iface_dispatch (xwii_iface* dev, xwii_event* ev, size_t size)						{return xwii_call!int("xwii_iface_dispatch",dev,ev,size);}
int xwii_iface_rumble (xwii_iface* dev, bool on)											{return xwii_call!int("xwii_iface_rumble",dev,on);}
int xwii_iface_get_led (xwii_iface* dev, uint led, bool* state)								{return xwii_call!int("xwii_iface_get_led",dev,led,state);}
int xwii_iface_set_led (xwii_iface* dev, uint led, bool state)								{return xwii_call!int("xwii_iface_set_led",dev,led,state);}
int xwii_iface_get_battery (xwii_iface* dev, ubyte* capacity)								{return xwii_call!int("xwii_iface_get_battery",dev,capacity);}
int xwii_iface_get_devtype (xwii_iface* dev, char** devtype)								{return xwii_call!int("xwii_iface_get_devtype",dev,devtype);}
int xwii_iface_get_extension (xwii_iface* dev, char** extension)							{return xwii_call!int("xwii_iface_get_extension",dev,extension);}
void xwii_iface_set_mp_normalization (xwii_iface* dev, int x, int y, int z, int factor)		{return xwii_call!void("xwii_iface_set_mp_normalization",dev,x,y,z,factor);}
void xwii_iface_get_mp_normalization (xwii_iface* dev, int* x, int* y, int* z, int* factor)	{return xwii_call!void("xwii_iface_get_mp_normalization",dev,x,y,z,factor);}
xwii_monitor* xwii_monitor_new (bool poll, bool direct)										{return xwii_call!(xwii_monitor*)("xwii_monitor_new",poll,direct);}
void xwii_monitor_ref (xwii_monitor* mon)													{return xwii_call!void("xwii_monitor_ref",mon);}
void xwii_monitor_unref (xwii_monitor* mon)													{return xwii_call!void("xwii_monitor_unref",mon);}
int xwii_monitor_get_fd (xwii_monitor* monitor, bool blocking)								{return xwii_call!int("xwii_monitor_get_fd",monitor,blocking);}
char* xwii_monitor_poll (xwii_monitor* monitor)												{return xwii_call!(char*)("xwii_monitor_poll",monitor);}

