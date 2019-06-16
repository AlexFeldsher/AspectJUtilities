package com.aspects.utils;
import java.util.ArrayList;

import com.aspects.annotations.*;

/**
 * Run method annotated with AJThread in a thread
 */
public aspect AspectThread {

	@AJLock
	private static ArrayList<Thread> threads = new ArrayList<>();

	pointcut thread(Object arg): @annotation(AJThread) && args(arg,..) && execution(void *.*(..));
	pointcut noArgThread(): @annotation(AJThread) && call(void *.*());
	
	void around(Object arg): thread(arg) {
		Runnable runnable = new Runnable() {
			@Override
			public void run() {
				proceed(arg);
			}
		};
		Thread t = new Thread(runnable);
		t.start();
		threads.add(t);
	}
	
	void around(): noArgThread() {
		Runnable runnable = new Runnable() {
			@Override
			public void run() {
				proceed();
			}
		};
		Thread t = new Thread(runnable);
		t.start();
		threads.add(t);
	}

	/**
	 * Join all threads created by calling methods annotated with AJThread
	 */
	public static void joinAJThreads() {
		for (Thread t : threads) {
			try {
				t.join();
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
		threads = new ArrayList<Thread>();
	}
}
