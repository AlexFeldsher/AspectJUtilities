package com.aspects.annotations;
import java.lang.annotation.*;

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)

/**
 * Used to flag methods to be run as a thread
 */
public @interface AJThread {

}
