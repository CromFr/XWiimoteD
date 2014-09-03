//module libloader;

//import std.conv;
//import core.sys.posix.dlfcn;

///**
//	Runtime plugin from precompiled library object
//*/
//class LibLoader {
//	this(in string path, in string name=""){
//		m_path = path;
//		m_name = name!="" ? name : path;

//		m_libhdl = dlopen(m_path.ptr, RTLD_LAZY);
//		if(!m_libhdl){
//			throw new Exception("Library '"~m_name~"' failed to load: "~to!string(dlerror()));
//		}
//	}
//	~this(){
//		dlclose(m_libhdl);
//	}


//	T Call(T, VT...)(in string func, VT args){
//		T function(VT) fn = cast(T function(VT)) dlsym(m_libhdl, func.ptr);

//		if(char* e = dlerror()){
//			throw new Exception("Function call error in library '"~m_name~"': "~to!string(e));
//		}

//		return fn(args);
//	}


//protected:
//	string m_path;
//	string m_name;

//	void* m_libhdl;
//}