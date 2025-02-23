// Targeted by JavaCPP version 1.5.9-SNAPSHOT: DO NOT EDIT THIS FILE

package org.bytedeco.bullet.LinearMath;

import java.nio.*;
import org.bytedeco.javacpp.*;
import org.bytedeco.javacpp.annotation.*;

import static org.bytedeco.javacpp.presets.javacpp.*;

import static org.bytedeco.bullet.global.LinearMath.*;


/**The StackAlloc class provides some fast stack-based memory allocator (LIFO last-in first-out) */
@NoOffset @Properties(inherit = org.bytedeco.bullet.presets.LinearMath.class)
public class btStackAlloc extends Pointer {
    static { Loader.load(); }
    /** Pointer cast constructor. Invokes {@link Pointer#Pointer(Pointer)}. */
    public btStackAlloc(Pointer p) { super(p); }

	public btStackAlloc(@Cast("unsigned int") int size) { super((Pointer)null); allocate(size); }
	private native void allocate(@Cast("unsigned int") int size);

	public native void create(@Cast("unsigned int") int size);
	public native void destroy();

	public native int getAvailableMemory();

	public native @Cast("unsigned char*") @Name("allocate") BytePointer _allocate(@Cast("unsigned int") int size);
	public native btBlock beginBlock();
	public native void endBlock(btBlock block);
}
