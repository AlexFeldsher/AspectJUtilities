package com.aspects.utils;

import java.lang.reflect.Method;

import org.aspectj.lang.reflect.MethodSignature;
import org.aspectj.lang.reflect.SourceLocation;

import com.aspects.annotations.*;

/**
 * Verify the method parameters are not null
 */
public aspect AspectNotNull {
	pointcut notNullMethod() : @annotation(AJNotNull) && call(* *.*(..));
	
	before() throws NullArgException : notNullMethod() {
		Object[] args = thisJoinPoint.getArgs();

		MethodSignature signature = (MethodSignature) thisJoinPointStaticPart.getSignature();
		Method method = signature.getMethod();
	    AJNotNull annotation = method.getAnnotation(AJNotNull.class);
		SourceLocation sl = thisJoinPointStaticPart.getSourceLocation();


		for (Object o : args) {
			if (o == null) {
				System.err.println("Method recieve null in arguments: " + sl);
				if (annotation.type().equals("Exception")) {
					throw new NullArgException();
				}
			}
		}
	}
}
