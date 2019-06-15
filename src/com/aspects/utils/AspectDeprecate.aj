package com.aspects.utils;
import java.lang.reflect.Method;

import org.aspectj.lang.reflect.MethodSignature;
import org.aspectj.lang.reflect.SourceLocation;

import com.aspects.annotations.*;

/**
 * Handles deprecated methods
 */
public abstract aspect AspectDeprecate {
	
	/**
	 * Capture the execution of methods marked as deprecated
	 */
	pointcut depracatedMethodCall() : @annotation(AJDeprecate) && execution(* *.*(..));

	/**
	 * Print a warning and/or throw an exception, depending on the notation parameter type.
	 * @throws DeprecatedException
	 */
	void around() throws DeprecatedException : depracatedMethodCall() {
		MethodSignature signature = (MethodSignature) thisJoinPointStaticPart.getSignature();
		Method method = signature.getMethod();
	    AJDeprecate annotation = method.getAnnotation(AJDeprecate.class);
		SourceLocation sl = thisJoinPointStaticPart.getSourceLocation();

		String name = new Object(){}.getClass().getEnclosingMethod().getName();
		System.out.println("ENCLOSING METHOD: " + name);

	    if (annotation.type().equals("Exception")) {
			System.err.println("WARNING::Deprecated method: " + signature.toLongString() + " " + sl.toString());
	    	throw new DeprecatedException();
	    } else if (annotation.type().equals("Warning")) {
			System.err.println("WARNING::Deprecated method: " + signature.toLongString() + " " + sl.toString());
	    }
	    
		proceed();
	}

}
