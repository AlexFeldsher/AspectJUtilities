package com.aspects.utils;

import org.aspectj.lang.reflect.MethodSignature;
import org.aspectj.lang.reflect.SourceLocation;

import com.aspects.annotations.AJDeprecatedWarning;
import com.aspects.annotations.AJDeprecatedException;

public aspect AspectDeprecate {
	pointcut deprecatedWarningMethodCall(): @annotation(AJDeprecatedWarning) && call(* *.*(..));
	pointcut deprecatedExceptionMethodCall(): @annotation(AJDeprecatedException) && call(* *.*(..));
	
	before() : deprecatedWarningMethodCall() {
		MethodSignature signature = (MethodSignature) thisJoinPointStaticPart.getSignature();
		SourceLocation sl = thisJoinPointStaticPart.getSourceLocation();
		System.err.println("WARNING::Deprecated method: " + signature.toLongString() + " " + sl.toString());
	}
	
	before() throws DeprecatedException : deprecatedExceptionMethodCall() {
		MethodSignature signature = (MethodSignature) thisJoinPointStaticPart.getSignature();
		SourceLocation sl = thisJoinPointStaticPart.getSourceLocation();
		System.err.println("Exception::Deprecated method: " + signature.toLongString() + " " + sl.toString());
		throw new DeprecatedException();
	}
}
