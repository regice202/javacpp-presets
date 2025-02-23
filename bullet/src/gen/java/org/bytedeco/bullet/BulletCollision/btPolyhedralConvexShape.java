// Targeted by JavaCPP version 1.5.9-SNAPSHOT: DO NOT EDIT THIS FILE

package org.bytedeco.bullet.BulletCollision;

import java.nio.*;
import org.bytedeco.javacpp.*;
import org.bytedeco.javacpp.annotation.*;

import static org.bytedeco.javacpp.presets.javacpp.*;
import org.bytedeco.bullet.LinearMath.*;
import static org.bytedeco.bullet.global.LinearMath.*;

import static org.bytedeco.bullet.global.BulletCollision.*;


/**The btPolyhedralConvexShape is an internal interface class for polyhedral convex shapes. */
@NoOffset @Properties(inherit = org.bytedeco.bullet.presets.BulletCollision.class)
public class btPolyhedralConvexShape extends btConvexInternalShape {
    static { Loader.load(); }
    /** Pointer cast constructor. Invokes {@link Pointer#Pointer(Pointer)}. */
    public btPolyhedralConvexShape(Pointer p) { super(p); }


	/**optional method mainly used to generate multiple contact points by clipping polyhedral features (faces/edges)
	 * experimental/work-in-progress */
	public native @Cast("bool") boolean initializePolyhedralFeatures(int shiftVerticesByMargin/*=0*/);
	public native @Cast("bool") boolean initializePolyhedralFeatures();

	public native void setPolyhedralFeatures(@ByRef btConvexPolyhedron polyhedron);

	public native @Const btConvexPolyhedron getConvexPolyhedron();

	//brute force implementations

	public native @ByVal btVector3 localGetSupportingVertexWithoutMargin(@Const @ByRef btVector3 vec);
	public native void batchedUnitVectorGetSupportingVertexWithoutMargin(@Const btVector3 vectors, btVector3 supportVerticesOut, int numVectors);

	public native void calculateLocalInertia(@Cast("btScalar") double mass, @ByRef btVector3 inertia);

	public native int getNumVertices();
	public native int getNumEdges();
	public native void getEdge(int i, @ByRef btVector3 pa, @ByRef btVector3 pb);
	public native void getVertex(int i, @ByRef btVector3 vtx);
	public native int getNumPlanes();
	public native void getPlane(@ByRef btVector3 planeNormal, @ByRef btVector3 planeSupport, int i);
	//	virtual int getIndex(int i) const = 0 ;

	public native @Cast("bool") boolean isInside(@Const @ByRef btVector3 pt, @Cast("btScalar") double tolerance);
}
