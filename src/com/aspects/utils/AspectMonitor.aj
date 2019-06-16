package com.aspects.utils;

import java.util.concurrent.ConcurrentHashMap;

/**
 * Monitor methods runtime and number of calls
 */
public aspect AspectMonitor {
	
	private static final int START_TIME = 0;
	private static final int TOTAL_TIME = 1;
	private static final int NUMBER_OF_CALLS = 2;
	
	private static final ConcurrentHashMap<String, long[]> runtime = new ConcurrentHashMap<String, long[]>();
	
	pointcut mainMethod(): execution(public static void main(String[]));
	pointcut methodCall(): call(* *.*(..)) && !within(Aspect*);
	pointcut systemExit(): call(* System.exit(..));
	
	before(): methodCall() || mainMethod() {
		String key = thisJoinPointStaticPart.getSignature().toString();

		long start = System.nanoTime();
		long[] data = runtime.get(key);

		if (data == null) {
			data = new long[3];
			data[START_TIME] = start;
			data[TOTAL_TIME] = -1;
			data[NUMBER_OF_CALLS] = 1;
			runtime.put(key, data);
		} else {
			data[START_TIME] = start;
			data[NUMBER_OF_CALLS] += 1;
			runtime.put(key, data);
		}
	}
	
	after(): methodCall() || mainMethod() {
		String key = thisJoinPointStaticPart.getSignature().toString();
		long end = System.nanoTime();
		long[] data = runtime.get(key);
		data[TOTAL_TIME] += end - data[START_TIME];
		runtime.put(key, data);
	}
	
	after(): mainMethod() || systemExit() {
		for (String method :runtime.keySet()) {
			long[] data = runtime.get(method);
			System.out.println(method + ", " + data[TOTAL_TIME] + ", " + data[NUMBER_OF_CALLS] + ", " + data[TOTAL_TIME]/data[NUMBER_OF_CALLS]);
		}
	}


}
