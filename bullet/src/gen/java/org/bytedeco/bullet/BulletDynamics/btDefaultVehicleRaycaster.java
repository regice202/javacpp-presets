// Targeted by JavaCPP version 1.5.9-SNAPSHOT: DO NOT EDIT THIS FILE

package org.bytedeco.bullet.BulletDynamics;

import java.nio.*;
import org.bytedeco.javacpp.*;
import org.bytedeco.javacpp.annotation.*;

import static org.bytedeco.javacpp.presets.javacpp.*;
import org.bytedeco.bullet.LinearMath.*;
import static org.bytedeco.bullet.global.LinearMath.*;
import org.bytedeco.bullet.BulletCollision.*;
import static org.bytedeco.bullet.global.BulletCollision.*;

import static org.bytedeco.bullet.global.BulletDynamics.*;


@NoOffset @Properties(inherit = org.bytedeco.bullet.presets.BulletDynamics.class)
public class btDefaultVehicleRaycaster extends btVehicleRaycaster {
    static { Loader.load(); }
    /** Pointer cast constructor. Invokes {@link Pointer#Pointer(Pointer)}. */
    public btDefaultVehicleRaycaster(Pointer p) { super(p); }

	public btDefaultVehicleRaycaster(btDynamicsWorld world) { super((Pointer)null); allocate(world); }
	private native void allocate(btDynamicsWorld world);

	public native Pointer castRay(@Const @ByRef btVector3 from, @Const @ByRef btVector3 to, @ByRef btVehicleRaycasterResult result);
}
