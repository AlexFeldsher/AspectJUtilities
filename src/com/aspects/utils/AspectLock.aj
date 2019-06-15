package com.aspects.utils;
import java.util.HashMap;
import java.util.concurrent.Semaphore;

import org.aspectj.lang.Signature;

import com.aspects.annotations.*;

/**
 * Make a field marked with the lock annotation thread safe.
 */
public aspect AspectLock {
	private static final HashMap<Object, Semaphore> locks = new HashMap<>();

	/**
	 * capture all field access
	 */
	pointcut _lockSet(): @annotation(AJLock) && set(* *.*);
	pointcut _lockGet(): @annotation(AJLock) && get(* *.*);

	void around(): _lockSet() {
		Signature signature = thisJoinPointStaticPart.getSignature();
		Semaphore s = locks.get(signature);
		
		if (s == null) {
			s = new Semaphore(1);
			locks.put(s, s);
		}

		try {
			s.acquire();
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		
		proceed();
		
		s.release();
	}

	Object around(): _lockGet() {
		Signature signature = thisJoinPointStaticPart.getSignature();
		Semaphore s = locks.get(signature);
		
		if (s == null) {
			s = new Semaphore(1);
			locks.put(s, s);
		}

		try {
			s.acquire();
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		
		Object ret = proceed();
		
		s.release();
		return ret;
	}
}
