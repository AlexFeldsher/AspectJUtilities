package com.aspects.annotations;
import java.lang.annotation.*;

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)

/**
 * Used to flag methods to be split into multiple threads
 */
public @interface AJSplit {
	/**
	 * Number of threads to create
	 */
	public int jobs() default 0;
}
