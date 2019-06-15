package com.aspects.utils;

import java.lang.reflect.Method;
import java.util.Arrays;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

import org.aspectj.lang.reflect.MethodSignature;

import com.aspects.annotations.*;

/**
 * Split a method into multiple threads
 * @param <T> the input type of the split method
 */
public abstract aspect AspectAbstractSplit<T> {
	/**
	 * Capture methods execution annotated with AJSplit
	 */
	public pointcut splitMethod(T[] t) : @annotation(AJSplit) && args(t) && execution(void *.*(..));
	
	void around(T[] t) : splitMethod(t) {
		System.out.println("abstract ");
		ExecutorService es = Executors.newCachedThreadPool();

		MethodSignature signature = (MethodSignature) thisJoinPointStaticPart.getSignature();
	    Method method = signature.getMethod();
	    AJSplit myAnnotation = method.getAnnotation(AJSplit.class);
	    int numCores = myAnnotation.cores();
	    System.out.println("Number of cores " + numCores);
	    
	    for (int i = 0; i < numCores; i++) {
	    	int start = i*t.length/numCores;
	    	int end = start + t.length/numCores;
	    	es.execute(new Runnable() {

				@Override
				public void run() {
					proceed(Arrays.copyOfRange(t, start, end));
				}
	    		
	    	});
	    }
	    
	    es.shutdown();

	    try {
			es.awaitTermination(Long.MAX_VALUE, TimeUnit.NANOSECONDS);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
	    
	}
}
