// Targeted by JavaCPP version 1.5.9-SNAPSHOT: DO NOT EDIT THIS FILE

package org.bytedeco.bullet.BulletSoftBody;

import java.nio.*;
import org.bytedeco.javacpp.*;
import org.bytedeco.javacpp.annotation.*;

import static org.bytedeco.javacpp.presets.javacpp.*;
import org.bytedeco.bullet.LinearMath.*;
import static org.bytedeco.bullet.global.LinearMath.*;
import org.bytedeco.bullet.BulletCollision.*;
import static org.bytedeco.bullet.global.BulletCollision.*;
import org.bytedeco.bullet.BulletDynamics.*;
import static org.bytedeco.bullet.global.BulletDynamics.*;

import static org.bytedeco.bullet.global.BulletSoftBody.*;


@Properties(inherit = org.bytedeco.bullet.presets.BulletSoftBody.class)
public class Preconditioner extends Pointer {
    static { Loader.load(); }
    /** Pointer cast constructor. Invokes {@link Pointer#Pointer(Pointer)}. */
    public Preconditioner(Pointer p) { super(p); }

	public native @Name("operator ()") void apply(@Cast("const Preconditioner::TVStack*") @ByRef btVector3Array x, @Cast("Preconditioner::TVStack*") @ByRef btVector3Array b);
	public native void reinitialize(@Cast("bool") boolean nodeUpdated);
}
