package com.aspects.annotations;

import java.lang.annotation.*;

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)

/**
 * Annotation used to flag deprecated methods
 */
public @interface AJDeprecatedWarning {
	/**
	 * Handling type, "Warning" or "Exception"
	 * Warning - print a warning message to the stdout
	 * Exception - throw a DeprecatedException when method is called
	 */
	public String type() default "Warning";
}
