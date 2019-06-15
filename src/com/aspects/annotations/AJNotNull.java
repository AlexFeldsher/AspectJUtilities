package com.aspects.annotations;
import java.lang.annotation.*;

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)

/**
 * Used to mark methods that must not get a null in its arguments
 * 
 */
public @interface AJNotNull {
	/**
	 * Type of response.
	 * Warning - print warning to stderr
	 * Exception - throw an exception
	 */
	public String type() default "Warning";
}
