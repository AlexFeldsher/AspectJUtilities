package com.aspects.utils;
import java.util.ArrayList;

import com.aspects.annotations.*;

/**
 * Run method annotated with AJThread in a thread
 */
public aspect AspectThread {

	@AJLock
	private static ArrayList<Thread> threads = new ArrayList<>();

	pointcut thread(Object[] args): @annotation(AJThread) && args(args) && call(void *.*(..));
	pointcut simpleThread(): @annotation(AJThread) && call(void com.test.main.*.*());
	
	void around(Object[] args): thread(args) {
		Runnable runnable = new Runnable() {
			@Override
			public void run() {
				proceed(args);
			}
		};
		Thread t = new Thread(runnable);
		t.start();
		threads.add(t);
	}
	
	void around(): simpleThread() {
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
