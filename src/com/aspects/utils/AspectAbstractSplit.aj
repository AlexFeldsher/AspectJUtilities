package com.aspects.utils;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
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
	public pointcut splitMethodArray(T[] t) : @annotation(AJSplit) && args(t) && execution(void *.*(..));
	public pointcut splitMethodCollection(ArrayList<T> t) : @annotation(AJSplit) && args(t) && execution(void *.*(..));
	
	void around(T[] t) : splitMethodArray(t) {
		ExecutorService es = Executors.newCachedThreadPool();

		MethodSignature signature = (MethodSignature) thisJoinPointStaticPart.getSignature();
	    Method method = signature.getMethod();
	    AJSplit myAnnotation = method.getAnnotation(AJSplit.class);
	    int numJobs = myAnnotation.jobs();
	    if (numJobs == 0) {
	    	numJobs = Runtime.getRuntime().availableProcessors();
	    }
	    
	    for (int i = 0; i < numJobs; i++) {
	    	int start = i*t.length/numJobs;
	    	int end = start + t.length/numJobs;
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

	void around(ArrayList<T> t) : splitMethodCollection(t) {
		Object[] array = t.toArray();
		ExecutorService es = Executors.newCachedThreadPool();

		MethodSignature signature = (MethodSignature) thisJoinPointStaticPart.getSignature();
	    Method method = signature.getMethod();
	    AJSplit myAnnotation = method.getAnnotation(AJSplit.class);
	    int numJobs = myAnnotation.jobs();
	    if (numJobs == 0) {
	    	numJobs = Runtime.getRuntime().availableProcessors();
	    }
	    
	    for (int i = 0; i < numJobs; i++) {
	    	int start = i*array.length/numJobs;
	    	int end = start + array.length/numJobs;
			Object[] subArray = Arrays.copyOfRange(array, start, end);
	    	es.execute(new Runnable() {

				@Override
				public void run() {
					proceed(new ArrayList<T>((Collection<? extends T>) Arrays.asList(subArray)));
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
